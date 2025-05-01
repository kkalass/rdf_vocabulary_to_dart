// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import '../../../rdf_core.dart';
import 'model/vocabulary_model.dart';

/// Logger for cross-vocabulary operations
final _log = Logger('CrossVocabularyResolver');

/// Manages the global class hierarchy and property applicability across vocabulary boundaries.
///
/// This resolver is responsible for tracking class inheritance and property domains
/// when vocabularies reference each other. It ensures that classes correctly
/// inherit properties from their superclasses, even when those superclasses
/// are defined in different vocabularies.
class CrossVocabularyResolver {
  /// Map of class IRIs to their direct superclass IRIs
  final Map<String, Set<String>> _directSuperClasses = {};

  /// Map of class IRIs to their full set of superclass IRIs (transitive closure)
  final Map<String, Set<String>> _allSuperClasses = {};

  /// Map of property IRIs to their domain IRIs
  final Map<String, Set<String>> _propertyDomains = {};

  /// Map of vocabulary namespaces to their properties
  final Map<String, Set<VocabularyProperty>> _vocabularyProperties = {};

  /// Map of vocabulary names to their models
  final Map<String, VocabularyModel> _vocabularyModels = {};

  /// Set of namespace IRIs that have been registered
  final Set<String> _registeredNamespaces = {};

  /// Set of namespace IRIs that are implied by references but not explicitly registered
  final Set<String> _pendingNamespaces = {};

  /// Cache of resolved external properties by class IRI
  final Map<String, List<VocabularyProperty>> _externalPropertyCache = {};

  /// Well-known global resource types that all other types implicitly inherit from
  static const _globalResourceTypes = {
    'http://www.w3.org/2000/01/rdf-schema#Resource',
    'http://www.w3.org/2002/07/owl#Thing',
  };

  // FIXME: better just grep for @prefix in the turtle vocabularies
  /// Map of known namespaces to vocabulary names
  static const _knownNamespaceToVocab = {
    'http://www.w3.org/1999/02/22-rdf-syntax-ns#': 'rdf',
    'http://www.w3.org/2000/01/rdf-schema#': 'rdfs',
    'http://www.w3.org/2001/XMLSchema#': 'xsd',
    'http://www.w3.org/2002/07/owl#': 'owl',
  };

  /// Function to load an implied vocabulary model if available
  final Future<VocabularyModel?> Function(String namespace, String name)?
  _vocabularyLoader;

  /// Creates a new cross-vocabulary resolver.
  ///
  /// [vocabularyLoader] Optional function to load implied vocabulary models
  CrossVocabularyResolver({
    Future<VocabularyModel?> Function(String namespace, String name)?
    vocabularyLoader,
  }) : _vocabularyLoader = vocabularyLoader;

  /// Registers a vocabulary model with the resolver.
  ///
  /// This method processes the class hierarchy and property domains
  /// from the provided vocabulary model and integrates them into
  /// the global resolution context.
  void registerVocabulary(VocabularyModel model) {
    _log.info('Registering vocabulary: ${model.name} (${model.namespace})');

    // Store the vocabulary model
    _vocabularyModels[model.name] = model;
    _registeredNamespaces.add(model.namespace);

    // Register classes and their superclasses
    for (final rdfClass in model.classes) {
      final classIri = rdfClass.iri;

      // Register direct superclasses and track potential external vocabularies
      if (rdfClass.superClasses.isNotEmpty) {
        _directSuperClasses[classIri] = Set.from(rdfClass.superClasses);

        // Check for superclasses from other vocabularies
        for (final superClass in rdfClass.superClasses) {
          final superNamespace = _extractNamespace(superClass);
          if (superNamespace != null &&
              superNamespace != model.namespace &&
              !_registeredNamespaces.contains(superNamespace)) {
            _pendingNamespaces.add(superNamespace);
            _log.info(
              'Found reference to external vocabulary: $superNamespace',
            );
          }
        }
      } else {
        // If no superclasses specified and this isn't a global type itself,
        // assume it's a direct subclass of the global resource types
        if (!_globalResourceTypes.contains(classIri)) {
          _directSuperClasses[classIri] = Set.from(_globalResourceTypes);
        }
      }
    }

    // Register properties and their domains
    final vocabProperties = <VocabularyProperty>{};
    for (final property in model.properties) {
      vocabProperties.add(property);

      if (property.domains.isNotEmpty) {
        _propertyDomains[property.iri] = Set.from(property.domains);

        // Check for domains from other vocabularies
        for (final domain in property.domains) {
          final domainNamespace = _extractNamespace(domain);
          if (domainNamespace != null &&
              domainNamespace != model.namespace &&
              !_registeredNamespaces.contains(domainNamespace)) {
            _pendingNamespaces.add(domainNamespace);
            _log.info(
              'Found reference to external vocabulary: $domainNamespace',
            );
          }
        }
      } else {
        // For properties without explicit domains, don't automatically assign to global resources
        // This ensures that namespace-specific predicates stay within their namespace
        _propertyDomains[property.iri] = <String>{};

        _log.fine(
          'Property ${property.iri} has no explicit domain, ' +
              'will only be available within ${model.name} vocabulary',
        );
      }
    }

    if (vocabProperties.isNotEmpty) {
      _vocabularyProperties[model.namespace] = vocabProperties;
    }

    // Clear caches as the hierarchy has changed
    _externalPropertyCache.clear();

    // Rebuild the transitive closure of the class hierarchy
    _rebuildClassHierarchy();
  }

