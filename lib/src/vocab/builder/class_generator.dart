// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:io';

import 'package:logging/logging.dart';
import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart' as path;

import 'cross_vocabulary_resolver.dart';
import 'model/vocabulary_model.dart';

/// Logger for class generator operations
final _log = Logger('VocabularyClassGenerator');

/// Generator for creating Dart classes from vocabulary models.
///
/// This class is responsible for generating well-formatted Dart code
/// representing a vocabulary, with proper class structure, documentation,
/// and type safety.
class VocabularyClassGenerator {
  /// Cross-vocabulary resolver for handling properties across vocabulary boundaries
  final CrossVocabularyResolver resolver;

  /// Output directory for generated files, used to determine if library declarations should be included
  final String outputDir;

  /// Cache for loaded Mustache templates
  final Map<String, Template> _templateCache = {};

  /// Base path for the template files
  late final String _templatePath;

  /// Creates a new vocabulary class generator.
  ///
  /// [resolver] Cross-vocabulary resolver for property inheritance across vocabularies
  /// [outputDir] Output directory for generated files, used to determine library declaration inclusion
  VocabularyClassGenerator({required this.resolver, required this.outputDir}) {
    // Determine the path where the templates are stored
    final scriptPath = path.fromUri(Platform.script);
    final currentDir = Directory.current.path;

    // First try to find templates relative to the current script
    var templateDir = path.join(path.dirname(scriptPath), 'templates');

    // If not found, try to locate them in the package
    if (!Directory(templateDir).existsSync()) {
      // Look for templates in the package's lib directory
      templateDir = path.join(
        currentDir,
        'lib',
        'src',
        'vocab',
        'builder',
        'templates',
      );
    }

    // If still not found, throw an error
    if (!Directory(templateDir).existsSync()) {
      throw StateError('Could not locate template directory at $templateDir');
    }

    _templatePath = templateDir;
    _log.fine('Using template directory: $_templatePath');
  }

  /// Loads and caches a template from the template directory
  Template _getTemplate(String templateName) {
    if (!_templateCache.containsKey(templateName)) {
      final templateFile = File(
        path.join(_templatePath, '$templateName.mustache'),
      );
      if (!templateFile.existsSync()) {
        throw StateError('Template file not found: ${templateFile.path}');
      }

      final templateSource = templateFile.readAsStringSync();
      _templateCache[templateName] = Template(
        templateSource,
        name: templateName,
        lenient: true,
        htmlEscapeValues: false, // Disable HTML escaping globally
      );
    }

    return _templateCache[templateName]!;
  }

  /// Generates Dart code for main vocabulary class.
  ///
  /// Returns a map containing all the generated code files:
  /// - 'main': The main vocabulary class (e.g. 'Rdf')
  /// - 'universal': The universal properties class (if applicable)
  /// - A key for each class name (e.g. 'RdfProperty') with its code
  Map<String, String> generateFiles(VocabularyModel model) {
    final Map<String, String> generatedFiles = {};

    // Validate model has terms
    _validateModelHasTerms(model);

    // Generate main vocabulary file
    final mainFile = _generateMainFile(model);
    generatedFiles['main'] = mainFile;

    // Generate UniversalProperties class if needed
    final universalProperties =
        model.properties.where((p) => p.domains.isEmpty).toList();
    if (universalProperties.isNotEmpty) {
      final universalFile = _generateUniversalPropertiesFile(
        model,
        universalProperties,
      );
      generatedFiles['universal'] = universalFile;
    }

    // Generate individual class files
    if (model.classes.isNotEmpty) {
      for (final rdfClass in model.classes) {
        final dartClassName = _dartIdentifier(rdfClass.localName);
        final classFile = _generateClassFile(model, rdfClass);
        generatedFiles[dartClassName] = classFile;
      }
    }

    return generatedFiles;
  }

