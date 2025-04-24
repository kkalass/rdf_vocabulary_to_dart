import 'package:rdf_core/constants/rdf_constants.dart';
import 'package:rdf_core/exceptions/exceptions.dart';
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/jsonld/jsonld_parser.dart';
import 'package:test/test.dart';

void main() {
  group('JsonLdParser', () {
    test('parses simple JSON-LD object', () {
      final jsonLd = '''
      {
        "@context": {
          "name": "http://xmlns.com/foaf/0.1/name",
          "homepage": "http://xmlns.com/foaf/0.1/homepage"
        },
        "@id": "http://example.org/person/john",
        "name": "John Smith",
        "homepage": "http://example.org/john/"
      }
      ''';

      final parser = JsonLdParser(jsonLd);
      final triples = parser.parse();

      expect(triples.length, 2);

      // Find the name triple
      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/name') &&
              t.object == LiteralTerm.string("John Smith"),
        ),
        isTrue,
      );

      // Find the homepage triple
      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/homepage') &&
              t.object == IriTerm('http://example.org/john/'),
        ),
        isTrue,
      );
    });

    test('parses JSON-LD array at root level', () {
      final jsonLd = '''
      [
        {
          "@context": {
            "name": "http://xmlns.com/foaf/0.1/name"
          },
          "@id": "http://example.org/person/john",
          "name": "John Smith"
        },
        {
          "@context": {
            "name": "http://xmlns.com/foaf/0.1/name"
          },
          "@id": "http://example.org/person/jane",
          "name": "Jane Doe"
        }
      ]
      ''';

      final parser = JsonLdParser(jsonLd);
      final triples = parser.parse();

      expect(triples.length, 2);

      // Check that we have triples for both John and Jane
      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/name') &&
              t.object == LiteralTerm.string("John Smith"),
        ),
        isTrue,
      );

      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/jane') &&
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/name') &&
              t.object == LiteralTerm.string('Jane Doe'),
        ),
        isTrue,
      );
    });

    test('handles type via @type keyword', () {
      final jsonLd = '''
      {
        "@context": {
          "Person": "http://xmlns.com/foaf/0.1/Person",
          "name": "http://xmlns.com/foaf/0.1/name"
        },
        "@id": "http://example.org/person/john",
        "@type": "Person",
        "name": "John Smith"
      }
      ''';

      final parser = JsonLdParser(jsonLd);
      final triples = parser.parse();

      expect(triples.length, 2);

      // Check the type triple exists with the fully expanded IRI
      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate ==
                  IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type') &&
              t.object == IriTerm('http://xmlns.com/foaf/0.1/Person'),
        ),
        isTrue,
        reason: 'Type value should be fully expanded using context mapping',
      );
    });

    test('handles @type as a prefixed string', () {
      final jsonLd = '''
      {
        "@context": {
          "foaf": "http://xmlns.com/foaf/0.1/",
          "name": "http://xmlns.com/foaf/0.1/name"
        },
        "@id": "http://example.org/person/john",
        "@type": "foaf:Person",
        "name": "John Smith"
      }
      ''';

      final parser = JsonLdParser(jsonLd);
      final triples = parser.parse();

      expect(triples.length, 2);

      // Check the type triple exists with the fully expanded IRI
      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == RdfConstants.typeIri &&
              t.object == IriTerm('http://xmlns.com/foaf/0.1/Person'),
        ),
        isTrue,
        reason: 'Prefixed type value should be expanded correctly',
      );
    });

    test('handles @type as a direct URL', () {
      final jsonLd = '''
      {
        "@context": {
          "name": "http://xmlns.com/foaf/0.1/name"
        },
        "@id": "http://example.org/person/john",
        "@type": "http://xmlns.com/foaf/0.1/Person",
        "name": "John Smith"
      }
      ''';

      final parser = JsonLdParser(jsonLd);
      final triples = parser.parse();

      expect(triples.length, 2);

      // Check the type triple exists with the fully expanded IRI
      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == RdfConstants.typeIri &&
              t.object == IriTerm('http://xmlns.com/foaf/0.1/Person'),
        ),
        isTrue,
        reason: 'Direct URL type should be preserved',
      );
    });

    test('handles @type as an object with @id', () {
      final jsonLd = '''
      {
        "@context": {
          "name": "http://xmlns.com/foaf/0.1/name"
        },
        "@id": "http://example.org/person/john",
        "@type": {"@id": "http://xmlns.com/foaf/0.1/Person"},
        "name": "John Smith"
      }
      ''';

      final parser = JsonLdParser(jsonLd);
      final triples = parser.parse();

      expect(triples.length, 2);

      // Check the type triple exists with the fully expanded IRI
      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == RdfConstants.typeIri &&
              t.object == IriTerm('http://xmlns.com/foaf/0.1/Person'),
        ),
        isTrue,
        reason: 'Object with @id type should be handled correctly',
      );
    });

    test('handles @type with multiple values', () {
      final jsonLd = '''
      {
        "@context": {
          "foaf": "http://xmlns.com/foaf/0.1/",
          "schema": "http://schema.org/",
          "name": "http://xmlns.com/foaf/0.1/name"
        },
        "@id": "http://example.org/person/john",
        "@type": ["foaf:Person", "schema:Person"],
        "name": "John Smith"
      }
      ''';

      final parser = JsonLdParser(jsonLd);
      final triples = parser.parse();

      expect(triples.length, 3);

      // Check both type triples exist
      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == RdfConstants.typeIri &&
              t.object == IriTerm('http://xmlns.com/foaf/0.1/Person'),
        ),
        isTrue,
        reason: 'First type in array should be parsed correctly',
      );

      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == RdfConstants.typeIri &&
              t.object == IriTerm('http://schema.org/Person'),
        ),
        isTrue,
        reason: 'Second type in array should be parsed correctly',
      );
    });

    test('handles nested objects as blank nodes', () {
      final jsonLd = '''
      {
        "@context": {
          "name": "http://xmlns.com/foaf/0.1/name",
          "knows": "http://xmlns.com/foaf/0.1/knows"
        },
        "@id": "http://example.org/person/john",
        "name": "John Smith",
        "knows": {
          "name": "Jane Doe"
        }
      }
      ''';

      final parser = JsonLdParser(jsonLd);
      final triples = parser.parse();

      // Should be 3 triples: name, knows, and the blank node's name
      expect(triples.length, 3);

      // Find the knows triple to get the blank node ID
      final knowsTriple = triples.firstWhere(
        (t) => t.predicate == IriTerm('http://xmlns.com/foaf/0.1/knows'),
      );

      expect(
        knowsTriple.subject,
        equals(IriTerm('http://example.org/person/john')),
      );
      expect(knowsTriple.object is BlankNodeTerm, isTrue);

      final blankNodeId = knowsTriple.object;

      // Verify blank node properties
      expect(
        triples.any(
          (t) =>
              t.subject == blankNodeId &&
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/name') &&
              t.object == LiteralTerm.string('Jane Doe'),
        ),
        isTrue,
      );
    });

    test('handles array values for properties', () {
      final jsonLd = '''
      {
        "@context": {
          "name": "http://xmlns.com/foaf/0.1/name",
          "interest": "http://xmlns.com/foaf/0.1/interest"
        },
        "@id": "http://example.org/person/john",
        "name": "John Smith",
        "interest": ["Programming", "Reading", "Cycling"]
      }
      ''';

      final parser = JsonLdParser(jsonLd);
      final triples = parser.parse();

      // Should be 4 triples: name + 3 interests
      expect(triples.length, 4);

      // Test name triple
      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/name') &&
              t.object == LiteralTerm.string('John Smith'),
        ),
        isTrue,
      );

      // Test interest triples
      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/interest') &&
              t.object == LiteralTerm.string('Programming'),
        ),
        isTrue,
      );

      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/interest') &&
              t.object == LiteralTerm.string('Reading'),
        ),
        isTrue,
      );

      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/interest') &&
              t.object == LiteralTerm.string('Cycling'),
        ),
        isTrue,
      );
    });

    test('handles @graph structure', () {
      final jsonLd = '''
      {
        "@context": {
          "name": "http://xmlns.com/foaf/0.1/name"
        },
        "@graph": [
          {
            "@id": "http://example.org/person/john",
            "name": "John Smith"
          },
          {
            "@id": "http://example.org/person/jane",
            "name": "Jane Doe"
          }
        ]
      }
      ''';

      final parser = JsonLdParser(jsonLd);
      final triples = parser.parse();

      expect(triples.length, 2);

      // Check both triples exist
      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/john') &&
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/name') &&
              t.object == LiteralTerm.string('John Smith'),
        ),
        isTrue,
      );

      expect(
        triples.any(
          (t) =>
              t.subject == IriTerm('http://example.org/person/jane') &&
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/name') &&
              t.object == LiteralTerm.string('Jane Doe'),
        ),
        isTrue,
      );
    });

    test('handles typed literals with @value and @type', () {
      final jsonLd = '''
      {
        "@context": {
          "birthDate": "http://xmlns.com/foaf/0.1/birthDate"
        },
        "@id": "http://example.org/person/john",
        "birthDate": {
          "@value": "1990-07-04",
          "@type": "http://www.w3.org/2001/XMLSchema#date"
        }
      }
      ''';

      final parser = JsonLdParser(jsonLd);
      final triples = parser.parse();

      expect(triples.length, 1);

      final triple = triples.first;
      expect(triple.subject, equals(IriTerm('http://example.org/person/john')));
      expect(
        triple.predicate,
        equals(IriTerm('http://xmlns.com/foaf/0.1/birthDate')),
      );
      expect(
        triple.object,
        LiteralTerm(
          '1990-07-04',
          datatype: IriTerm('http://www.w3.org/2001/XMLSchema#date'),
        ),
      );
    });

    test('handles language-tagged literals with @value and @language', () {
      final jsonLd = '''
      {
        "@context": {
          "description": "http://xmlns.com/foaf/0.1/description"
        },
        "@id": "http://example.org/person/john",
        "description": {
          "@value": "Programmierer und Radfahrer",
          "@language": "de"
        }
      }
      ''';

      final parser = JsonLdParser(jsonLd);
      final triples = parser.parse();

      expect(triples.length, 1);

      final triple = triples.first;
      expect(triple.subject, equals(IriTerm('http://example.org/person/john')));
      expect(
        triple.predicate,
        equals(IriTerm('http://xmlns.com/foaf/0.1/description')),
      );
      expect(
        triple.object,
        equals(LiteralTerm.withLanguage('Programmierer und Radfahrer', 'de')),
      );
    });

    test('resolves IRIs against base URI', () {
      final jsonLd = '''
      {
        "@context": {
          "@base": "http://example.org/",
          "name": "http://xmlns.com/foaf/0.1/name"
        },
        "@id": "person/john",
        "name": "John Smith"
      }
      ''';

      final parser = JsonLdParser(jsonLd, baseUri: 'http://example.org/');
      final triples = parser.parse();

      expect(triples.length, 1);

      final triple = triples.first;
      expect(triple.subject, equals(IriTerm('http://example.org/person/john')));
      expect(
        triple.predicate,
        equals(IriTerm('http://xmlns.com/foaf/0.1/name')),
      );
      expect(triple.object, equals(LiteralTerm.string('John Smith')));
    });

    test('throws exception for invalid JSON', () {
      final invalidJson = '{name: "Invalid JSON"}';

      final parser = JsonLdParser(invalidJson);
      expect(() => parser.parse(), throwsA(isA<RdfSyntaxException>()));
    });
  });
}