  /// Extracts the namespace from an IRI
  String? _extractNamespace(String iri) {
    // Check known namespaces first
    for (final entry in _knownNamespaceToVocab.entries) {
      if (iri.startsWith(entry.key)) {
        return entry.key;
      }
    }

    // Try to extract namespace by finding the last # or / character
    final hashIndex = iri.lastIndexOf('#');
    if (hashIndex != -1) {
      return iri.substring(0, hashIndex + 1);
    }

    final slashIndex = iri.lastIndexOf('/');
    if (slashIndex != -1) {
      return iri.substring(0, slashIndex + 1);
    }

    return null;
  }

  /// Attempts to load any pending vocabularies that were referenced but not registered
  Future<void> loadPendingVocabularies() async {
    if (_vocabularyLoader == null || _pendingNamespaces.isEmpty) {
      return;
    }

    _log.info(
      'Attempting to load ${_pendingNamespaces.length} pending vocabularies',
    );

    // Process only the current pending namespaces (as loading might add more)
    final namespacesToProcess = Set<String>.from(_pendingNamespaces);
    _pendingNamespaces.clear();

    for (final namespace in namespacesToProcess) {
      if (_registeredNamespaces.contains(namespace)) {
        continue; // Already registered while processing this loop
      }

      // Try to determine the vocabulary name
      String? name = _knownNamespaceToVocab[namespace];
      if (name == null) {
        // Extract a name from the namespace as fallback
        final uri = Uri.parse(namespace);
        name =
            uri.pathSegments.isNotEmpty
                ? uri.pathSegments.last.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                : 'vocabulary';
      }

      _log.info(
        'Attempting to load vocabulary "$name" from namespace $namespace',
      );

      // Try to load the vocabulary
      final model = await _vocabularyLoader!(namespace, name);
      if (model != null) {
        registerVocabulary(model);
      } else {
        _log.warning(
          'Failed to load implied vocabulary from namespace: $namespace',
        );
      }
    }

    // If new pending namespaces were discovered during loading, process them too
    if (_pendingNamespaces.isNotEmpty) {
      await loadPendingVocabularies();
    }
  }

  /// Rebuilds the transitive closure of the class hierarchy.
  void _rebuildClassHierarchy() {
    _log.fine('Rebuilding class hierarchy');
    _allSuperClasses.clear();

    // Initialize with direct superclasses
    for (final entry in _directSuperClasses.entries) {
      _allSuperClasses[entry.key] = Set.from(entry.value);
    }

    // Compute transitive closure using a fixed-point algorithm
    bool changed;
    do {
      changed = false;

      for (final classIri in _allSuperClasses.keys) {
        final currentSuperClasses = Set<String>.from(
          _allSuperClasses[classIri] ?? {},
        );
        final newSuperClasses = Set<String>.from(currentSuperClasses);

        // Add parent's parents
        for (final parentIri in currentSuperClasses.toList()) {
          final grandparents = _allSuperClasses[parentIri] ?? {};
          newSuperClasses.addAll(grandparents);
        }

        // If we've added new superclasses, update and flag for another iteration
        if (newSuperClasses.length > currentSuperClasses.length) {
          _allSuperClasses[classIri] = newSuperClasses;
          changed = true;
        }
      }
    } while (changed);

    // Debug output
    for (final entry in _allSuperClasses.entries) {
      _log.fine('Class ${entry.key} inherits from: ${entry.value.join(', ')}');
    }

    _log.info(
      'Completed class hierarchy computation (total classes: ${_allSuperClasses.length})',
    );
  }