  /// For backward compatibility with existing tests and integrations.
  /// Generates all code artifacts and combines them into a single string.
  String generate(VocabularyModel model) {
    _validateModelHasTerms(model);

    // Debug log to help identify issues with test failures
    for (final rdfClass in model.classes) {
      _log.info('Class: ${rdfClass.localName}, SeeAlso: ${rdfClass.seeAlso}');
    }
    for (final prop in model.properties) {
      _log.info('Property: ${prop.localName}, Ranges: ${prop.ranges}');
    }

    final files = generateFiles(model);
    final buffer = StringBuffer();

    // First add the main file
    buffer.write(files['main']);
    buffer.write('\n');

    // Add universal properties if they exist
    if (files.containsKey('universal')) {
      buffer.write(files['universal']);
      buffer.write('\n');
    }

    // Add all class-specific files
    // Sort keys for deterministic output
    final classKeys =
        files.keys.where((k) => k != 'main' && k != 'universal').toList()
          ..sort();

    for (final key in classKeys) {
      buffer.write(files[key]);
      buffer.write('\n');
    }

    return buffer.toString();
  }

  /// Generates the main vocabulary file
  String _generateMainFile(VocabularyModel model) {
    final className = _capitalize(model.name);

    // Create the data model for the template
    final Map<String, dynamic> templateData = {
      'addLibraryDeclaration': !outputDir.contains('/src/'),
      'libraryDocumentation': '${className} Vocabulary',
      'libraryName': '${model.prefix}_vocab',
      'imports': [],
      'className': className,
      'namespace': model.namespace,
      'prefix': model.prefix,
      'vocabPrefix': model.prefix.toLowerCase(),
      'terms': _prepareTermsForTemplate([
        ...model.classes,
        ...model.datatypes,
        ...model.otherTerms,
        ...model.properties,
      ], model.prefix),
    };

    // Render the header and main class templates
    final headerTemplate = _getTemplate('header');
    final mainClassTemplate = _getTemplate('main_class');

    return headerTemplate.renderString(templateData) +
        mainClassTemplate.renderString(templateData);
  }

  /// Generates the universal properties file
  String _generateUniversalPropertiesFile(
    VocabularyModel model,
    List<VocabularyProperty> universalProperties,
  ) {
    final className = _capitalize(model.name);
    final universalClassName = '${className}UniversalProperties';

    // Create the data model for the template
    final Map<String, dynamic> templateData = {
      'addLibraryDeclaration': !outputDir.contains('/src/'),
      'libraryDocumentation':
          'Universal Properties for the ${className} vocabulary',
      'libraryName': '${model.prefix}_universal_vocab',
      'imports': [],
      'className': className,
      'universalClassName': universalClassName,
      'namespace': model.namespace,
      'prefix': model.prefix,
      'vocabPrefix': model.prefix.toLowerCase(),
      'properties': _preparePropertiesForTemplate(
        universalProperties,
        model.prefix,
        model.namespace,
      ),
    };

    // Render the header and universal properties templates
    final headerTemplate = _getTemplate('header');
    final universalTemplate = _getTemplate('universal_properties');

    return headerTemplate.renderString(templateData) +
        universalTemplate.renderString(templateData);
  }

  /// Generates a class file for a specific RDF class
  String _generateClassFile(VocabularyModel model, VocabularyClass rdfClass) {
    final className = _capitalize(model.name);
    final dartClassName = '${className}${_dartIdentifier(rdfClass.localName)}';

    // Get all properties that can be used with this class
    final properties = resolver.getPropertiesForClass(
      rdfClass.iri,
      model.namespace,
    );

    // Get all parent classes for documentation
    final allSuperClasses = resolver.getAllClassTypes(rdfClass.iri);
    final superClassList =
        allSuperClasses.where((superClass) => superClass != rdfClass.iri).map((
          superClass,
        ) {
          return {
            'iri': superClass,
            'readableName': _extractReadableNameFromIri(superClass),
          };
        }).toList();

    // Sort parent classes for consistent output
    superClassList.sort(
      (a, b) =>
          (a['readableName'] as String).compareTo(b['readableName'] as String),
    );

    // Create the data model for the template
    final Map<String, dynamic> templateData = {
      'addLibraryDeclaration': !outputDir.contains('/src/'),
      'libraryDocumentation':
          '${rdfClass.localName} class from ${className} vocabulary',
      'libraryName': '${model.prefix}_${dartClassName.toLowerCase()}_vocab',
      'imports': [],
      'className': className,
      'dartClassName': dartClassName,
      'localName': rdfClass.localName,
      'classIri': rdfClass.iri,
      'comment': _formatDartDocComment(rdfClass.comment),
      'namespace': model.namespace,
      'seeAlso': rdfClass.seeAlso,
      'superClasses': superClassList,
      'hasSuperClasses': superClassList.isNotEmpty,
      'properties': _preparePropertiesForTemplate(
        properties,
        model.prefix,
        model.namespace,
      ),
    };

    // Render the header and class template
    final headerTemplate = _getTemplate('header');
    final classTemplate = _getTemplate('class');

    return headerTemplate.renderString(templateData) +
        classTemplate.renderString(templateData);
  }

