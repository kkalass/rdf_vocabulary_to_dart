// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:build/build.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import '../../../rdf_core.dart';
import 'class_generator.dart';
import 'cross_vocabulary_resolver.dart';
import 'model/vocabulary_model.dart';
import 'vocabulary_source.dart';

/// Logger for the vocabulary builder
final log = Logger('rdf.vocab.builder');

/// A builder that generates Dart classes for RDF vocabularies.
///
/// This builder reads a provided manifest JSON file and generates vocabulary
/// class files based on the configuration.
class VocabularyBuilder implements Builder {
  /// Input asset path for the manifest file
  final String manifestAssetPath;

  /// Output directory for generated vocabulary files
  final String outputDir;

  /// The cross-vocabulary resolver that tracks relationships between vocabularies
  final CrossVocabularyResolver _resolver = CrossVocabularyResolver();
  
  /// Map of vocabulary models by name
  final Map<String, VocabularyModel> _vocabularyModels = {};

  // Known vocabulary names for build_extensions
  static const _knownVocabularies = [
    'rdf',
    'rdfs',
    'xsd',
    'owl',
    'dc',
    'dcterms',
    'foaf',
    'skos',
    'vcard',
    'acl',
    'ldp',
    'schema',
    'solid',
  ];

  /// Creates a new vocabulary builder.
  ///
  /// [manifestAssetPath] specifies the path to the manifest JSON file that defines
  /// the vocabularies to be generated.
  /// [outputDir] specifies where to generate the vocabulary files, relative to lib/.
   VocabularyBuilder({
    required this.manifestAssetPath,
    required this.outputDir,
  });

  @override
  Map<String, List<String>> get buildExtensions {
    final outputs = <String>[];

    // Add the index file as required output
    outputs.add(_getFullOutputPath('_index.dart'));

    // Add known vocabulary files as potential outputs
    for (final vocab in _knownVocabularies) {
      outputs.add(_getFullOutputPath('$vocab.dart'));
    }

    return {manifestAssetPath: outputs};
  }

  /// Converts a relative file path to the full output path.
  /// This ensures consistency between buildExtensions and actual file output.
  String _getFullOutputPath(String relativePath) {
    if (!outputDir.startsWith('lib/')) {
      return 'lib/$outputDir/$relativePath';
    }
    return '$outputDir/$relativePath';
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    log.info('Starting vocabulary generation');

    // Read the manifest file
    final vocabularySources = await _loadVocabularyManifest(buildStep);
    if (vocabularySources == null || vocabularySources.isEmpty) {
      log.severe('Failed to load vocabularies from $manifestAssetPath');
      return;
    }

    // Process all vocabularies in the manifest in two phases:
    // 1. Parse all vocabulary sources and register them with the resolver
    // 2. Generate code for all vocabularies using the resolver

    // Phase 1: Parse and register vocabularies
    await _parseVocabularies(buildStep, vocabularySources);

    // Phase 2: Generate code for each vocabulary
    final results = await _generateVocabularyClasses(buildStep);

    // Generate the index file for successful vocabularies
    final successfulVocabularies =
        results.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList();

    if (successfulVocabularies.isNotEmpty) {
      await _generateIndex(buildStep, successfulVocabularies);
    } else {
      log.warning('No vocabulary files were successfully generated');
    }

    log.info(
      'Vocabulary generation completed. '
      'Success: ${successfulVocabularies.length}/${results.length}',
    );
  }

  /// Loads the vocabularies from the provided JSON asset path.
  Future<Map<String, VocabularySource>?> _loadVocabularyManifest(
    BuildStep buildStep,
  ) async {
    final manifestId = AssetId(buildStep.inputId.package, manifestAssetPath);

    try {
      if (!await buildStep.canRead(manifestId)) {
        log.severe('Manifest file not found: $manifestAssetPath');
        return null;
      }

      final content = await buildStep.readAsString(manifestId);
      final json = jsonDecode(content) as Map<String, dynamic>;

      final vocabularies = <String, VocabularySource>{};

      final vocabulariesJson = json['vocabularies'] as Map<String, dynamic>?;
      if (vocabulariesJson == null) {
        log.warning('No vocabularies found in manifest');
        return vocabularies;
      }

      for (final entry in vocabulariesJson.entries) {
        final name = entry.key;
        final vocabConfig = entry.value as Map<String, dynamic>;

        final type = vocabConfig['type'] as String;
        final namespace = vocabConfig['namespace'] as String;

        VocabularySource source;
        try {
          switch (type) {
            case 'url':
              // Use 'source' field if available, otherwise fall back to namespace
              final sourceUrl = vocabConfig['source'] as String? ?? namespace;
              source = UrlVocabularySource(namespace, sourceUrl: sourceUrl);
              break;
            case 'file':
              final filePath = vocabConfig['filePath'] as String;
              source = FileVocabularySource(filePath, namespace);
              break;
            default:
              log.warning('Unknown vocabulary source type: $type for $name');
              continue;
          }

          vocabularies[name] = source;
        } catch (e) {
          log.warning('Error creating source for vocabulary $name: $e');
          // Skip this vocabulary
        }
      }

      return vocabularies;
    } catch (e, stackTrace) {
      log.severe('Error loading manifest: $e\n$stackTrace');
      return null;
    }
  }