  /// Gets all applicable properties for a class across all vocabularies.
  ///
  /// This method returns all properties that can be used with the given class,
  /// including those inherited from superclasses, even when those superclasses
  /// are defined in different vocabularies.
  ///
  /// [classIri] The IRI of the class to get properties for
  /// [vocabNamespace] The namespace of the current vocabulary (used to filter properties)
  List<VocabularyProperty> getPropertiesForClass(
    String classIri,
    String vocabNamespace,
  ) {
    final result = <VocabularyProperty>{};

    // Get the full set of classes (this class and all its superclasses)
    final allClassTypes = {
      classIri,
      ...(_allSuperClasses[classIri] ?? {}),
      ..._globalResourceTypes,
    };

    _log.fine('Getting properties for $classIri in namespace $vocabNamespace');
    _log.fine('Class hierarchy: ${allClassTypes.join(', ')}');

    // First add properties from this vocabulary namespace
    final vocabProperties = _vocabularyProperties[vocabNamespace] ?? {};
    for (final property in vocabProperties) {
      // Properties from the same namespace with no domains are considered "universal" to that namespace
      if (_propertyDomains[property.iri] == null ||
          _propertyDomains[property.iri]!.isEmpty) {
        result.add(property);
        _log.fine(
          'Added universal property ${property.iri} from same namespace',
        );
        continue;
      }

      // Check if any domain of the property is compatible with this class or its superclasses
      final domains = _propertyDomains[property.iri] ?? {};
      for (final domain in domains) {
        if (allClassTypes.contains(domain)) {
          result.add(property);
          _log.fine('Added property ${property.iri} due to domain $domain');
          break;
        }
      }
    }

    // Then add properties from external vocabularies that apply to this class
    final externalProperties = _getExternalPropertiesForClass(
      classIri,
      vocabNamespace,
    );
    result.addAll(externalProperties);

    return result.toList();
  }

  /// Gets properties from external vocabularies that apply to a given class
  Set<VocabularyProperty> _getExternalPropertiesForClass(
    String classIri,
    String currentNamespace,
  ) {
    // Check cache first
    final cacheKey = '$classIri|$currentNamespace';
    if (_externalPropertyCache.containsKey(cacheKey)) {
      return Set.from(_externalPropertyCache[cacheKey]!);
    }

    final result = <VocabularyProperty>{};

    // Get the full set of classes (this class and all its superclasses)
    final allClassTypes = {
      classIri,
      ...(_allSuperClasses[classIri] ?? {}),
      ..._globalResourceTypes,
    };

    // Add properties from all other vocabularies
    for (final entry in _vocabularyProperties.entries) {
      final vocabNamespace = entry.key;

      // Skip the current vocabulary namespace
      if (vocabNamespace == currentNamespace) {
        continue;
      }

      final properties = entry.value;
      for (final property in properties) {
        // Only include properties with explicit domains that match this class
        // Properties without explicit domains are kept within their own vocabulary
        if (_propertyDomains[property.iri] == null ||
            _propertyDomains[property.iri]!.isEmpty) {
          continue;
        }

        // Check if any domain of the property is compatible with this class or its superclasses
        final domains = _propertyDomains[property.iri] ?? {};
        for (final domain in domains) {
          if (allClassTypes.contains(domain)) {
            result.add(property);
            _log.fine(
              'Added external property ${property.iri} due to domain $domain',
            );
            break;
          }
        }
      }
    }

    // Cache the result
    _externalPropertyCache[cacheKey] = result.toList();
    return result;
  }

  /// Gets all applicable cross-vocabulary properties for a class.
  ///
  /// This method returns properties from other vocabularies (not the source vocabulary)
  /// that can be used with the given class due to inheritance.
  ///
  /// [classIri] The IRI of the class to get properties for
  /// [sourceVocabNamespace] The namespace of the source vocabulary to exclude
  List<VocabularyProperty> getCrossVocabPropertiesForClass(
    String classIri,
    String sourceVocabNamespace,
  ) {
    return _getExternalPropertiesForClass(
      classIri,
      sourceVocabNamespace,
    ).toList();
  }

  /// Gets debug information about a class's inheritance hierarchy
  Map<String, dynamic> getClassInheritanceDebugInfo(String classIri) {
    return {
      'class': classIri,
      'directSuperclasses': _directSuperClasses[classIri]?.toList() ?? [],
      'allSuperclasses': _allSuperClasses[classIri]?.toList() ?? [],
      'applicablePropertiesByVocabulary':
          _vocabularyProperties.entries
              .map((entry) {
                final namespace = entry.key;
                final properties =
                    entry.value
                        .where((prop) {
                          final domains = _propertyDomains[prop.iri] ?? {};
                          if (domains.isEmpty) return true;

                          final allTypes = {
                            classIri,
                            ...(_allSuperClasses[classIri] ?? {}),
                            ..._globalResourceTypes,
                          };

                          return domains.any(
                            (domain) => allTypes.contains(domain),
                          );
                        })
                        .map((p) => p.iri)
                        .toList();

                return MapEntry(namespace, properties);
              })
              .where((e) => e.value.isNotEmpty)
              .toList(),
    };
  }
}
