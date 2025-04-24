import 'package:test/test.dart';
import 'package:rdf_core/exceptions/exceptions.dart';
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/turtle/turtle_parser.dart';

void main() {
  group('TurtleParser', () {
    test('should parse prefixes', () {
      final parser = TurtleParser(
        '@prefix solid: <http://www.w3.org/ns/solid/terms#> .',
      );
      final triples = parser.parse();
      expect(triples, isEmpty);
    });

    test('should parse simple triples', () {
      final parser = TurtleParser(
        '<http://example.com/foo> <http://example.com/bar> "baz" .',
      );
      final triples = parser.parse();
      expect(triples.length, equals(1));
      expect(triples[0].subject, equals(IriTerm('http://example.com/foo')));
      expect(triples[0].predicate, equals(IriTerm('http://example.com/bar')));
      expect(triples[0].object, equals(LiteralTerm.string('baz')));
    });

    test('should parse simple triples with escapes', () {
      final parser = TurtleParser(
        '<http://example.com/foo> <http://example.com/bar> "baz\\r\\nis\\"so cool\\" - or is \\\\ more cool? \\t \\b \\f" .',
      );
      final triples = parser.parse();
      expect(triples.length, equals(1));
      expect(triples[0].subject, equals(IriTerm('http://example.com/foo')));
      expect(triples[0].predicate, equals(IriTerm('http://example.com/bar')));
      expect(
        triples[0].object,
        equals(
          LiteralTerm.string(
            'baz\r\nis"so cool" - or is \\ more cool? \t \b \f',
          ),
        ),
      );
    });

    test('should parse simple triples with boolean type', () {
      final parser = TurtleParser(
        '<http://example.com/foo> <http://example.com/bar> "baz"^^<http://www.w3.org/2001/XMLSchema#boolean> .',
      );
      final triples = parser.parse();
      expect(triples.length, equals(1));
      expect(triples[0].subject, equals(IriTerm('http://example.com/foo')));
      expect(triples[0].predicate, equals(IriTerm('http://example.com/bar')));
      expect(triples[0].object, equals(LiteralTerm.typed('baz', 'boolean')));
    });

    test('should parse simple triples with boolean type and prefix', () {
      final parser = TurtleParser(
        '@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .\n'
        '<http://example.com/foo> <http://example.com/bar> "baz"^^xsd:boolean .',
      );
      final triples = parser.parse();
      expect(triples.length, equals(1));
      expect(triples[0].subject, equals(IriTerm('http://example.com/foo')));
      expect(triples[0].predicate, equals(IriTerm('http://example.com/bar')));
      expect(triples[0].object, equals(LiteralTerm.typed('baz', 'boolean')));
    });

    test('should parse simple triples with language tag', () {
      final parser = TurtleParser(
        '<http://example.com/foo> <http://example.com/bar> "baz"@de .',
      );
      final triples = parser.parse();
      expect(triples.length, equals(1));
      expect(triples[0].subject, equals(IriTerm('http://example.com/foo')));
      expect(triples[0].predicate, equals(IriTerm('http://example.com/bar')));
      expect(triples[0].object, equals(LiteralTerm.withLanguage('baz', 'de')));
    });

    test('should parse semicolon-separated triples', () {
      final parser = TurtleParser('''
        <http://example.com/foo> 
          <http://example.com/bar> "baz" ;
          <http://example.com/qux> "quux" .
        ''');
      final triples = parser.parse();
      expect(triples.length, equals(2));
      expect(triples[0].subject, equals(IriTerm('http://example.com/foo')));
      expect(triples[0].predicate, equals(IriTerm('http://example.com/bar')));
      expect(triples[0].object, equals(LiteralTerm.string('baz')));
      expect(triples[1].subject, equals(IriTerm('http://example.com/foo')));
      expect(triples[1].predicate, equals(IriTerm('http://example.com/qux')));
      expect(triples[1].object, equals(LiteralTerm.string('quux')));
    });

    test('should parse blank nodes', () {
      final parser = TurtleParser('[ <http://example.com/bar> "baz" ] .');
      final triples = parser.parse();
      expect(triples.length, equals(1));
      expect(triples[0].subject, isA<BlankNodeTerm>());
      expect((triples[0].subject as BlankNodeTerm).label, startsWith('b'));
      expect(triples[0].predicate, equals(IriTerm('http://example.com/bar')));
      expect(triples[0].object, equals(LiteralTerm.string('baz')));
    });

    test('should parse type declarations', () {
      final parser = TurtleParser(
        '<http://example.com/foo> a <http://example.com/Bar> .',
      );
      final triples = parser.parse();
      expect(triples.length, equals(1));
      expect(triples[0].subject, equals(IriTerm('http://example.com/foo')));
      expect(
        triples[0].predicate,
        equals(IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')),
      );
      expect(triples[0].object, equals(IriTerm('http://example.com/bar')));
    });

    test('should reject using "a" as a subject', () {
      final parser = TurtleParser('a <http://example.com/bar> "baz" .');
      expect(() => parser.parse(), throwsA(isA<RdfSyntaxException>()));
    });

    test('should parse a complete profile', () {
      final parser = TurtleParser('''
        @prefix solid: <http://www.w3.org/ns/solid/terms#> .
        @prefix space: <http://www.w3.org/ns/pim/space#> .
        
        <https://example.com/profile#me>
          a solid:Profile ;
          solid:storage <https://example.com/storage/> ;
          space:storage <https://example.com/storage/> .
        ''');
      final triples = parser.parse();
      expect(triples.length, equals(3));

      // Type declaration
      expect(
        triples[0].subject,
        equals(IriTerm('https://example.com/profile#me')),
      );
      expect(
        triples[0].predicate,
        equals(IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')),
      );
      expect(
        triples[0].object,
        equals(IriTerm('http://www.w3.org/ns/solid/terms#Profile')),
      );

      // Storage declarations
      expect(
        triples[1].subject,
        equals(IriTerm('https://example.com/profile#me')),
      );
      expect(
        triples[1].predicate,
        equals(IriTerm('http://www.w3.org/ns/solid/terms#storage')),
      );
      expect(
        triples[1].object,
        equals(IriTerm('https://example.com/storage/')),
      );

      expect(
        triples[2].subject,
        equals(IriTerm('https://example.com/profile#me')),
      );
      expect(
        triples[2].predicate,
        equals(IriTerm('http://www.w3.org/ns/pim/space#storage')),
      );
      expect(
        triples[2].object,
        equals(IriTerm('https://example.com/storage/')),
      );
    });

    test('should parse a simple profile', () {
      final input = '''
        @prefix solid: <http://www.w3.org/ns/solid/terms#> .
        @prefix space: <http://www.w3.org/ns/pim/space#> .
        
        <https://example.com/profile#me>
          a solid:Profile ;
          solid:storage <https://example.com/storage/> ;
          space:storage <https://example.com/storage/> .
      ''';

      final parser = TurtleParser(input);
      final triples = parser.parse();

      expect(triples.length, equals(3));

      // Check type declaration
      expect(
        triples[0].subject,
        equals(IriTerm('https://example.com/profile#me')),
      );
      expect(
        triples[0].predicate,
        equals(IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')),
      );
      expect(
        triples[0].object,
        equals(IriTerm('http://www.w3.org/ns/solid/terms#Profile')),
      );

      // Check solid:storage
      expect(
        triples[1].subject,
        equals(IriTerm('https://example.com/profile#me')),
      );
      expect(
        triples[1].predicate,
        equals(IriTerm('http://www.w3.org/ns/solid/terms#storage')),
      );
      expect(
        triples[1].object,
        equals(IriTerm('https://example.com/storage/')),
      );

      // Check space:storage
      expect(
        triples[2].subject,
        equals(IriTerm('https://example.com/profile#me')),
      );
      expect(
        triples[2].predicate,
        equals(IriTerm('http://www.w3.org/ns/pim/space#storage')),
      );
      expect(
        triples[2].object,
        equals(IriTerm('https://example.com/storage/')),
      );
    });

    test('should resolve relative IRIs using the base URI', () {
      final parser = TurtleParser(
        '<foo> <bar> <baz> .',
        baseUri: 'http://example.com/',
      );
      final triples = parser.parse();

      expect(triples.length, equals(1));
      expect(triples[0].subject, equals(IriTerm('http://example.com/foo')));
      expect(triples[0].predicate, equals(IriTerm('http://example.com/bar')));
      expect(triples[0].object, equals(IriTerm('http://example.com/baz')));
    });

    test('should handle prefixed names with empty prefix', () {
      final parser = TurtleParser('''
        @prefix : <http://example.com/default#> .
        :foo :bar :baz .
      ''');
      final triples = parser.parse();

      expect(triples.length, equals(1));
      expect(
        triples[0].subject,
        equals(IriTerm('http://example.com/default#foo')),
      );
      expect(
        triples[0].predicate,
        equals(IriTerm('http://example.com/default#bar')),
      );
      expect(
        triples[0].object,
        equals(IriTerm('http://example.com/default#baz')),
      );
    });

    test('should throw RdfSyntaxException for unknown prefix', () {
      final parser = TurtleParser(
        'unknown:foo <http://example.com/bar> "baz" .',
      );
      expect(() => parser.parse(), throwsA(isA<RdfSyntaxException>()));
    });

    test('should parse objects with multiple commas', () {
      final parser = TurtleParser('''
        @prefix ex: <http://example.com/> .
        ex:subject ex:predicate "obj1", "obj2", "obj3" .
      ''');
      final triples = parser.parse();

      expect(triples.length, equals(3));
      expect(triples[0].subject, equals(IriTerm('http://example.com/subject')));
      expect(
        triples[0].predicate,
        equals(IriTerm('http://example.com/predicate')),
      );
      expect(triples[0].object, equals(LiteralTerm.string('obj1')));

      expect(triples[1].subject, equals(IriTerm('http://example.com/subject')));
      expect(
        triples[1].predicate,
        equals(IriTerm('http://example.com/predicate')),
      );
      expect(triples[1].object, equals(LiteralTerm.string('obj2')));

      expect(triples[2].subject, equals(IriTerm('http://example.com/subject')));
      expect(
        triples[2].predicate,
        equals(IriTerm('http://example.com/predicate')),
      );
      expect(triples[2].object, equals(LiteralTerm.string('obj3')));
    });

    test('should handle Unicode escape sequences in literals', () {
      final parser = TurtleParser(
        '''<http://example.com/foo> <http://example.com/bar> "Copyright \\u00A9 2025" .''',
      );
      final triples = parser.parse();

      expect(triples.length, equals(1));
      expect(triples[0].subject, equals(IriTerm('http://example.com/foo')));
      expect(triples[0].predicate, equals(IriTerm('http://example.com/bar')));
      expect(triples[0].object, equals(LiteralTerm.string('Copyright © 2025')));
    });

    test('should handle long Unicode escape sequences', () {
      final parser = TurtleParser(
        '''<http://example.com/foo> <http://example.com/bar> "Emoji: \\U0001F600" .''',
      );
      final triples = parser.parse();

      expect(triples.length, equals(1));
      expect(triples[0].subject, equals(IriTerm('http://example.com/foo')));
      expect(triples[0].predicate, equals(IriTerm('http://example.com/bar')));
      expect(triples[0].object, equals(LiteralTerm.string('Emoji: 😀')));
    });

    test(
      'should throw RdfSyntaxException for invalid syntax - missing object',
      () {
        final parser = TurtleParser(
          '<http://example.com/foo> <http://example.com/bar> .',
        );
        expect(() => parser.parse(), throwsA(isA<RdfSyntaxException>()));
      },
    );

    test('should parse a complex example with different triple patterns', () {
      final parser = TurtleParser('''
        @prefix foaf: <http://xmlns.com/foaf/0.1/> .
        @prefix schema: <http://schema.org/> .
        @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
        
        <http://example.org/person/john>
          a foaf:Person ;
          foaf:name "John Smith" ;
          foaf:age "42"^^xsd:integer ;
          foaf:knows [
            a foaf:Person ;
            foaf:name "Jane Doe" ;
            schema:birthDate "1980-01-01"^^xsd:date
          ] ;
          schema:address [
            a schema:PostalAddress ;
            schema:streetAddress "123 Main St" ;
            schema:addressLocality "Anytown" ;
            schema:addressRegion "State" ;
            schema:postalCode "12345"
          ] .
      ''');

      final triples = parser.parse();

      // The result should have triples for:
      // - Main person type
      // - Main person name
      // - Main person age
      // - Main person knows relationship
      // - Known person type
      // - Known person name
      // - Known person birth date
      // - Main person address relationship
      // - Address type
      // - Address street
      // - Address locality
      // - Address region
      // - Address postal code
      expect(triples.length, equals(13));

      // Verify the main person triples
      final johnIri = IriTerm('http://example.org/person/john');
      final johnTriples = triples.where((t) => t.subject == johnIri).toList();
      expect(johnTriples.length, equals(5));

      // Check specific properties
      expect(
        johnTriples.any(
          (t) =>
              t.predicate ==
                  IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type') &&
              t.object == IriTerm('http://xmlns.com/foaf/0.1/Person'),
        ),
        isTrue,
      );

      expect(
        johnTriples.any(
          (t) =>
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/name') &&
              t.object == LiteralTerm.string('John Smith'),
        ),
        isTrue,
      );

      expect(
        johnTriples.any(
          (t) =>
              t.predicate == IriTerm('http://xmlns.com/foaf/0.1/knows') &&
              (t.object is BlankNodeTerm),
        ),
        isTrue,
      );
      expect(
        johnTriples.any(
          (t) =>
              t.predicate == IriTerm('http://schema.org/address') &&
              (t.object is BlankNodeTerm),
        ),
        isTrue,
      );
    });

    test('should handle comments gracefully', () {
      final parser = TurtleParser('''
        # This is a comment at the beginning
        <http://example.com/foo> # Comment after subject
          <http://example.com/bar> # Comment after predicate
          "baz" . # Comment after object
        # Comment at the end
      ''');

      final triples = parser.parse();
      expect(triples.length, equals(1));
      expect(triples[0].subject, equals(IriTerm('http://example.com/foo')));
      expect(triples[0].predicate, equals(IriTerm('http://example.com/bar')));
      expect(triples[0].object, equals(LiteralTerm.string('baz')));
    });

    test('should handle trailing semicolons correctly', () {
      final parser = TurtleParser('''
        @prefix ex: <http://example.com/> .
        ex:subject 
          ex:predicate1 "object1" ;
          ex:predicate2 "object2" ;
          .
      ''');

      final triples = parser.parse();
      expect(triples.length, equals(2));
    });

    test('should parse empty input', () {
      final parser = TurtleParser('');
      final triples = parser.parse();
      expect(triples, isEmpty);
    });

    test('should parse a simple triple', () {
      final parser = TurtleParser(
        '<http://example.org/subject> <http://example.org/predicate> <http://example.org/object> .',
      );
      final triples = parser.parse();

      expect(triples.length, equals(1));
      expect(
        (triples[0].subject as IriTerm).iri,
        equals('http://example.org/subject'),
      );
      expect(
        (triples[0].predicate as IriTerm).iri,
        equals('http://example.org/predicate'),
      );
      expect(
        (triples[0].object as IriTerm).iri,
        equals('http://example.org/object'),
      );
    });

    test('should resolve relative IRIs against base URI from constructor', () {
      final parser = TurtleParser(
        '<subject> <predicate> <object> .',
        baseUri: 'http://example.org/',
      );
      final triples = parser.parse();

      expect(triples.length, equals(1));
      expect(
        (triples[0].subject as IriTerm).iri,
        equals('http://example.org/subject'),
      );
      expect(
        (triples[0].predicate as IriTerm).iri,
        equals('http://example.org/predicate'),
      );
      expect(
        (triples[0].object as IriTerm).iri,
        equals('http://example.org/object'),
      );
    });

    test('should resolve relative IRIs against @base directive', () {
      final parser = TurtleParser('''
        @base <http://example.org/> .
        <subject> <predicate> <object> .
      ''');
      final triples = parser.parse();

      expect(triples.length, equals(1));
      expect(
        (triples[0].subject as IriTerm).iri,
        equals('http://example.org/subject'),
      );
      expect(
        (triples[0].predicate as IriTerm).iri,
        equals('http://example.org/predicate'),
      );
      expect(
        (triples[0].object as IriTerm).iri,
        equals('http://example.org/object'),
      );
    });

    test('should override base URI from constructor with @base directive', () {
      final parser = TurtleParser('''
        @base <http://example.com/> .
        <subject> <predicate> <object> .
        ''', baseUri: 'http://example.org/');
      final triples = parser.parse();

      expect(triples.length, equals(1));
      expect(
        (triples[0].subject as IriTerm).iri,
        equals('http://example.com/subject'),
      );
      expect(
        (triples[0].predicate as IriTerm).iri,
        equals('http://example.com/predicate'),
      );
      expect(
        (triples[0].object as IriTerm).iri,
        equals('http://example.com/object'),
      );
    });

    test('should allow multiple @base directives with progressive effect', () {
      final parser = TurtleParser('''
        @base <http://example.org/> .
        <subject1> <predicate1> <object1> .
        
        @base <http://example.com/> .
        <subject2> <predicate2> <object2> .
      ''');
      final triples = parser.parse();

      expect(triples.length, equals(2));
      expect(
        (triples[0].subject as IriTerm).iri,
        equals('http://example.org/subject1'),
      );
      expect(
        (triples[0].predicate as IriTerm).iri,
        equals('http://example.org/predicate1'),
      );
      expect(
        (triples[0].object as IriTerm).iri,
        equals('http://example.org/object1'),
      );

      expect(
        (triples[1].subject as IriTerm).iri,
        equals('http://example.com/subject2'),
      );
      expect(
        (triples[1].predicate as IriTerm).iri,
        equals('http://example.com/predicate2'),
      );
      expect(
        (triples[1].object as IriTerm).iri,
        equals('http://example.com/object2'),
      );
    });

    test('should resolve relative IRIs in prefixed names against base URI', () {
      final parser = TurtleParser('''
        @base <http://example.org/base/> .
        @prefix ex: <relative/> .
        
        <subject> a ex:Type .
      ''');
      final triples = parser.parse();

      expect(triples.length, equals(1));
      expect(
        (triples[0].subject as IriTerm).iri,
        equals('http://example.org/base/subject'),
      );
      expect(
        (triples[0].predicate as IriTerm).iri,
        equals('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
      );
      expect(
        (triples[0].object as IriTerm).iri,
        equals('http://example.org/base/relative/Type'),
      );
    });

    test('should resolve path-absolute IRIs against base URI', () {
      final parser = TurtleParser('''
        @base <http://example.org/base/path/> .
        </absolute> </predicate> </object> .
      ''');
      final triples = parser.parse();

      expect(triples.length, equals(1));
      expect(
        (triples[0].subject as IriTerm).iri,
        equals('http://example.org/absolute'),
      );
      expect(
        (triples[0].predicate as IriTerm).iri,
        equals('http://example.org/predicate'),
      );
      expect(
        (triples[0].object as IriTerm).iri,
        equals('http://example.org/object'),
      );
    });

    test('should parse a full turtle document with prefixes and base', () {
      final parser = TurtleParser('''
        @base <http://example.org/> .
        @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
        @prefix foaf: <http://xmlns.com/foaf/0.1/> .
        @prefix : <local/> .
        
        <person/alice> a foaf:Person ;
          foaf:name "Alice" ;
          foaf:knows <person/bob> , :charlie .
          
        <person/bob> a foaf:Person ;
          foaf:name "Bob" .
          
        :charlie a foaf:Person ;
          foaf:name "Charlie" .
      ''');

      final triples = parser.parse();

      expect(triples.length, equals(8));

      // Verify alice triples
      final aliceTriples =
          triples
              .where(
                (t) =>
                    t.subject is IriTerm &&
                    (t.subject as IriTerm).iri ==
                        'http://example.org/person/alice',
              )
              .toList();

      expect(aliceTriples.length, equals(4));

      // Check type triple
      expect(
        aliceTriples.any(
          (t) =>
              t.predicate is IriTerm &&
              (t.predicate as IriTerm).iri ==
                  'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' &&
              t.object is IriTerm &&
              (t.object as IriTerm).iri == 'http://xmlns.com/foaf/0.1/Person',
        ),
        isTrue,
      );

      // Check name triple
      expect(
        aliceTriples.any(
          (t) =>
              t.predicate is IriTerm &&
              (t.predicate as IriTerm).iri ==
                  'http://xmlns.com/foaf/0.1/name' &&
              t.object is LiteralTerm &&
              (t.object as LiteralTerm).value == 'Alice',
        ),
        isTrue,
      );

      // Check knows bob triple
      expect(
        aliceTriples.any(
          (t) =>
              t.predicate is IriTerm &&
              (t.predicate as IriTerm).iri ==
                  'http://xmlns.com/foaf/0.1/knows' &&
              t.object is IriTerm &&
              (t.object as IriTerm).iri == 'http://example.org/person/bob',
        ),
        isTrue,
      );

      // Check knows charlie triple
      expect(
        aliceTriples.any(
          (t) =>
              t.predicate is IriTerm &&
              (t.predicate as IriTerm).iri ==
                  'http://xmlns.com/foaf/0.1/knows' &&
              t.object is IriTerm &&
              (t.object as IriTerm).iri == 'http://example.org/local/charlie',
        ),
        isTrue,
      );

      // Verify bob triples
      final bobTriples =
          triples
              .where(
                (t) =>
                    t.subject is IriTerm &&
                    (t.subject as IriTerm).iri ==
                        'http://example.org/person/bob',
              )
              .toList();

      expect(bobTriples.length, equals(2));

      // Check bob's type
      expect(
        bobTriples.any(
          (t) =>
              t.predicate is IriTerm &&
              (t.predicate as IriTerm).iri ==
                  'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' &&
              t.object is IriTerm &&
              (t.object as IriTerm).iri == 'http://xmlns.com/foaf/0.1/Person',
        ),
        isTrue,
      );

      // Check bob's name
      expect(
        bobTriples.any(
          (t) =>
              t.predicate is IriTerm &&
              (t.predicate as IriTerm).iri ==
                  'http://xmlns.com/foaf/0.1/name' &&
              t.object is LiteralTerm &&
              (t.object as LiteralTerm).value == 'Bob',
        ),
        isTrue,
      );

      // Verify charlie triples
      final charlieTriples =
          triples
              .where(
                (t) =>
                    t.subject is IriTerm &&
                    (t.subject as IriTerm).iri ==
                        'http://example.org/local/charlie',
              )
              .toList();

      expect(charlieTriples.length, equals(2));

      // Check charlie's type
      expect(
        charlieTriples.any(
          (t) =>
              t.predicate is IriTerm &&
              (t.predicate as IriTerm).iri ==
                  'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' &&
              t.object is IriTerm &&
              (t.object as IriTerm).iri == 'http://xmlns.com/foaf/0.1/Person',
        ),
        isTrue,
      );

      // Check charlie's name
      expect(
        charlieTriples.any(
          (t) =>
              t.predicate is IriTerm &&
              (t.predicate as IriTerm).iri ==
                  'http://xmlns.com/foaf/0.1/name' &&
              t.object is LiteralTerm &&
              (t.object as LiteralTerm).value == 'Charlie',
        ),
        isTrue,
      );
    });

    test(
      'should throw RdfSyntaxException for invalid syntax - missing period',
      () {
        final parser = TurtleParser(
          '<http://example.com/foo> <http://example.com/bar> "baz"',
        );
        try {
          parser.parse();
          fail('Expected RdfSyntaxException was not thrown');
        } catch (e) {
          expect(e, isA<RdfSyntaxException>());
        }
      },
    );
  });
}
