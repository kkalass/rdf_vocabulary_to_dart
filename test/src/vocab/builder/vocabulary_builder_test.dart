// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;
import 'package:rdf_vocabulary_to_dart/src/vocab/builder/vocabulary_builder.dart';
import 'package:test/test.dart';

import 'vocabulary_builder_test.mocks.dart';

// Sample test data for vocabularies
const testTurtleVocab = '''
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix test: <http://example.org/test#> .

test:Person a rdfs:Class ;
  rdfs:label "Person" ;
  rdfs:comment "A person class" .

test:name a rdf:Property ;
  rdfs:label "name" ;
  rdfs:comment "The name of a person" ;
  rdfs:domain test:Person ;
  rdfs:range xsd:string .
''';

// Sample manifest file
const testManifest = '''
{
  "vocabularies": {
    "test": {
      "type": "file",
      "namespace": "http://example.org/test#",
      "filePath": "test_vocab.ttl"
    }
  }
}
''';

@GenerateMocks([BuildStep])
void main() {
  group('VocabularyBuilder Integration Test', () {
    late MockBuildStep mockBuildStep;
    late Map<String, String> testFiles;

    // Using test package ID instead of temporary directory to work with AssetId
    const testPackageId = 'test_package';
    const testManifestPath = 'test/manifest.vocab.json';
    const testVocabPath = 'test/test_vocab.ttl';
    const testOutputDir = 'lib/src/vocab/generated';

    setUp(() async {
      // Setup mock BuildStep
      mockBuildStep = MockBuildStep();

      // Track generated files
      testFiles = {};

      // Setup necessary mocks for BuildStep
      final inputId = AssetId(testPackageId, testManifestPath);
      when(mockBuildStep.inputId).thenReturn(inputId);

      // Mock reading the manifest file
      when(mockBuildStep.readAsString(any)).thenAnswer((invocation) async {
        final assetId = invocation.positionalArguments[0] as AssetId;
        if (assetId.path == testManifestPath) {
          return testManifest;
        }
        if (assetId.path == testVocabPath) {
          return testTurtleVocab;
        }
        throw Exception('Unknown asset: ${assetId.path}');
      });

      // Mock canRead checks
      when(mockBuildStep.canRead(any)).thenAnswer((invocation) async {
        final assetId = invocation.positionalArguments[0] as AssetId;
        return assetId.path == testManifestPath ||
            assetId.path == testVocabPath;
      });

      // Mock writing output files
      when(mockBuildStep.writeAsString(any, any)).thenAnswer((
        invocation,
      ) async {
        final assetId = invocation.positionalArguments[0] as AssetId;
        final content = invocation.positionalArguments[1] as String;
        testFiles[assetId.path] = content;
      });
    });

    test('builds vocabulary classes correctly', () async {
      // Create the builder
      final builder = VocabularyBuilder(
        manifestAssetPath: testManifestPath,
        outputDir: testOutputDir,
      );

      // Run the build
      await builder.build(mockBuildStep);

      // Verify the build extensions
      final extensions = builder.buildExtensions;
      expect(extensions.containsKey(testManifestPath), isTrue);
      expect(
        extensions[testManifestPath]!.any((e) => e.endsWith('_index.dart')),
        isTrue,
      );
      expect(
        extensions[testManifestPath]!.any((e) => e.endsWith('test.dart')),
        isTrue,
      );

      // Verify output files were generated
      expect(testFiles.isNotEmpty, isTrue);

      // Look for the index file content
      final indexFile = testFiles.entries.firstWhere(
        (entry) => entry.key.endsWith('_index.dart'),
        orElse: () => const MapEntry('', ''),
      );
      expect(indexFile.key.isNotEmpty, isTrue);
      expect(indexFile.value, contains("export 'test.dart';"));

      // Look for the vocabulary file content
      final vocabFile = testFiles.entries.firstWhere(
        (entry) =>
            entry.key.endsWith('test.dart') &&
            !entry.key.endsWith('_index.dart'),
        orElse: () => const MapEntry('', ''),
      );
      expect(vocabFile.key.isNotEmpty, isTrue);

      final vocabContent = vocabFile.value;
      expect(vocabContent, contains('class Test {'));
      expect(
        vocabContent,
        contains("static const String namespace = 'http://example.org/test#';"),
      );
      // Note: We can't test for exact IriTerm.prevalidated lines as the generator
      // might format the code differently in different runs
    });

    test('handles empty or invalid manifest gracefully', () async {
      // Create a builder with an invalid manifest path
      final builder = VocabularyBuilder(
        manifestAssetPath: 'invalid_path.json',
        outputDir: testOutputDir,
      );

      // Mock behavior for invalid path
      when(mockBuildStep.canRead(any)).thenAnswer((_) async => false);

      // Run the build
      await builder.build(mockBuildStep);

      // Verify no files were generated
      expect(testFiles.isEmpty, isTrue);
    });
  });
}
