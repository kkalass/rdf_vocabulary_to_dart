// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:rdf_core/rdf_core.dart';
import 'package:rdf_xml/rdf_xml.dart';

import 'class_generator.dart';
import 'cross_vocabulary_resolver.dart';
import 'model/vocabulary_model.dart';
import 'vocabulary_source.dart';

/// Logger for the vocabulary builder
final log = Logger('rdf.vocab.builder');

class MutableVocabularyLoader {
  Future<VocabularyModel?> Function(String namespace, String name)? _loader;
  Future<VocabularyModel?> load(String namespace, String name) {
    if (_loader == null) {
      throw StateError('Vocabulary loader not set');
    }
    return _loader!(namespace, name);
  }
}

/// A builder that generates Dart classes for RDF vocabularies.
///
/// This builder reads a provided manifest JSON file and generates vocabulary
/// class files based on the configuration. The generated files are automatically
/// formatted according to Dart formatting guidelines.
class VocabularyBuilder implements Builder {
  /// Input asset path for the manifest file
  final String manifestAssetPath;

  /// Output directory for generated vocabulary files
  final String outputDir;

  /// The cross-vocabulary resolver that tracks relationships between vocabularies
  final CrossVocabularyResolver _resolver;

  /// Map of vocabulary models by name
  final Map<String, VocabularyModel> _vocabularyModels = {};

  final MutableVocabularyLoader mutableVocabularyLoader;

  /// Cached vocabulary names from manifest
  List<String>? _cachedVocabularyNames;

  /// Dart code formatter instance with same settings as `dart format` command line tool
  final DartFormatter _dartFormatter = DartFormatter(
    languageVersion: Version(3, 7, 0),
  );

  /// Creates a new vocabulary builder.
  ///
  /// [manifestAssetPath] specifies the path to the manifest JSON file that defines
  /// the vocabularies to be generated.
  /// [outputDir] specifies where to generate the vocabulary files, relative to lib/.

  /// Public constructor that initializes internal dependencies and delegates to the inner constructor
  factory VocabularyBuilder({
    required String manifestAssetPath,
    required String outputDir,
  }) {
    // Create a mutable vocabulary loader that will be configured during build
    final loader = MutableVocabularyLoader();

    return VocabularyBuilder._inner(
      manifestAssetPath: manifestAssetPath,
      outputDir: outputDir,
      mutableVocabularyLoader: loader,
    );
  }

  VocabularyBuilder._inner({
    required this.manifestAssetPath,
    required this.outputDir,
    required this.mutableVocabularyLoader,
  }) : _resolver = CrossVocabularyResolver(
         vocabularyLoader: mutableVocabularyLoader.load,
       );

  /// Loads an implied vocabulary that was discovered through references
  static Future<VocabularyModel?> Function(String namespace, String name)
  createVocabularyLoader(Map<String, VocabularySource> vocabularySources) {
    // Load the manifest file to get the namespace and name

    return (String namespace, String name) async {
      log.info('Loading implied vocabulary "$name" from namespace $namespace');

      try {
        var source = vocabularySources[name];
        if (source == null) {
          log.warning(
            'No configured source found for vocabulary $name, trying to guess it',
          );
          // Try to derive a turtle URL from the namespace
          final sourceUrl = await _findVocabularyUrl(namespace);
          if (sourceUrl == null) {
            log.warning(
              'Could not derive a valid URL for vocabulary namespace: $namespace',
            );
            return null;
          }

          log.info('Using derived URL for vocabulary $name: $sourceUrl');

          // Create a source for the vocabulary - ohne spezifische Parsing-Flags für abgeleitete Vokabulare
          source = UrlVocabularySource(namespace, sourceUrl: sourceUrl);
        } else {
          log.info(
            'Using configured source for vocabulary $name: ${source.namespace}',
          );
        }

        return _loadVocabulary(name, source);
      } catch (e, stackTrace) {
        log.severe(
          'Error loading implied vocabulary $name from $namespace: $e\n$stackTrace',
        );
        return null;
      }
    };
  }