  /// Prepares a list of terms for use in a template
  List<Map<String, dynamic>> _prepareTermsForTemplate(
    List<VocabularyTerm> terms,
    String prefix,
  ) {
    return terms.map((term) {
      final Map<String, dynamic> result = {
        'localName': term.localName,
        'iri': term.iri,
        'dartName': _dartIdentifier(term.localName),
        'comment': _formatDartDocComment(term.comment),
        'vocabPrefix': prefix.toLowerCase(),
        'seeAlso': term.seeAlso,
        'hasSeeAlso': term.seeAlso.isNotEmpty,
      };

      // Add range information if the term is a property
      if (term is VocabularyProperty) {
        result['ranges'] = _toMustacheList(term.ranges);
        result['hasRanges'] = term.ranges.isNotEmpty;
        // Add domain information for properties
        result['domainDescription'] = _getDomainDescription(term, null);
        result['domains'] = term.domains;
      }

      return result;
    }).toList();
  }

  /// Enriches a list of strings for Mustache templating.
  /// Each element becomes a map with `value` and `last`.
  List<Map<String, dynamic>> _toMustacheList(List<String> values) {
    return List.generate(values.length, (i) {
      return {'value': values[i], 'last': i == values.length - 1};
    });
  }

  /// Prepares a list of properties for use in a template
  List<Map<String, dynamic>> _preparePropertiesForTemplate(
    List<VocabularyProperty> properties,
    String prefix,
    String classNamespace,
  ) {
    return properties.map((property) {
      final propertyName = _getPropertyName(property, classNamespace);
      final externalPrefix = _getPropertyPrefix(property, classNamespace);
      return {
        'localName': property.localName,
        'iri': property.iri,
        'dartName': propertyName,
        'comment': _formatDartDocComment(property.comment),
        'vocabPrefix': prefix.toLowerCase(),
        'domainDescription': _getDomainDescription(property, classNamespace),
        'domains': property.domains,
        'ranges': _toMustacheList(property.ranges),
        'hasRanges': property.ranges.isNotEmpty,
        'seeAlso': property.seeAlso,
        'hasSeeAlso': property.seeAlso.isNotEmpty,
        'externalPrefix': externalPrefix,
      };
    }).toList();
  }

  /// Validates that the model contains at least some terms (classes, properties, datatypes, or other terms).
  /// Throws an exception if the model is empty.
  void _validateModelHasTerms(VocabularyModel model) {
    final hasTerms =
        model.classes.isNotEmpty ||
        model.properties.isNotEmpty ||
        model.datatypes.isNotEmpty ||
        model.otherTerms.isNotEmpty;

    if (!hasTerms) {
      throw StateError(
        'No terms found for vocabulary: ${model.name} (${model.namespace}). '
        'The vocabulary source may be inaccessible or incorrectly formatted.',
      );
    }
  }

  /// Extracts a human-readable name from an IRI
  String _extractReadableNameFromIri(String iri) {
    // Try to extract the name after the last # or /
    final hashIndex = iri.lastIndexOf('#');
    if (hashIndex != -1 && hashIndex < iri.length - 1) {
      return iri.substring(hashIndex + 1);
    }

    final slashIndex = iri.lastIndexOf('/');
    if (slashIndex != -1 && slashIndex < iri.length - 1) {
      return iri.substring(slashIndex + 1);
    }

    // Fallback to the full IRI
    return iri;
  }

