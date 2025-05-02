// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rdf_vocabulary_to_dart/src/vocab/builder/cross_vocabulary_resolver.dart';
import 'package:rdf_vocabulary_to_dart/src/vocab/builder/model/vocabulary_model.dart';
import 'package:test/test.dart';

import 'cross_vocabulary_resolver_test.mocks.dart';

// Create a class to mock instead of a function type
abstract class VocabularyLoader {
  Future<VocabularyModel?> loadVocabulary(String namespace, String name);
}

@GenerateMocks([VocabularyLoader])
void main() {
  group('CrossVocabularyResolver', () {
    late MockVocabularyLoader mockLoader;
    late CrossVocabularyResolver resolver;

    setUp(() {
      mockLoader = MockVocabularyLoader();
      resolver = CrossVocabularyResolver(
        vocabularyLoader:
            (namespace, name) => mockLoader.loadVocabulary(namespace, name),
      );

      // Default mock behavior - don't load any vocabulary by default
      when(mockLoader.loadVocabulary(any, any)).thenAnswer((_) async => null);
    });

    test('registers vocabulary and its class hierarchy correctly', () {
      // Create a test vocabulary
      final model = VocabularyModel(
        name: 'test',
        namespace: 'http://example.org/test#',
        prefix: 'test',
        classes: [
          VocabularyClass(
            localName: 'Person',
            iri: 'http://example.org/test#Person',
            superClasses: ['http://example.org/test#Agent'],
          ),
          VocabularyClass(
            localName: 'Agent',
            iri: 'http://example.org/test#Agent',
            superClasses: ['http://www.w3.org/2000/01/rdf-schema#Resource'],
          ),
        ],
        properties: [
          VocabularyProperty(
            localName: 'name',
            iri: 'http://example.org/test#name',
            domains: ['http://example.org/test#Person'],
          ),
          VocabularyProperty(
            localName: 'activity',
            iri: 'http://example.org/test#activity',
            domains: ['http://example.org/test#Agent'],
          ),
        ],
        datatypes: [],
        otherTerms: [],
      );

      // Register the vocabulary
      resolver.registerVocabulary(model);

      // Test property inheritance
      final personProperties = resolver.getPropertiesForClass(
        'http://example.org/test#Person',
        'http://example.org/test#',
      );

      // Person should have both its own property and inherited properties from Agent
      expect(personProperties.length, equals(2));
      expect(
        personProperties.any((p) => p.iri == 'http://example.org/test#name'),
        isTrue,
      );
      expect(
        personProperties.any(
          (p) => p.iri == 'http://example.org/test#activity',
        ),
        isTrue,
      );
    });

    test('detects and loads implied vocabularies', () async {
      // Create a test vocabulary with references to external vocabulary
      final testModel = VocabularyModel(
        name: 'test',
        namespace: 'http://example.org/test#',
        prefix: 'test',
        classes: [
          VocabularyClass(
            localName: 'Document',
            iri: 'http://example.org/test#Document',
            superClasses: ['http://external.org/vocab#Resource'],
          ),
        ],
        properties: [
          VocabularyProperty(
            localName: 'title',
            iri: 'http://example.org/test#title',
            domains: ['http://example.org/test#Document'],
          ),
        ],
        datatypes: [],
        otherTerms: [],
      );

      // Create the implied vocabulary that should be loaded
      final impliedModel = VocabularyModel(
        name: 'external',
        namespace: 'http://external.org/vocab#',
        prefix: 'ext',
        classes: [
          VocabularyClass(
            localName: 'Resource',
            iri: 'http://external.org/vocab#Resource',
          ),
        ],
        properties: [
          VocabularyProperty(
            localName: 'created',
            iri: 'http://external.org/vocab#created',
            domains: ['http://external.org/vocab#Resource'],
          ),
        ],
        datatypes: [],
        otherTerms: [],
      );

      // Configure mock to return the implied vocabulary
      when(
        mockLoader.loadVocabulary('http://external.org/vocab#', any),
      ).thenAnswer((_) async => impliedModel);

      // Register the test vocabulary
      resolver.registerVocabulary(testModel);

      // Load pending vocabularies
      await resolver.loadPendingVocabularies();

      // Verify the implied vocabulary was requested
      verify(
        mockLoader.loadVocabulary('http://external.org/vocab#', any),
      ).called(1);

      // Test cross-vocabulary property inheritance
      final documentProperties = resolver.getPropertiesForClass(
        'http://example.org/test#Document',
        'http://example.org/test#',
      );

      // Document should have its own property (title)
      expect(
        documentProperties.any((p) => p.iri == 'http://example.org/test#title'),
        isTrue,
      );

      // Check cross-vocabulary properties
      final crossVocabProperties = resolver.getCrossVocabPropertiesForClass(
        'http://example.org/test#Document',
        'http://example.org/test#',
      );

      // Document should inherit property from external Resource
      expect(crossVocabProperties.length, equals(1));
      expect(
        crossVocabProperties.any(
          (p) => p.iri == 'http://external.org/vocab#created',
        ),
        isTrue,
      );
    });

    test('extracts prefixes from Turtle content', () {
      const turtleContent = '''
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
@prefix test: <http://example.org/test#> .

test:Person a rdfs:Class ;
  rdfs:label "Person" ;
  rdfs:comment "A person class" .
''';

      resolver.extractPrefixesFromTurtle(turtleContent);

      // Register a vocabulary that uses one of the extracted namespaces
      final rdfModel = VocabularyModel(
        name: 'rdf', // The name should match the extracted prefix
        namespace: 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
        prefix: 'rdf',
        classes: [],
        properties: [
          VocabularyProperty(
            localName: 'type',
            iri: 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
            domains: ['http://www.w3.org/2000/01/rdf-schema#Resource'],
          ),
        ],
        datatypes: [],
        otherTerms: [],
      );

      resolver.registerVocabulary(rdfModel);

      // Register a test vocabulary
      final testModel = VocabularyModel(
        name: 'test',
        namespace: 'http://example.org/test#',
        prefix: 'test',
        classes: [
          VocabularyClass(
            localName: 'Person',
            iri: 'http://example.org/test#Person',
            superClasses: ['http://www.w3.org/2000/01/rdf-schema#Resource'],
          ),
        ],
        properties: [],
        datatypes: [],
        otherTerms: [],
      );

      resolver.registerVocabulary(testModel);

      // Get properties for test:Person, which should include rdf:type
      final personProperties = resolver.getPropertiesForClass(
        'http://example.org/test#Person',
        'http://example.org/test#',
      );

      // Verify cross-vocabulary properties are returned with correct prefixes
      final crossVocabProperties = resolver.getCrossVocabPropertiesForClass(
        'http://example.org/test#Person',
        'http://example.org/test#',
      );

      expect(
        crossVocabProperties.any(
          (p) => p.iri == 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
        ),
        isTrue,
      );
      expect(
        personProperties.any(
          (p) => p.iri == 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type',
        ),
        isTrue,
      );
    });

    test('provides useful debug information about class inheritance', () {
      // Create a test vocabulary with a hierarchy
      final model = VocabularyModel(
        name: 'test',
        namespace: 'http://example.org/test#',
        prefix: 'test',
        classes: [
          VocabularyClass(
            localName: 'Person',
            iri: 'http://example.org/test#Person',
            superClasses: ['http://example.org/test#Agent'],
          ),
          VocabularyClass(
            localName: 'Agent',
            iri: 'http://example.org/test#Agent',
            superClasses: ['http://example.org/test#Thing'],
          ),
          VocabularyClass(
            localName: 'Thing',
            iri: 'http://example.org/test#Thing',
          ),
        ],
        properties: [
          VocabularyProperty(
            localName: 'name',
            iri: 'http://example.org/test#name',
            domains: ['http://example.org/test#Person'],
          ),
        ],
        datatypes: [],
        otherTerms: [],
      );

      // Register the vocabulary
      resolver.registerVocabulary(model);

      // Get debug info
      final debugInfo = resolver.getClassInheritanceDebugInfo(
        'http://example.org/test#Person',
      );

      // Verify debug info structure
      expect(debugInfo['class'], equals('http://example.org/test#Person'));

      // Direct superclasses
      expect(
        debugInfo['directSuperclasses'],
        contains('http://example.org/test#Agent'),
      );

      // All superclasses (transitive)
      expect(
        debugInfo['allSuperclasses'],
        containsAll([
          'http://example.org/test#Agent',
          'http://example.org/test#Thing',
        ]),
      );
    });
  });
}
