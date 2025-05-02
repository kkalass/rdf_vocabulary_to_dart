// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:rdf_vocabulary_to_dart/rdf_vocabulary_to_dart.dart';
import 'package:test/test.dart';

void main() {
  group('rdf_vocabulary_to_dart library', () {
    test(
      'rdfVocabularyToDart creates a VocabularyBuilder with default options',
      () {
        final builder = rdfVocabularyToDart(BuilderOptions(const {}));

        expect(builder, isNotNull);
        expect(builder, isA<Builder>());
      },
    );

    test(
      'rdfVocabularyToDart creates a VocabularyBuilder with custom options',
      () {
        final builder = rdfVocabularyToDart(
          BuilderOptions(const {
            'vocabulary_config_path': 'custom/path/vocab.json',
            'output_dir': 'custom/output/path',
          }),
        );

        expect(builder, isNotNull);
        expect(builder, isA<Builder>());
      },
    );

    test('getBuildExtensions returns valid extensions map', () {
      final extensions = getBuildExtensions({
        'vocabulary_config_path': 'test/vocab.json',
        'output_dir': 'test/output',
      });

      expect(extensions, isA<Map<String, List<String>>>());
      expect(extensions.keys.length, equals(1));
      expect(extensions.keys.first, equals('test/vocab.json'));

      final outputs = extensions.values.first;
      expect(outputs, isA<List<String>>());
      expect(outputs.any((e) => e.endsWith('_index.dart')), isTrue);
    });

    test('fallback values are used when not provided', () {
      final extensions = getBuildExtensions({});

      expect(extensions, isA<Map<String, List<String>>>());
      expect(extensions.keys.length, equals(1));
      expect(extensions.keys.first, equals(fallbackVocabJsonPath));

      final outputs = extensions.values.first;
      expect(outputs, isA<List<String>>());
      expect(outputs.any((e) => e.contains(fallbackOutputDir)), isTrue);
    });
  });
}