  /// Phase 1: Parses all vocabulary sources and registers them with the resolver
  Future<void> _parseVocabularies(
    BuildStep buildStep,
    Map<String, VocabularySource> vocabularySources,
  ) async {
    log.info('Phase 1: Parsing vocabularies and registering with resolver');
    
    // Process vocabularies sequentially with a small delay to avoid overwhelming external servers
    for (final entry in vocabularySources.entries) {
      final name = entry.key;
      final source = entry.value;

      try {
        log.info('Processing vocabulary: $name from ${source.namespace}');

        // Load vocabulary content
        String? content;
        try {
          content = await source.loadContent();
        } catch (e) {
          log.severe('Error loading vocabulary from ${source.namespace}: $e');
          continue;
        }

        if (content == null || content.isEmpty) {
          log.warning('Empty content for vocabulary $name');
          continue;
        }

        // Create RDF core instance with standard formats
        final rdfCore = RdfCore.withStandardFormats();

        // Try multiple formats if the first one fails
        RdfGraph? graph;
        final formats = [
          source.getFormat(), // Try the source's preferred format first
          'turtle',
          'rdf/xml',
          'json-ld',
          'n-triples',
        ];

        for (final format in formats) {
          try {
            final contentType = _getContentTypeForFormat(format);
            log.info('Trying to parse $name with format $contentType');
            graph = rdfCore.parse(content, contentType: contentType);
            if (graph != null) {
              log.info('Successfully parsed $name with format $contentType');
              break;
            }
          } catch (e) {
            log.warning('Failed to parse $name with format $format: $e');
            // Continue to the next format
          }
        }

        if (graph == null) {
          log.severe('Failed to parse vocabulary $name with any format');
          continue;
        }

        // Extract vocabulary model from parsed graph
        final model = VocabularyModelExtractor.extractFrom(
          graph,
          source.namespace,
          name,
        );

        // Store the model for later use
        _vocabularyModels[name] = model;
        
        // Register the model with the cross-vocabulary resolver
        _resolver.registerVocabulary(model);
        
        log.info('Registered vocabulary: $name');

        // Small delay between requests to be polite to servers
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e, stackTrace) {
        log.severe('Error processing vocabulary $name: $e\n$stackTrace');
      }
    }

    log.info('Phase 1 complete. Registered ${_vocabularyModels.length} vocabularies');
  }

  /// Phase 2: Generate code for all vocabularies using the cross-vocabulary resolver
  Future<Map<String, bool>> _generateVocabularyClasses(BuildStep buildStep) async {
    log.info('Phase 2: Generating vocabulary classes');
    
    final results = <String, bool>{};
    
    // Generate classes for each vocabulary
    for (final entry in _vocabularyModels.entries) {
      final name = entry.key;
      final model = entry.value;
      
      try {
        // Generate the Dart class with cross-vocabulary awareness
        final generator = VocabularyClassGenerator(resolver: _resolver);
        final dartCode = generator.generate(model);

        // Write the generated code to a file
        final outputPath = _getFullOutputPath('$name.dart');
        final outputId = AssetId(buildStep.inputId.package, outputPath);

        await buildStep.writeAsString(outputId, dartCode);

        log.info('Generated vocabulary class: $name');
        results[name] = true;
      } catch (e, stack) {
        log.severe('Error generating class for vocabulary $name: $e\n$stack');
        results[name] = false;
      }
    }
    
    return results;
  }

  /// Maps format names to content types
  String _getContentTypeForFormat(String format) {
    switch (format.toLowerCase()) {
      case 'turtle':
        return 'text/turtle';
      case 'rdf/xml':
      case 'xml':
        return 'application/rdf+xml';
      case 'json-ld':
        return 'application/ld+json';
      case 'n-triples':
        return 'application/n-triples';
      default:
        return 'text/turtle'; // Default to Turtle
    }
  }

  /// Generates an index file that exports all generated vocabulary classes.
  Future<void> _generateIndex(
    BuildStep buildStep,
    Iterable<String> vocabularyNames,
  ) async {
    final buffer =
        StringBuffer()
          ..writeln('// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>')
          ..writeln(
            '// All rights reserved. Use of this source code is governed by a BSD-style',
          )
          ..writeln('// license that can be found in the LICENSE file.')
          ..writeln()
          ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
          ..writeln('// Generated by VocabularyBuilder')
          ..writeln();

    // Export all generated vocabulary files
    final sortedNames = vocabularyNames.toList()..sort();
    for (final name in sortedNames) {
      buffer.writeln("export '$name.dart';");
    }

    final outputPath = _getFullOutputPath('_index.dart');
    final outputId = AssetId(buildStep.inputId.package, outputPath);

    await buildStep.writeAsString(outputId, buffer.toString());

    log.info('Generated vocabulary index file');
  }
}