  static Future<VocabularyModel?> _loadVocabulary(
    String name,
    VocabularySource source,
  ) async {
    final namespace = source.namespace;

    try {
      // Load the vocabulary content
      final content = await source.loadContent();
      if (content.isEmpty) {
        log.warning('Empty content for implied vocabulary $name');
        return null;
      }

      // Convert parsing flags to a set of TurtleParsingFlag values
      final parsingFlags = _convertParsingFlagsToSet(source.parsingFlags);

      // Parse the vocabulary
      final rdfCore = RdfCore.withFormats(
        formats: [
          TurtleFormat(parsingFlags: parsingFlags),
          JsonLdFormat(),
          RdfXmlFormat(),
          NTriplesFormat(),
        ],
      );

      RdfGraph? graph;

      try {
        log.info('Trying to parse $name ');
        if (source.parsingFlags != null && source.parsingFlags!.isNotEmpty) {
          log.info('Using parsing flags: ${source.parsingFlags!.join(", ")}');
        }

        graph = rdfCore.parse(content, documentUrl: source.namespace);

        log.info('Successfully parsed $name');
      } catch (e) {
        log.severe(
          'Failed to parse implied vocabulary $name from $namespace: $e',
        );
        return null;
      }

      // Extract the vocabulary model
      final model = VocabularyModelExtractor.extractFrom(
        graph,
        namespace,
        name,
      );
      log.info('Successfully extracted vocabulary model for $name');

      return model;
    } catch (e, stackTrace) {
      log.severe(
        'Error loading vocabulary $name from $namespace: $e\n$stackTrace',
      );
      return null;
    }
  }

  /// Algorithmically tries to find a valid turtle URL for a vocabulary namespace
  static Future<String?> _findVocabularyUrl(String namespace) async {
    // List of URL patterns to try, in order of preference
    final urlCandidates = <String>[];

    // Case 0: Try the namespace URL directly as is
    urlCandidates.add(namespace);

    // Case 1: Remove trailing hash and add .ttl extension
    if (namespace.endsWith('#')) {
      urlCandidates.add('${namespace.substring(0, namespace.length - 1)}.ttl');
    }

    // Case 2: Remove trailing slash and add .ttl extension
    if (namespace.endsWith('/')) {
      urlCandidates.add('${namespace.substring(0, namespace.length - 1)}.ttl');
    }

    // Case 3: As-is with .ttl appended (works for some vocabularies)
    urlCandidates.add('$namespace.ttl');

    // Case 4: Try with -ns.ttl suffix (common for W3C)
    if (namespace.endsWith('#') || namespace.endsWith('/')) {
      final base = namespace.substring(0, namespace.length - 1);
      urlCandidates.add('$base-ns.ttl');
    } else {
      urlCandidates.add('$namespace-ns.ttl');
    }

    // Case 5: Known W3C pattern where the schema is in a specific file without the hash
    final hashIndex = namespace.lastIndexOf('#');
    if (hashIndex > 0) {
      urlCandidates.add(namespace.substring(0, hashIndex));
    }

    // Try each URL candidate until we find one that works
    for (final url in urlCandidates) {
      log.info('Trying vocabulary URL: $url');

      try {
        final response = await http.head(
          Uri.parse(url),
          headers: {'Accept': 'text/turtle, application/ld+json'},
        );

        if (response.statusCode == 200) {
          log.info('Found valid vocabulary URL: $url');
          return url;
        }
      } catch (e) {
        log.fine('Error checking URL $url: $e');
        // Continue to the next URL candidate
      }
    }

    // If all attempts fail, return null
    return null;
  }

  /// Konvertiert die String-Liste der Parsing-Flags in ein Set von TurtleParsingFlag-Werten
  static Set<TurtleParsingFlag> _convertParsingFlagsToSet(
    List<String>? flagsList,
  ) {
    final Set<TurtleParsingFlag> flagsSet = {};
    if (flagsList != null) {
      for (final flag in flagsList) {
        flagsSet.add(TurtleParsingFlag.values.byName(flag));
      }
    }
    return flagsSet;
  }

  /// Loads vocabulary names from the manifest file.
  /// This is used to determine the build extensions.
  List<String> _getVocabularyNamesFromManifest() {
    // Return cached names if available
    if (_cachedVocabularyNames != null) {
      return _cachedVocabularyNames!;
    }

    // Try to read the manifest file directly
    final File manifestFile = File(manifestAssetPath);
    if (!manifestFile.existsSync()) {
      log.warning(
        'Manifest file not found at $manifestAssetPath for build extensions',
      );
      // Return an empty list by default
      _cachedVocabularyNames = [];
      return [];
    }

    try {
      final String content = manifestFile.readAsStringSync();
      final Map<String, dynamic> json =
          jsonDecode(content) as Map<String, dynamic>;

      final Map<String, dynamic>? vocabulariesJson =
          json['vocabularies'] as Map<String, dynamic>?;

      if (vocabulariesJson == null) {
        log.warning('No vocabularies found in manifest');
        _cachedVocabularyNames = [];
        return [];
      }

      // Extract vocabulary names from the manifest
      final List<String> vocabularyNames = vocabulariesJson.keys.toList();
      _cachedVocabularyNames = vocabularyNames;

      log.info('Found ${vocabularyNames.length} vocabularies in manifest');
      return vocabularyNames;
    } catch (e, stackTrace) {
      log.severe(
        'Error reading manifest file for build extensions: $e\n$stackTrace',
      );
      // Return an empty list in case of error
      _cachedVocabularyNames = [];
      return [];
    }
  }