  /// Gets a property name with prefix if it comes from a different namespace
  String _getPropertyName(VocabularyTerm term, String? classNamespace) {
    final dartName = _dartIdentifier(term.localName);
    final propertyPrefix = _getPropertyPrefix(term, classNamespace);
    // If classNamespace is null, we're generating the main class (no prefix needed)
    return propertyPrefix == null
        ? dartName
        : '${propertyPrefix}${_capitalize(dartName)}';
  }

  String? _getPropertyPrefix(VocabularyTerm term, String? classNamespace) {
    // If classNamespace is null, we're generating the main class (no prefix needed)
    if (classNamespace == null) return null;

    // If the property belongs to a different namespace than the class,
    // prefix it to avoid naming conflicts
    if (!term.iri.startsWith(classNamespace)) {
      // Extract the namespace from the IRI
      final namespace = _extractNamespace(term.iri);
      if (namespace != null && namespace != classNamespace) {
        final prefix = _getNamespacePrefix(namespace);
        if (prefix != null) {
          return prefix;
        }
      }
    }

    return null;
  }

  /// Extracts the namespace from an IRI
  String? _extractNamespace(String iri) {
    // First try to extract namespace ending with a hash
    var hashIndex = iri.lastIndexOf('#');
    if (hashIndex >= 0) {
      return iri.substring(0, hashIndex + 1);
    }

    // Then try to extract namespace ending with a slash
    var lastSlashIndex = iri.lastIndexOf('/');
    if (lastSlashIndex >= 0) {
      var beforeLastSlashIndex = iri
          .substring(0, lastSlashIndex)
          .lastIndexOf('/');
      if (beforeLastSlashIndex >= 0) {
        return iri.substring(0, lastSlashIndex + 1);
      }
    }

    return null;
  }

  /// Get the preferred prefix for a namespace
  String? _getNamespacePrefix(String namespace) {
    // Common namespace prefixes
    final prefixMap = {
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#': 'rdf',
      'http://www.w3.org/2000/01/rdf-schema#': 'rdfs',
      'http://www.w3.org/2001/XMLSchema#': 'xsd',
      'http://www.w3.org/2002/07/owl#': 'owl',
      'http://purl.org/dc/elements/1.1/': 'dc',
      'http://purl.org/dc/terms/': 'dcterms',
      'http://xmlns.com/foaf/0.1/': 'foaf',
      'http://www.w3.org/2004/02/skos/core#': 'skos',
      'http://www.w3.org/2006/vcard/ns#': 'vcard',
      'http://www.w3.org/ns/auth/acl#': 'acl',
      'http://www.w3.org/ns/ldp#': 'ldp',
      'http://schema.org/': 'schema',
      'http://www.w3.org/ns/solid/terms#': 'solid',
    };

    return prefixMap[namespace];
  }

  /// Provides documentation about property domain applicability
  String _getDomainDescription(
    VocabularyProperty property,
    String? classNamespace,
  ) {
    if (property.domains.isNotEmpty) {
      return "Can be used on: ${property.domains.join(', ')}";
    }

    // For properties without explicit domains but in the same vocabulary
    return "Can be used on all classes in this vocabulary";
  }

  /// Converts a local name to a valid Dart identifier.
  String _dartIdentifier(String localName) {
    // Special case handling for names that would result in invalid Dart identifiers
    if (localName.startsWith('_')) {
      return 'underscore${localName.substring(1)}';
    }

    if (localName.startsWith(RegExp(r'\d'))) {
      return 'n$localName';
    }

    // Replace characters that are not valid in Dart identifiers
    return localName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
  }

  /// Capitalizes the first letter of a string.
  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  /// Formats a potentially multiline comment for Dart documentation.
  /// Each line will be properly prefixed with /// for Dart doc comments.
  String _formatDartDocComment(String? comment) {
    if (comment == null || comment.isEmpty) {
      return '';
    }

    // Split the comment into lines
    var lines = comment.split('\n');

    // Replace all instances of [[ and ]] in comments to avoid dartdoc interpreting them as references
    lines =
        lines
            .map((line) => line.replaceAll('[[', '{[').replaceAll(']]', ']}'))
            .toList();

    // Format each line with the Dart doc prefix
    return lines.map((line) => line.trim()).join('\n/// ');
  }
}
