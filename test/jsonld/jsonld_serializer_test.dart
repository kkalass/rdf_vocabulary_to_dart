import 'dart:convert';

import 'package:rdf_core/constants/rdf_constants.dart';
import 'package:rdf_core/graph/rdf_graph.dart';
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/graph/triple.dart';
import 'package:rdf_core/jsonld/jsonld_serializer.dart';
import 'package:test/test.dart';

void main() {
  group('JSON-LD Serializer', () {
    late JsonLdSerializer serializer;

    setUp(() {
      serializer = JsonLdSerializer();
    });

    test('should serialize empty graph to empty JSON object', () {
      final graph = RdfGraph();
      final result = serializer.write(graph);
      expect(result, '{}');
    });

    test('should serialize simple triple with literal', () {
      final graph = RdfGraph.fromTriples([
        Triple(
          IriTerm('http://example.org/subject'),
          IriTerm('http://example.org/predicate'),
          LiteralTerm.string('object'),
        ),
      ]);

      final result = serializer.write(graph);

      // Parse the JSON to verify structure
      final jsonObj = jsonDecode(result) as Map<String, dynamic>;

      expect(jsonObj.containsKey('@context'), isTrue);
      expect(jsonObj['@id'], equals('http://example.org/subject'));
      // Since example.org doesn't have a default prefix, the full IRI is used
      expect(jsonObj['http://example.org/predicate'], equals('object'));
    });

    test('should handle rdf:type with @type keyword', () {
      final graph = RdfGraph.fromTriples([
        Triple(
          IriTerm('http://example.org/subject'),
          RdfConstants.typeIri,
          IriTerm('http://example.org/Class'),
        ),
      ]);

      final result = serializer.write(graph);
      final jsonObj = jsonDecode(result) as Map<String, dynamic>;

      expect(jsonObj['@context']['rdf'], equals(RdfConstants.namespace));
      expect(jsonObj['@id'], equals('http://example.org/subject'));
      expect(jsonObj['@type'], isA<Map<String, dynamic>>());
      expect(jsonObj['@type']['@id'], equals('http://example.org/Class'));
    });

    test('should use @graph for multiple subjects', () {
      final graph = RdfGraph.fromTriples([
        Triple(
          IriTerm('http://example.org/subject1'),
          IriTerm('http://example.org/predicate'),
          LiteralTerm.string('object1'),
        ),
        Triple(
          IriTerm('http://example.org/subject2'),
          IriTerm('http://example.org/predicate'),
          LiteralTerm.string('object2'),
        ),
      ]);

      final result = serializer.write(graph);
      final jsonObj = jsonDecode(result) as Map<String, dynamic>;

      expect(jsonObj.containsKey('@context'), isTrue);
      expect(jsonObj.containsKey('@graph'), isTrue);
      expect(jsonObj['@graph'], isA<List>());
      expect(jsonObj['@graph'].length, equals(2));
    });

    test('should handle blank nodes', () {
      final graph = RdfGraph.fromTriples([
        Triple(
          IriTerm('http://example.org/subject'),
          IriTerm('http://example.org/predicate'),
          BlankNodeTerm('b1'),
        ),
      ]);

      final result = serializer.write(graph);
      final jsonObj = jsonDecode(result) as Map<String, dynamic>;

      expect(
        jsonObj['http://example.org/predicate'],
        isA<Map<String, dynamic>>(),
      );
      expect(jsonObj['http://example.org/predicate']['@id'], equals('_:b1'));
    });

    test('should handle typed literals', () {
      final graph = RdfGraph.fromTriples([
        Triple(
          IriTerm('http://example.org/subject'),
          IriTerm('http://example.org/intValue'),
          LiteralTerm(
            '42',
            datatype: IriTerm('http://www.w3.org/2001/XMLSchema#integer'),
          ),
        ),
        Triple(
          IriTerm('http://example.org/subject'),
          IriTerm('http://example.org/floatValue'),
          LiteralTerm(
            '3.14',
            datatype: IriTerm('http://www.w3.org/2001/XMLSchema#decimal'),
          ),
        ),
        Triple(
          IriTerm('http://example.org/subject'),
          IriTerm('http://example.org/boolValue'),
          LiteralTerm(
            'true',
            datatype: IriTerm('http://www.w3.org/2001/XMLSchema#boolean'),
          ),
        ),
      ]);

      final result = serializer.write(graph);
      final jsonObj = jsonDecode(result) as Map<String, dynamic>;

      expect(
        jsonObj['@context']['xsd'],
        equals('http://www.w3.org/2001/XMLSchema#'),
      );
      expect(jsonObj['http://example.org/intValue'], equals(42));
      expect(jsonObj['http://example.org/floatValue'], equals(3.14));
      expect(jsonObj['http://example.org/boolValue'], equals(true));
    });

    test('should handle language-tagged literals', () {
      final graph = RdfGraph.fromTriples([
        Triple(
          IriTerm('http://example.org/subject'),
          IriTerm('http://example.org/name'),
          LiteralTerm.withLanguage('John Doe', 'en'),
        ),
      ]);

      final result = serializer.write(graph);
      final jsonObj = jsonDecode(result) as Map<String, dynamic>;

      final nameValue = jsonObj['http://example.org/name'];
      expect(nameValue, isA<Map<String, dynamic>>());
      expect(nameValue['@value'], equals('John Doe'));
      expect(nameValue['@language'], equals('en'));
    });

    test('should use custom prefixes when provided', () {
      final graph = RdfGraph.fromTriples([
        Triple(
          IriTerm('http://example.org/subject'),
          IriTerm('http://example.org/vocabulary/predicate'),
          LiteralTerm.string('object'),
        ),
      ]);

      final customPrefixes = {
        'ex': 'http://example.org/',
        'vocab': 'http://example.org/vocabulary/',
      };

      final result = serializer.write(graph, customPrefixes: customPrefixes);

      final jsonObj = jsonDecode(result) as Map<String, dynamic>;

      expect(jsonObj['@context']['ex'], equals('http://example.org/'));
      expect(
        jsonObj['@context']['vocab'],
        equals('http://example.org/vocabulary/'),
      );
      // Now we expect the prefixed version of the predicate
      expect(jsonObj['vocab:predicate'], equals('object'));
    });

    test('should serialize complex graph correctly using prefixes', () {
      final graph = RdfGraph.fromTriples([
        Triple(
          IriTerm('http://example.org/person/john'),
          RdfConstants.typeIri,
          IriTerm('http://xmlns.com/foaf/0.1/Person'),
        ),
        Triple(
          IriTerm('http://example.org/person/john'),
          IriTerm('http://xmlns.com/foaf/0.1/name'),
          LiteralTerm.string('John Doe'),
        ),
        Triple(
          IriTerm('http://example.org/person/john'),
          IriTerm('http://xmlns.com/foaf/0.1/age'),
          LiteralTerm(
            '42',
            datatype: IriTerm('http://www.w3.org/2001/XMLSchema#integer'),
          ),
        ),
        Triple(
          IriTerm('http://example.org/person/john'),
          IriTerm('http://xmlns.com/foaf/0.1/knows'),
          IriTerm('http://example.org/person/jane'),
        ),
        Triple(
          IriTerm('http://example.org/person/jane'),
          RdfConstants.typeIri,
          IriTerm('http://xmlns.com/foaf/0.1/Person'),
        ),
        Triple(
          IriTerm('http://example.org/person/jane'),
          IriTerm('http://xmlns.com/foaf/0.1/name'),
          LiteralTerm.string('Jane Smith'),
        ),
      ]);

      final result = serializer.write(graph);
      final jsonObj = jsonDecode(result) as Map<String, dynamic>;

      expect(jsonObj['@context']['foaf'], equals('http://xmlns.com/foaf/0.1/'));
      expect(jsonObj['@context']['rdf'], equals(RdfConstants.namespace));
      expect(jsonObj.containsKey('@graph'), isTrue);

      final graph1 = jsonObj['@graph'].firstWhere(
        (node) => node['@id'] == 'http://example.org/person/john',
      );

      expect(
        graph1['@type']['@id'],
        equals('http://xmlns.com/foaf/0.1/Person'),
      );
      // Now we use prefixed property names
      expect(graph1['foaf:name'], equals('John Doe'));
      expect(graph1['foaf:age'], equals(42));
      expect(
        graph1['foaf:knows']['@id'],
        equals('http://example.org/person/jane'),
      );

      final graph2 = jsonObj['@graph'].firstWhere(
        (node) => node['@id'] == 'http://example.org/person/jane',
      );
      expect(graph2['foaf:name'], equals('Jane Smith'));
    });
  });
}