  @override
  Map<String, List<String>> get buildExtensions {
    final outputs = <String>[];

    // Always add the index file as required output
    outputs.add(_getFullOutputPath('_index.dart'));

    // Add vocabulary files from manifest as potential outputs
    final vocabularyNames = _getVocabularyNamesFromManifest();
    for (final name in vocabularyNames) {
      outputs.add(_getFullOutputPath('$name.dart'));
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

  /// Formats a Dart source code string according to Dart style guidelines
  ///
  /// Returns the formatted code string, or the original string if formatting fails
  String _formatDartCode(String dartCode) {
    try {
      return _dartFormatter.format(dartCode);
    } catch (e, stackTrace) {
      log.warning('Failed to format Dart code: $e\n$stackTrace');
      // Return unformatted code if formatting fails
      return dartCode;
    }
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

    // Important: make sure that the resolver uses the vocabulary config.
    mutableVocabularyLoader._loader = createVocabularyLoader(vocabularySources);

    // Process all vocabularies in the manifest in two phases:
    // 1. Parse all vocabulary sources and register them with the resolver
    // 2. Generate code for all vocabularies using the resolver

    // Phase 1: Parse and register vocabularies
    await _parseVocabularies(buildStep, vocabularySources);

    // Load any vocabularies that were referenced but not explicitly defined
    await _resolver.loadPendingVocabularies();

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

        // Extract turtle parsing flags if they exist
        List<String>? parsingFlags;
        if (vocabConfig.containsKey('parsingFlags')) {
          final flagsJson = vocabConfig['parsingFlags'];
          if (flagsJson is List) {
            parsingFlags = flagsJson.map((flag) => flag.toString()).toList();
            log.info('Found parsing flags for $name: $parsingFlags');
          } else {
            log.warning(
              'Invalid parsingFlags format for $name, expected a list',
            );
          }
        }

        // Check if the vocabulary is enabled, default to true if not specified
        final bool enabled = vocabConfig['enabled'] as bool? ?? true;

        VocabularySource source;
        try {
          switch (type) {
            case 'url':
              // Use 'source' field if available, otherwise fall back to namespace
              final sourceUrl = vocabConfig['source'] as String? ?? namespace;
              source = UrlVocabularySource(
                namespace,
                sourceUrl: sourceUrl,
                parsingFlags: parsingFlags,
                enabled: enabled,
              );
              break;
            case 'file':
              final filePath = vocabConfig['filePath'] as String;
              source = FileVocabularySource(
                filePath,
                namespace,
                parsingFlags: parsingFlags,
                enabled: enabled,
              );
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
        if (!source.enabled) {
          log.info('Skipping disabled vocabulary: $name');
          continue;
        }
        print(
          "!!! Processing vocabulary: $name from ${source.namespace}: ${source} !!!",
        );
        log.info('Processing vocabulary: $name from ${source.namespace}');
        final model = await _loadVocabulary(name, source);

        if (model == null) {
          log.severe('Failed to parse vocabulary $name with any format');
          continue;
        }

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

    log.info(
      'Phase 1 complete. Registered ${_vocabularyModels.length} vocabularies',
    );
  }

  /// Phase 2: Generate code for all vocabularies using the cross-vocabulary resolver
  Future<Map<String, bool>> _generateVocabularyClasses(
    BuildStep buildStep,
  ) async {
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

        // Format the generated code
        final formattedCode = _formatDartCode(dartCode);

        // Write the generated code to a file
        final outputPath = _getFullOutputPath('$name.dart');
        final outputId = AssetId(buildStep.inputId.package, outputPath);

        await buildStep.writeAsString(outputId, formattedCode);

        log.info('Generated vocabulary class: $name');
        results[name] = true;
      } catch (e, stack) {
        log.severe('Error generating class for vocabulary $name: $e\n$stack');
        results[name] = false;
      }
    }

    return results;
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

    // Format the index file code
    final indexCode = buffer.toString();
    final formattedIndexCode = _formatDartCode(indexCode);

    final outputPath = _getFullOutputPath('_index.dart');
    final outputId = AssetId(buildStep.inputId.package, outputPath);

    await buildStep.writeAsString(outputId, formattedIndexCode);

    log.info('Generated vocabulary index file');
  }
}
