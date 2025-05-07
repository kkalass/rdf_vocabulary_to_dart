// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:logging/logging.dart';

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

  /// Creates a new vocabulary class generator.
  ///
  /// [resolver] Cross-vocabulary resolver for property inheritance across vocabularies
  /// [outputDir] Output directory for generated files, used to determine library declaration inclusion
  const VocabularyClassGenerator({
    required this.resolver,
    required this.outputDir,
  });

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
    final mainBuffer = StringBuffer();

    // Add header and copyright
    _writeHeader(mainBuffer);

    // Write imports first
    _writeImports(mainBuffer);

    // Write main class documentation directly above the class declaration
    _writeMainClassDoc(mainBuffer, model);

    // Write primary class containing all terms
    _writePrimaryClass(mainBuffer, model);

    // Add the main class to results
    generatedFiles['main'] = mainBuffer.toString();

    // Generate UniversalProperties class if needed
    final universalProperties =
        model.properties.where((p) => p.domains.isEmpty).toList();
    if (universalProperties.isNotEmpty) {
      final universalBuffer = StringBuffer();

      // Add header
      _writeHeader(universalBuffer);

      // Write imports first
      _writeImports(universalBuffer);
      _writeUniversalPropertiesImport(universalBuffer, model);

      // Write universal properties documentation directly above the class
      _writeUniversalPropertiesDoc(universalBuffer, model);

      // Write the universal properties class
      _writeUniversalPropertiesClass(universalBuffer, model);

      // Add the universal class to results
      generatedFiles['universal'] = universalBuffer.toString();
    }

    // Generate individual class files
    if (model.classes.isNotEmpty) {
      final className = _capitalize(model.name);
      final classHierarchy = _buildClassHierarchy(model);
      final propertyMap = {for (final prop in model.properties) prop.iri: prop};

      for (final rdfClass in model.classes) {
        final classBuffer = StringBuffer();
        final dartClassName = _dartIdentifier(rdfClass.localName);

        // Add header
        _writeHeader(classBuffer);

        // Write imports first
        _writeImports(classBuffer);
        _writeClassImport(classBuffer, model);

        // Write class documentation just before the class declaration
        _writeClassDoc(classBuffer, model, rdfClass, className);

        // Write the individual class
        _writeIndividualClass(
          classBuffer,
          model,
          rdfClass,
          classHierarchy,
          propertyMap,
        );

        // Add the class file to results
        generatedFiles[dartClassName] = classBuffer.toString();
      }
    }

    return generatedFiles;
  }

  /// For backward compatibility
  String generate(VocabularyModel model) {
    final buffer = StringBuffer();

    // Validate model has terms
    _validateModelHasTerms(model);

    // Add header and copyright
    _writeHeader(buffer);

    // Write library documentation and declaration first
    _writeLibraryDoc(buffer, model);

    // Import necessary packages (after library declaration)
    _writeImports(buffer);

    // Write primary class containing all terms
    _writePrimaryClass(buffer, model);

    // Write individual class for each RDF class
    _writeIndividualClasses(buffer, model);

    return buffer.toString();
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

  /// Writes the file header with copyright information.
  void _writeHeader(StringBuffer buffer) {
    buffer.writeln('// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>');
    buffer.writeln(
      '// All rights reserved. Use of this source code is governed by a BSD-style',
    );
    buffer.writeln('// license that can be found in the LICENSE file.');
    buffer.writeln();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('// Generated by VocabularyBuilder');
    buffer.writeln();
  }

  /// Writes the required imports for the generated file.
  void _writeImports(StringBuffer buffer) {
    buffer.writeln("import 'package:rdf_core/rdf_core.dart';");
    buffer.writeln();
  }

  /// Writes import statement for the main vocabulary class in class-specific files
  void _writeClassImport(StringBuffer buffer, VocabularyModel model) {
    // currently not needed

    //final name = model.name.toLowerCase();
    //buffer.writeln("import '../$name.dart';");
    //buffer.writeln();
  }

  /// Writes import statement for the main vocabulary class in universal properties file
  void _writeUniversalPropertiesImport(
    StringBuffer buffer,
    VocabularyModel model,
  ) {
    final name = model.name.toLowerCase();
    buffer.writeln("import './$name.dart';");
    buffer.writeln();
  }

  /// Writes the library documentation.
  void _writeLibraryDoc(
    StringBuffer buffer,
    VocabularyModel model, {
    bool isMainFile = false,
    bool isUniversalFile = false,
    String? className,
  }) {
    final name = _capitalize(model.name);
    final hasUniversalProperties = model.properties.any(
      (p) => p.domains.isEmpty,
    );
    final universalClassName = '${name}UniversalProperties';

    if (isMainFile) {
      buffer.writeln('/// $name Vocabulary');
      buffer.writeln('///');
      buffer.writeln(
        '/// Provides constants for the ${name.toUpperCase()} vocabulary',
      );
      buffer.writeln('/// (${model.namespace}).');
      buffer.writeln('///');
      buffer.writeln('/// Example usage:');
      buffer.writeln('/// ```dart');
      buffer.writeln(
        '/// import \'package:rdf_vocabulary_to_dart/vocab.dart\';',
      );

      if (model.properties.isNotEmpty) {
        final exampleProp = _dartIdentifier(model.properties.first.localName);
        buffer.writeln(
          '/// final property = ${name}.$exampleProp; // Access property directly from main class',
        );
      }

      if (model.classes.isNotEmpty) {
        final exampleClass = _dartIdentifier(model.classes.first.localName);
        buffer.writeln(
          '/// final classIri = ${name}$exampleClass.classIri; // Access class IRI',
        );

        if (model.properties.isNotEmpty) {
          final exampleProp = _dartIdentifier(model.properties.first.localName);
          buffer.writeln(
            '/// final property = ${name}$exampleClass.$exampleProp; // Access property from class',
          );
        }
      }

      if (hasUniversalProperties) {
        final universalProp = _dartIdentifier(
          model.properties.firstWhere((p) => p.domains.isEmpty).localName,
        );
        buffer.writeln(
          '/// final universalProp = $universalClassName.$universalProp; // Access universal property',
        );
      }

      buffer.writeln('/// ```');
      buffer.writeln('///');
      buffer.writeln(
        '/// All constants are pre-constructed as IriTerm objects to enable direct use in',
      );
      buffer.writeln(
        '/// constructing RDF graphs without repeated string concatenation or term creation.',
      );

      if (hasUniversalProperties) {
        buffer.writeln('///');
        buffer.writeln('/// Universal Properties:');
        buffer.writeln(
          '/// This vocabulary provides a `$universalClassName` class for properties',
        );
        buffer.writeln(
          '/// that have no explicitly defined domain restrictions and can be applied',
        );
        buffer.writeln('/// to any resource in this vocabulary\'s context.');
      }

      buffer.writeln('///');
      buffer.writeln('/// [Vocabulary Reference](${model.namespace})');

      // Only add library declaration for the main file which is not in src/
      if (!outputDir.contains('/src/')) {
        buffer.writeln('library ${model.prefix}_vocab;');
      }
      buffer.writeln();
    } else if (isUniversalFile) {
      buffer.writeln('/// Universal Properties for the ${name} vocabulary');
      buffer.writeln('///');
      buffer.writeln(
        '/// Universal properties are RDF properties that have no explicitly defined domain',
      );
      buffer.writeln(
        '/// and can therefore be applied to any resource within this vocabulary\'s context.',
      );
      buffer.writeln('///');
      buffer.writeln('/// [Vocabulary Reference](${model.namespace})');

      // Only add library declaration for files not in src/
      if (!outputDir.contains('/src/')) {
        buffer.writeln('library ${model.prefix}_universal_vocab;');
      }
      buffer.writeln();
    } else if (className != null) {
      final rdfClass = model.classes.firstWhere(
        (c) => _dartIdentifier(c.localName) == className,
      );
      buffer.writeln('/// ${rdfClass.localName} class from ${name} vocabulary');
      buffer.writeln('///');
      if (rdfClass.comment != null) {
        final formattedComment = _formatMultilineComment(rdfClass.comment!);
        buffer.writeln('/// $formattedComment');
        buffer.writeln('///');
      }
      buffer.writeln(
        '/// This class provides access to all properties that can be used with ${rdfClass.localName}.',
      );
      buffer.writeln('/// [Class Reference](${rdfClass.iri})');
      if (rdfClass.seeAlso.isNotEmpty) {
        for (final seeAlso in rdfClass.seeAlso) {
          buffer.writeln('/// [See also]($seeAlso)');
        }
      }
      buffer.writeln('///');
      buffer.writeln('/// [Vocabulary Reference](${model.namespace})');

      // Only add library declaration for files not in src/
      if (!outputDir.contains('/src/')) {
        buffer.writeln(
          'library ${model.prefix}_${className.toLowerCase()}_vocab;',
        );
      }
      buffer.writeln();
    } else {
      // Default library documentation for backward compatibility
      buffer.writeln('/// $name Vocabulary');
      buffer.writeln('///');
      buffer.writeln('/// [Vocabulary Reference](${model.namespace})');

      // Only add library declaration for files not in src/
      if (!outputDir.contains('/src/')) {
        buffer.writeln('library ${model.prefix}_vocab;');
      }
      buffer.writeln();
    }
  }

  /// Writes the primary vocabulary class that contains all terms.
  void _writePrimaryClass(StringBuffer buffer, VocabularyModel model) {
    final className = _capitalize(model.name);

    buffer.writeln(
      '/// Main ${className} vocabulary class containing all terms',
    );
    buffer.writeln('///');
    buffer.writeln(
      '/// Contains all terms defined in the ${model.namespace} vocabulary.',
    );
    buffer.writeln('class $className {');
    buffer.writeln('  // Private constructor prevents instantiation');
    buffer.writeln('  const ${className}._();');
    buffer.writeln();
    buffer.writeln('  /// Base IRI for ${className} vocabulary');
    buffer.writeln('  /// [Spec](${model.namespace})');
    buffer.writeln("  static const String namespace = '${model.namespace}';");
    buffer.writeln("  static const String prefix = '${model.prefix}';");
    buffer.writeln();

    // Add all terms
    for (final term in [
      ...model.classes,
      ...model.datatypes,
      ...model.otherTerms,
    ]) {
      _writeTerm(buffer, term, className);
    }

    // Add predicates
    for (final property in model.properties) {
      _writeTerm(buffer, property, className);
    }

    buffer.writeln('}');
    buffer.writeln();
  }

  /// Writes a class for universal properties (properties without explicit domains)
  void _writeUniversalPropertiesClass(
    StringBuffer buffer,
    VocabularyModel model,
  ) {
    // Filter properties without explicit domains
    final universalProperties =
        model.properties.where((p) => p.domains.isEmpty).toList();

    // Only generate the class if there are universal properties
    if (universalProperties.isEmpty) {
      return;
    }

    final className = _capitalize(model.name);
    final universalClassName = '${className}UniversalProperties';

    buffer.writeln('/// Universal Properties for the ${className} vocabulary');
    buffer.writeln('///');
    buffer.writeln(
      '/// Universal properties are RDF properties that have no explicitly defined domain',
    );
    buffer.writeln(
      '/// and can therefore be applied to any resource within this vocabulary\'s context.',
    );
    buffer.writeln(
      '/// In RDF, when a property has no rdfs:domain constraint, it can theoretically be',
    );
    buffer.writeln(
      '/// used with any subject, but best practice is to use them only within',
    );
    buffer.writeln('/// the intended vocabulary context.');
    buffer.writeln('///');
    buffer.writeln(
      '/// This class collects all such properties from the ${className} vocabulary to make them',
    );
    buffer.writeln(
      '/// easily accessible without cluttering the class-specific property interfaces.',
    );
    buffer.writeln('class $universalClassName {');
    buffer.writeln('  // Private constructor prevents instantiation');
    buffer.writeln('  const ${universalClassName}._();');
    buffer.writeln();

    // Write all universal properties
    for (final property in universalProperties) {
      _writeTerm(buffer, property, className, prefix: '  ');
    }

    buffer.writeln('}');
    buffer.writeln();
  }

  /// Writes a specific individual class instead of writing all classes
  void _writeIndividualClass(
    StringBuffer buffer,
    VocabularyModel model,
    VocabularyClass rdfClass,
    Map<String, Set<String>> classHierarchy,
    Map<String, VocabularyProperty> propertyMap,
  ) {
    final className = _capitalize(model.name);
    final dartClassName = '$className${_dartIdentifier(rdfClass.localName)}';

    buffer.writeln('class $dartClassName {');
    buffer.writeln('  // Private constructor prevents instantiation');
    buffer.writeln('  const ${dartClassName}._();');
    buffer.writeln();

    // Add the classIri field for the class itself
    buffer.writeln('  /// IRI term for the ${rdfClass.localName} class');
    buffer.writeln(
      '  /// Use this to specify that a resource is of this type.',
    );
    buffer.writeln(
      "  static const classIri = IriTerm.prevalidated('${rdfClass.iri}');",
    );
    buffer.writeln();

    // Get all properties that can be used with this class
    final properties = _getPropertiesForClass(
      rdfClass.iri,
      model.namespace,
      classHierarchy,
      propertyMap,
    );

    // Write all applicable properties
    for (final property in properties) {
      _writeTerm(
        buffer,
        property,
        className,
        prefix: '  ',
        classNamespace: model.namespace,
      );
    }

    buffer.writeln('}');
  }

  /// Writes a class for each RDF class in the vocabulary.
  void _writeIndividualClasses(StringBuffer buffer, VocabularyModel model) {
    if (model.classes.isEmpty) return;

    final className = _capitalize(model.name);

    // Build class hierarchy for property inheritance
    final classHierarchy = _buildClassHierarchy(model);

    // Map of property IRIs to property objects
    final propertyMap = {for (final prop in model.properties) prop.iri: prop};

    // Generate a class for each RDF class
    for (final rdfClass in model.classes) {
      final dartClassName = '$className${_dartIdentifier(rdfClass.localName)}';

      buffer.writeln(
        '/// ${rdfClass.localName} class from ${className} vocabulary',
      );
      buffer.writeln('///');
      if (rdfClass.comment != null) {
        final formattedComment = _formatMultilineComment(rdfClass.comment!);
        buffer.writeln('/// $formattedComment');
        buffer.writeln('///');
      }

      buffer.writeln(
        '/// This class provides access to all properties that can be used with ${rdfClass.localName}.',
      );
      buffer.writeln('/// [Class Reference](${rdfClass.iri})');

      // Add seeAlso references if available
      if (rdfClass.seeAlso.isNotEmpty) {
        for (final seeAlso in rdfClass.seeAlso) {
          buffer.writeln('/// [See also]($seeAlso)');
        }
      }

      buffer.writeln('class $dartClassName {');
      buffer.writeln('  // Private constructor prevents instantiation');
      buffer.writeln('  const ${dartClassName}._();');
      buffer.writeln();

      // Add the classIri field for the class itself
      buffer.writeln('  /// IRI term for the ${rdfClass.localName} class');
      buffer.writeln(
        '  /// Use this to specify that a resource is of this type.',
      );
      buffer.writeln(
        "  static const classIri = IriTerm.prevalidated('${rdfClass.iri}');",
      );
      buffer.writeln();

      // Get all properties that can be used with this class
      final properties = _getPropertiesForClass(
        rdfClass.iri,
        model.namespace,
        classHierarchy,
        propertyMap,
      );

      // Write all applicable properties
      for (final property in properties) {
        _writeTerm(
          buffer,
          property,
          className,
          prefix: '  ',
          classNamespace: model.namespace,
        );
      }

      buffer.writeln('}');
      buffer.writeln();
    }
  }

  /// Writes class documentation directly above the class declaration
  void _writeClassDoc(
    StringBuffer buffer,
    VocabularyModel model,
    VocabularyClass rdfClass,
    String vocabularyClassName,
  ) {
    buffer.writeln(
      '/// ${rdfClass.localName} class from ${vocabularyClassName} vocabulary',
    );
    buffer.writeln('///');

    if (rdfClass.comment != null) {
      final formattedComment = _formatMultilineComment(rdfClass.comment!);
      buffer.writeln('/// $formattedComment');
      buffer.writeln('///');
    }

    // Build class hierarchy to get all parent classes (direct and indirect)
    final classHierarchy = _buildClassHierarchy(model);
    final allSuperClasses = classHierarchy[rdfClass.iri] ?? <String>{};

    // Show inheritance information if there are any parent classes
    if (allSuperClasses.isNotEmpty) {
      buffer.writeln('/// Inherits from:');
      // Sort parent classes for consistent output
      final sortedSuperClasses = allSuperClasses.toList()..sort();
      for (final superClass in sortedSuperClasses) {
        // Extract readable name from IRI
        final name = _extractReadableNameFromIri(superClass);
        buffer.writeln('/// - $name ($superClass)');
      }
      buffer.writeln('///');
    }

    buffer.writeln(
      '/// This class provides access to all properties that can be used with ${rdfClass.localName}.',
    );
    buffer.writeln('/// [Class Reference](${rdfClass.iri})');

    if (rdfClass.seeAlso.isNotEmpty) {
      for (final seeAlso in rdfClass.seeAlso) {
        buffer.writeln('/// [See also]($seeAlso)');
      }
    }

    buffer.writeln('///');
    buffer.writeln('/// [Vocabulary Reference](${model.namespace})');
    buffer.writeln();
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

  /// Writes the main class documentation directly above the class declaration
  void _writeMainClassDoc(StringBuffer buffer, VocabularyModel model) {
    final name = _capitalize(model.name);
    final hasUniversalProperties = model.properties.any(
      (p) => p.domains.isEmpty,
    );
    final universalClassName = '${name}UniversalProperties';

    buffer.writeln('/// $name Vocabulary');
    buffer.writeln('///');
    buffer.writeln(
      '/// Provides constants for the ${name.toUpperCase()} vocabulary',
    );
    buffer.writeln('/// (${model.namespace}).');
    buffer.writeln('///');
    buffer.writeln('/// Example usage:');
    buffer.writeln('/// ```dart');
    buffer.writeln('/// import \'package:rdf_vocabulary_to_dart/vocab.dart\';');

    if (model.properties.isNotEmpty) {
      final exampleProp = _dartIdentifier(model.properties.first.localName);
      buffer.writeln(
        '/// final property = ${name}.$exampleProp; // Access property directly from main class',
      );
    }

    if (model.classes.isNotEmpty) {
      final exampleClass = _dartIdentifier(model.classes.first.localName);
      buffer.writeln(
        '/// final classIri = ${name}$exampleClass.classIri; // Access class IRI',
      );

      if (model.properties.isNotEmpty) {
        final exampleProp = _dartIdentifier(model.properties.first.localName);
        buffer.writeln(
          '/// final property = ${name}$exampleClass.$exampleProp; // Access property from class',
        );
      }
    }

    if (hasUniversalProperties) {
      final universalProp = _dartIdentifier(
        model.properties.firstWhere((p) => p.domains.isEmpty).localName,
      );
      buffer.writeln(
        '/// final universalProp = $universalClassName.$universalProp; // Access universal property',
      );
    }

    buffer.writeln('/// ```');
    buffer.writeln('///');
    buffer.writeln(
      '/// All constants are pre-constructed as IriTerm objects to enable direct use in',
    );
    buffer.writeln(
      '/// constructing RDF graphs without repeated string concatenation or term creation.',
    );

    if (hasUniversalProperties) {
      buffer.writeln('///');
      buffer.writeln('/// Universal Properties:');
      buffer.writeln(
        '/// This vocabulary provides a `$universalClassName` class for properties',
      );
      buffer.writeln(
        '/// that have no explicitly defined domain restrictions and can be applied',
      );
      buffer.writeln('/// to any resource in this vocabulary\'s context.');
    }

    buffer.writeln('///');
    buffer.writeln('/// [Vocabulary Reference](${model.namespace})');

    // Only add library declaration for the main file which is not in src/
    if (!outputDir.contains('/src/')) {
      buffer.writeln('library ${model.prefix}_vocab;');
    }
    buffer.writeln();
  }

  /// Writes the universal properties documentation directly above the class declaration
  void _writeUniversalPropertiesDoc(
    StringBuffer buffer,
    VocabularyModel model,
  ) {
    final name = _capitalize(model.name);
    final universalClassName = '${name}UniversalProperties';

    buffer.writeln('/// Universal Properties for the ${name} vocabulary');
    buffer.writeln('///');
    buffer.writeln(
      '/// Universal properties are RDF properties that have no explicitly defined domain',
    );
    buffer.writeln(
      '/// and can therefore be applied to any resource within this vocabulary\'s context.',
    );
    buffer.writeln('///');
    buffer.writeln('/// [Vocabulary Reference](${model.namespace})');

    // Only add library declaration for files not in src/
    if (!outputDir.contains('/src/')) {
      buffer.writeln('library ${model.prefix}_universal_vocab;');
    }
    buffer.writeln();
  }

  /// Writes a single term as a static constant.
  void _writeTerm(
    StringBuffer buffer,
    VocabularyTerm term,
    String className, {
    String prefix = '',
    String? classNamespace,
  }) {
    final dartName = _getPropertyName(term, classNamespace);

    // Write documentation
    buffer.writeln(
      '$prefix/// IRI for ${className.toLowerCase()}:${term.localName}',
    );

    if (term.comment != null) {
      // Format the comment for Dart documentation
      final formattedComment = _formatMultilineComment(term.comment!);
      buffer.writeln('$prefix///');
      buffer.writeln('$prefix/// $formattedComment');
    }

    // Add domain and range information for properties in a more developer-friendly way
    if (term is VocabularyProperty) {
      buffer.writeln('$prefix///');
      buffer.writeln(
        '$prefix/// ${_getDomainDescription(term, classNamespace)}',
      );

      if (term.ranges.isNotEmpty) {
        buffer.writeln(
          '$prefix/// Expects values of type: ${term.ranges.join(', ')}',
        );
      }
    }

    // Add seeAlso references if available
    if (term.seeAlso.isNotEmpty) {
      buffer.writeln('$prefix///');
      for (final seeAlso in term.seeAlso) {
        buffer.writeln('$prefix/// [See also]($seeAlso)');
      }
    }

    buffer.writeln('$prefix///');

    // Write the constant declaration with correct indentation
    buffer.writeln(
      "$prefix" +
          "static const $dartName = IriTerm.prevalidated('${term.iri}');",
    );
    buffer.writeln();
  }

  /// Formats a multiline comment for Dart documentation
  String _formatMultilineComment(String comment) {
    return comment
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join('\n  /// ');
  }

  /// Gets a property name with prefix if it comes from a different namespace
  String _getPropertyName(VocabularyTerm term, String? classNamespace) {
    final dartName = _dartIdentifier(term.localName);

    // If classNamespace is null, we're generating the main class (no prefix needed)
    if (classNamespace == null) return dartName;

    // If the property belongs to a different namespace than the class,
    // prefix it to avoid naming conflicts
    if (!term.iri.startsWith(classNamespace)) {
      // Extract the namespace from the IRI
      final namespace = _extractNamespace(term.iri);
      if (namespace != null && namespace != classNamespace) {
        final prefix = _getNamespacePrefix(namespace);
        if (prefix != null) {
          return '${prefix}${_capitalize(dartName)}';
        }
      }
    }

    return dartName;
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

  /// Builds a map of class IRI to list of all parent class IRIs (including inherited)
  Map<String, Set<String>> _buildClassHierarchy(VocabularyModel model) {
    final hierarchy = <String, Set<String>>{};

    // Initialize with direct parent classes
    for (final rdfClass in model.classes) {
      hierarchy[rdfClass.iri] = Set.from(rdfClass.superClasses);
    }

    // Resolve full inheritance (transitive closure)
    bool changed;
    do {
      changed = false;

      for (final entry in hierarchy.entries) {
        final classIri = entry.key;
        final parents = Set<String>.from(entry.value);

        for (final parentIri in parents.toList()) {
          // Add parent's parents
          if (hierarchy.containsKey(parentIri)) {
            final grandparents = hierarchy[parentIri]!;
            final sizeBefore = parents.length;
            parents.addAll(grandparents);
            if (parents.length > sizeBefore) {
              changed = true;
              hierarchy[classIri] = parents;
            }
          }
        }
      }
    } while (changed);

    return hierarchy;
  }

  /// Gets all properties applicable to a given class including inherited properties
  List<VocabularyProperty> _getPropertiesForClass(
    String classIri,
    String vocabNamespace,
    Map<String, Set<String>> classHierarchy,
    Map<String, VocabularyProperty> propertyMap,
  ) {
    _log.fine('Using cross-vocabulary resolver for class $classIri');
    return resolver.getPropertiesForClass(classIri, vocabNamespace);
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
}
