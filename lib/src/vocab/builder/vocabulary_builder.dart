// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:build/build.dart';
import 'package:logging/logging.dart';
import '../../../rdf_core.dart';
import 'class_generator.dart';
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

  /// Creates a new vocabulary builder.
  ///
  /// [manifestAssetPath] specifies the path to the manifest JSON file that defines
  /// the vocabularies to be generated.
  /// [outputDir] specifies where to generate the vocabulary files, relative to lib/.
  const VocabularyBuilder({
    required this.manifestAssetPath,
    required this.outputDir,
  });

  @override
  Map<String, List<String>> get buildExtensions {
    // This is a placeholder. The actual outputs will be determined
    // when the manifest is loaded during the build process.
    return {
      manifestAssetPath: [
        '$outputDir/_index.dart',
      ],
    };
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    log.info('Starting vocabulary generation');
    
    // Read the manifest file
    final vocabularies = await _loadVocabularyManifest(buildStep);
    if (vocabularies == null || vocabularies.isEmpty) {
      log.severe('Failed to load vocabularies from $manifestAssetPath');
      return;
    }

    // Process all vocabularies in the manifest
    final futures = <Future<void>>[];
    
    for (final entry in vocabularies.entries) {
      final name = entry.key;
      final source = entry.value;
      
      futures.add(_processVocabulary(buildStep, name, source));
    }
    
    // Wait for all vocabulary processing to complete
    await Future.wait(futures);
    
    // Generate the index file
    await _generateIndex(buildStep, vocabularies.keys);
    
    log.info('Vocabulary generation completed');
  }

  /// Loads the vocabularies from the provided JSON asset path.
  Future<Map<String, VocabularySource>?> _loadVocabularyManifest(BuildStep buildStep) async {
    final manifestId = AssetId(
      buildStep.inputId.package,
      manifestAssetPath,
    );

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
        switch (type) {
          case 'url':
            source = UrlVocabularySource(namespace);
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
      }
      
      return vocabularies;
    } catch (e, stackTrace) {
      log.severe('Error loading manifest: $e\n$stackTrace');
      return null;
    }
  }

  /// Processes a single vocabulary and generates its Dart class.
  Future<void> _processVocabulary(
    BuildStep buildStep,
    String name,
    VocabularySource source,
  ) async {
    try {
      log.info('Processing vocabulary: $name from ${source.namespace}');
      
      // Load vocabulary content
      final content = await source.loadContent();
      
      // Create RDF core instance with standard formats
      final rdfCore = RdfCore.withStandardFormats();
      
      // Parse the vocabulary using the appropriate format
      final format = source.getFormat();
      final graph = rdfCore.parse(content, contentType: _getContentTypeForFormat(format));
      
      // Extract vocabulary model from parsed graph
      final model = VocabularyModelExtractor.extractFrom(
        graph, 
        source.namespace,
        name,
      );
      
      // Generate the Dart class
      final generator = VocabularyClassGenerator();
      final dartCode = generator.generate(model);
      
      // Write the generated code to a file
      final outputId = AssetId(
        buildStep.inputId.package,
        'lib/$outputDir/$name.dart',
      );
      
      await buildStep.writeAsString(outputId, dartCode);
      
      log.info('Generated vocabulary class: $name');
    } catch (e, stackTrace) {
      log.severe('Error processing vocabulary $name: $e\n$stackTrace');
    }
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
  Future<void> _generateIndex(BuildStep buildStep, Iterable<String> vocabularyNames) async {
    final buffer = StringBuffer()
      ..writeln('// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>')
      ..writeln('// All rights reserved. Use of this source code is governed by a BSD-style')
      ..writeln('// license that can be found in the LICENSE file.')
      ..writeln()
      ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
      ..writeln('// Generated by VocabularyBuilder')
      ..writeln();
    
    // Export all generated vocabulary files
    for (final name in vocabularyNames) {
      buffer.writeln("export '$name.dart';");
    }
    
    final outputId = AssetId(
      buildStep.inputId.package,
      'lib/$outputDir/_index.dart',
    );
    
    await buildStep.writeAsString(outputId, buffer.toString());
    
    log.info('Generated vocabulary index file');
  }
}

/// Creates a vocabulary builder with the given options.
Builder vocabularyBuilder(BuilderOptions options) {
  // Read configuration from BuilderOptions
  final manifestPath = options.config['manifest_asset_path'] as String? ?? 'lib/src/vocab/manifest.json';
  final outputDir = options.config['output_dir'] as String? ?? 'src/vocab/generated';
  
  return VocabularyBuilder(
    manifestAssetPath: manifestPath,
    outputDir: outputDir,
  );
}
