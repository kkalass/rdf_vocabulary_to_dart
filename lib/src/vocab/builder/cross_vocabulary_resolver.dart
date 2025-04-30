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

  /// Well-known global resource types that all other types implicitly inherit from
  static const _globalResourceTypes = {
    'http://www.w3.org/2000/01/rdf-schema#Resource',
    'http://www.w3.org/2002/07/owl#Thing',
  };

  /// Creates a new cross-vocabulary resolver.
  CrossVocabularyResolver();

  /// Registers a vocabulary model with the resolver.
  ///
  /// This method processes the class hierarchy and property domains
  /// from the provided vocabulary model and integrates them into
  /// the global resolution context.
  void registerVocabulary(VocabularyModel model) {
    _log.info('Registering vocabulary: ${model.name} (${model.namespace})');

    // Register classes and their superclasses
    for (final rdfClass in model.classes) {
      final classIri = rdfClass.iri;

      // Register direct superclasses
      if (rdfClass.superClasses.isNotEmpty) {
        _directSuperClasses[classIri] = Set.from(rdfClass.superClasses);
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
      } else {
        // Properties with no explicit domain can apply to any resource
        _propertyDomains[property.iri] = Set.from(_globalResourceTypes);
      }
    }

    if (vocabProperties.isNotEmpty) {
      _vocabularyProperties[model.namespace] = vocabProperties;
    }

    // Rebuild the transitive closure of the class hierarchy
    _rebuildClassHierarchy();
  }

  /// Rebuilds the transitive closure of the class hierarchy.
  void _rebuildClassHierarchy() {
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

    _log.fine(
      'Computed class hierarchy (total classes: ${_allSuperClasses.length})',
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

    // For this vocabulary namespace
    final vocabProperties = _vocabularyProperties[vocabNamespace] ?? {};
    for (final property in vocabProperties) {
      // If property has no domains, it can be used with any class
      if (_propertyDomains[property.iri] == null ||
          _propertyDomains[property.iri]!.isEmpty) {
        result.add(property);
        continue;
      }

      // Check if any domain of the property is compatible with this class or its superclasses
      final domains = _propertyDomains[property.iri] ?? {};
      for (final domain in domains) {
        if (allClassTypes.contains(domain)) {
          result.add(property);
          break;
        }
      }
    }

    return result.toList();
  }

  /// Gets all applicable properties for a class from all registered vocabularies.
  ///
  /// This method is similar to [getPropertiesForClass] but returns properties
  /// from all vocabularies, not just the specified one.
  ///
  /// [classIri] The IRI of the class to get properties for
  List<VocabularyProperty> getAllPropertiesForClass(String classIri) {
    final result = <VocabularyProperty>{};

    // Get the full set of classes (this class and all its superclasses)
    final allClassTypes = {
      classIri,
      ...(_allSuperClasses[classIri] ?? {}),
      ..._globalResourceTypes,
    };

    // Iterate through all vocabularies and collect applicable properties
    for (final entry in _vocabularyProperties.entries) {
      final properties = entry.value;

      for (final property in properties) {
        // Properties with no domain can be used with any class
        if (_propertyDomains[property.iri] == null ||
            _propertyDomains[property.iri]!.isEmpty) {
          result.add(property);
          continue;
        }

        // Check if any domain of the property is compatible with this class or its superclasses
        final domains = _propertyDomains[property.iri] ?? {};
        for (final domain in domains) {
          if (allClassTypes.contains(domain)) {
            result.add(property);
            break;
          }
        }
      }
    }

    return result.toList();
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
    final result = <VocabularyProperty>{};

    // Get the full set of classes (this class and all its superclasses)
    final allClassTypes = {
      classIri,
      ...(_allSuperClasses[classIri] ?? {}),
      ..._globalResourceTypes,
    };

    // Iterate through all vocabularies except the source vocabulary
    for (final entry in _vocabularyProperties.entries) {
      final vocabNamespace = entry.key;

      // Skip the source vocabulary
      if (vocabNamespace == sourceVocabNamespace) {
        continue;
      }

      final properties = entry.value;

      for (final property in properties) {
        // Properties with no domain can be used with any class
        if (_propertyDomains[property.iri] == null ||
            _propertyDomains[property.iri]!.isEmpty) {
          result.add(property);
          continue;
        }

        // Check if any domain of the property is compatible with this class or its superclasses
        final domains = _propertyDomains[property.iri] ?? {};
        for (final domain in domains) {
          if (allClassTypes.contains(domain)) {
            result.add(property);
            break;
          }
        }
      }
    }

    return result.toList();
  }
}
