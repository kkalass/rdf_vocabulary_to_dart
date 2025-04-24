import 'package:test/test.dart';
import 'package:rdf_core/constants/xsd_constants.dart';
import 'package:rdf_core/graph/rdf_graph.dart';
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/graph/triple.dart';
import 'package:rdf_core/turtle/turtle_serializer.dart';

void main() {
  late TurtleSerializer serializer;

  setUp(() {
    serializer = TurtleSerializer();
  });

  group('TurtleSerializer', () {
    test('should serialize empty graph', () {
      // Arrange
      final graph = RdfGraph();

      // Act
      final result = serializer.write(graph);

      // Assert
      expect(result, isEmpty);
    });

    test('should serialize graph with prefixes', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm("http://example.org/test"),
            IriTerm("http://my-ontology.org/test#deleted"),
            LiteralTerm("true", datatype: XsdConstants.booleanIri),
          ),
        ],
      );
      final prefixes = {'ex': 'http://example.org/'};

      // Act
      final result = serializer.write(graph, customPrefixes: prefixes);

      // Assert
      expect(
        result,
        contains('@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .'),
      );
      expect(result, contains('@prefix ex: <http://example.org/> .'));
    });

    test('should serialize a simple triple', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/alice'),
            IriTerm('http://example.org/knows'),
            IriTerm('http://example.org/bob'),
          ),
        ],
      );

      // Act
      final result = serializer.write(graph);

      // Assert
      expect(
        result,
        contains(
          '<http://example.org/alice> <http://example.org/knows> <http://example.org/bob> .',
        ),
      );
    });

    test('should use rdf:type abbreviation', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/alice'),
            IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
            IriTerm('http://example.org/Person'),
          ),
        ],
      );

      // Act
      final result = serializer.write(graph);

      // Assert
      expect(
        result,
        contains('<http://example.org/alice> a <http://example.org/Person> .'),
      );
      expect(
        result,
        isNot(contains('<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>')),
      );
    });

    test('should group triples by subject', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/alice'),
            IriTerm('http://example.org/name'),
            LiteralTerm.string('Alice'),
          ),
          Triple(
            IriTerm('http://example.org/alice'),
            IriTerm('http://example.org/age'),
            LiteralTerm(
              "30",
              datatype: IriTerm('http://www.w3.org/2001/XMLSchema#integer'),
            ),
          ),
          Triple(
            IriTerm('http://example.org/bob'),
            IriTerm('http://example.org/name'),
            LiteralTerm.string('Bob'),
          ),
        ],
      );

      // Act
      final result = serializer.write(graph);

      // Assert
      expect(
        result,
        contains(
          '<http://example.org/alice> <http://example.org/name> "Alice"',
        ),
      );
      expect(
        result,
        contains(
          '<http://example.org/alice> <http://example.org/name> "Alice";\n    <http://example.org/age> "30"^^xsd:integer',
        ),
      );
      expect(
        result,
        contains('<http://example.org/bob> <http://example.org/name> "Bob" .'),
      );

      // Überprüfe die strukturellen Eigenschaften der Ausgabe statt fester Zeilenanzahlen
      final lines = result.split('\n');
      expect(lines.any((line) => line.contains('@prefix xsd:')), isTrue);
      expect(lines.any((line) => line.isEmpty), isTrue);
      expect(
        lines.any((line) => line.contains('<http://example.org/alice>')),
        isTrue,
      );
      expect(
        lines.any((line) => line.contains('<http://example.org/bob>')),
        isTrue,
      );
      expect(
        lines.any((line) => line.contains('<http://example.org/age>')),
        isTrue,
      );
    });

    test('should group multiple objects for the same predicate', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/alice'),
            IriTerm('http://example.org/likes'),
            IriTerm('http://example.org/chocolate'),
          ),
          Triple(
            IriTerm('http://example.org/alice'),
            IriTerm('http://example.org/likes'),
            IriTerm('http://example.org/pizza'),
          ),
        ],
      );

      // Act
      final result = serializer.write(graph);

      // Assert
      expect(
        result,
        contains(
          '<http://example.org/alice> <http://example.org/likes> <http://example.org/chocolate>, <http://example.org/pizza> .',
        ),
      );
    });

    test('should handle blank nodes', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/statement'),
            IriTerm('http://example.org/source'),
            BlankNodeTerm('b1'),
          ),
        ],
      );

      // Act
      final result = serializer.write(graph);

      // Assert
      expect(
        result,
        contains(
          '<http://example.org/statement> <http://example.org/source> _:b1 .',
        ),
      );
    });

    test('should handle literals with language tags', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/book'),
            IriTerm('http://example.org/title'),
            LiteralTerm.withLanguage('Le Petit Prince', 'fr'),
          ),
        ],
      );

      // Act
      final result = serializer.write(graph);

      // Assert
      expect(
        result,
        contains(
          '<http://example.org/book> <http://example.org/title> "Le Petit Prince"@fr .',
        ),
      );
    });

    test('should handle literals with quotes and backslashes', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/book'),
            IriTerm('http://example.org/title'),
            LiteralTerm.string(
              'Le "Petit" \\ Prince\n hopes for a better world\r',
            ),
          ),
        ],
      );

      // Act
      final result = serializer.write(graph);

      // Assert
      expect(
        result,
        contains(
          '<http://example.org/book> <http://example.org/title> "Le \\"Petit\\" \\\\ Prince\\n hopes for a better world\\r" .',
        ),
      );
    });

    test(
      'should handle complex graphs with multiple subjects and predicates and make use of prefixes',
      () {
        // Arrange
        final graph = RdfGraph(
          triples: [
            // Person 1
            Triple(
              IriTerm('http://example.org/alice'),
              IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
              IriTerm('http://xmlns.com/foaf/0.1/Person'),
            ),
            Triple(
              IriTerm('http://example.org/alice'),
              IriTerm('http://xmlns.com/foaf/0.1/name'),
              LiteralTerm.string('Alice'),
            ),
            Triple(
              IriTerm('http://example.org/alice'),
              IriTerm('http://xmlns.com/foaf/0.1/knows'),
              IriTerm('http://example.org/bob'),
            ),
            // Person 2
            Triple(
              IriTerm('http://example.org/bob'),
              IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
              IriTerm('http://xmlns.com/foaf/0.1/Person'),
            ),
            Triple(
              IriTerm('http://example.org/bob'),
              IriTerm('http://xmlns.com/foaf/0.1/name'),
              LiteralTerm.string('Bob'),
            ),
          ],
        );

        final prefixes = {'ex': 'http://example.org/'};

        // Act
        final result = serializer.write(graph, customPrefixes: prefixes);

        // Assert
        expect(result, contains('@prefix ex: <http://example.org/> .'));
        expect(
          result,
          contains('@prefix foaf: <http://xmlns.com/foaf/0.1/> .'),
        );
        expect(result, contains('ex:alice a foaf:Person'));
        expect(result, contains('foaf:name "Alice"'));
        expect(result, contains('    foaf:knows ex:bob'));
        expect(result, contains('ex:bob a foaf:Person'));
        expect(result, contains('    foaf:name "Bob"'));
      },
    );

    test('should handle Unicode characters in literals', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/entity'),
            IriTerm('http://example.org/label'),
            LiteralTerm.string('Unicode: € ♥ © ≈ ♠ ⚓ 😀'),
          ),
        ],
      );

      // Act
      final result = serializer.write(graph);

      // Assert
      // Check for standard Unicode characters (below U+FFFF)
      expect(
        result,
        contains('Unicode: \\u20AC \\u2665 \\u00A9 \\u2248 \\u2660 \\u2693'),
      );

      // The emoji can be represented either as surrogate pair or as a single U+codepoint
      // In Dart, code units above U+FFFF are represented as UTF-16 surrogate pairs
      // Check for either representation (surrogate pairs or 8-digit escape)
      final containsEmoji =
          result.contains('\\uD83D\\uDE00') || result.contains('\\U0001F600');
      expect(
        containsEmoji,
        isTrue,
        reason:
            'Output should contain emoji 😀 in either surrogate pair or 8-digit format',
      );
    });

    test('should handle non-printable ASCII characters', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/entity'),
            IriTerm('http://example.org/value'),
            LiteralTerm.string('Control chars: \u0001 \u0007 \u001F'),
          ),
        ],
      );

      // Act
      final result = serializer.write(graph);

      // Assert
      // Use case-insensitive regex to match the escape sequences
      expect(
        result,
        matches(
          RegExp(
            r'Control chars: \\u0001 \\u0007 \\u001[fF]',
            caseSensitive: false,
          ),
        ),
      );
    });

    test('should handle empty prefixes properly', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/default#resource'),
            IriTerm('http://example.org/default#property'),
            LiteralTerm.string('value'),
          ),
        ],
      );

      final prefixes = {'': 'http://example.org/default#'};

      // Act
      final result = serializer.write(graph, customPrefixes: prefixes);

      // Assert
      expect(result, contains('@prefix : <http://example.org/default#> .'));
      expect(result, contains(':resource :property "value" .'));
    });

    test('should format multiple predicates and objects correctly', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/subject'),
            IriTerm('http://example.org/predicate1'),
            LiteralTerm.string('value1'),
          ),
          Triple(
            IriTerm('http://example.org/subject'),
            IriTerm('http://example.org/predicate1'),
            LiteralTerm.string('value2'),
          ),
          Triple(
            IriTerm('http://example.org/subject'),
            IriTerm('http://example.org/predicate2'),
            LiteralTerm.string('value3'),
          ),
          Triple(
            IriTerm('http://example.org/subject'),
            IriTerm('http://example.org/predicate2'),
            LiteralTerm.string('value4'),
          ),
        ],
      );

      // Act
      final result = serializer.write(graph);

      // Assert
      // Check for correct indentation and separators
      expect(
        result,
        contains(
          '<http://example.org/subject> <http://example.org/predicate1> "value1", "value2";\n    <http://example.org/predicate2> "value3", "value4" .',
        ),
      );
    });

    test('should handle both xsd:string and language-tagged literals', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/book'),
            IriTerm('http://example.org/title'),
            LiteralTerm.string('The Little Prince'),
          ),
          Triple(
            IriTerm('http://example.org/book'),
            IriTerm('http://example.org/title'),
            LiteralTerm.withLanguage('Le Petit Prince', 'fr'),
          ),
          Triple(
            IriTerm('http://example.org/book'),
            IriTerm('http://example.org/title'),
            LiteralTerm.withLanguage('Der kleine Prinz', 'de'),
          ),
        ],
      );

      // Act
      final result = serializer.write(graph);

      // Assert
      expect(
        result,
        contains(
          '<http://example.org/book> <http://example.org/title> "The Little Prince", "Le Petit Prince"@fr, "Der kleine Prinz"@de .',
        ),
      );
    });

    test('should correctly use custom prefixes when available', () {
      // Arrange
      final graph = RdfGraph(
        triples: [
          Triple(
            IriTerm('http://example.org/book/littleprince'),
            IriTerm('http://purl.org/dc/terms/title'),
            LiteralTerm.string('The Little Prince'),
          ),
        ],
      );

      final customPrefixes = {
        'book': 'http://example.org/book/',
        'dc': 'http://purl.org/dc/terms/',
      };

      // Act
      final result = serializer.write(graph, customPrefixes: customPrefixes);

      // Assert
      expect(result, contains('@prefix book: <http://example.org/book/> .'));
      expect(result, contains('@prefix dc: <http://purl.org/dc/terms/> .'));
      expect(
        result,
        contains('book:littleprince dc:title "The Little Prince" .'),
      );
    });

    test('should handle overlapping prefixes correctly', () {
      // Arrange
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

      // Act
      final result = serializer.write(graph, customPrefixes: customPrefixes);

      // Assert
      expect(result, contains('@prefix ex: <http://example.org/> .'));
      expect(
        result,
        contains('@prefix vocab: <http://example.org/vocabulary/> .'),
      );

      // Should use the more specific prefix for the predicate
      expect(result, contains('ex:subject vocab:predicate "object" .'));
      // Should NOT use the less specific prefix with the remaining part as local name
      expect(
        result,
        isNot(contains('ex:subject ex:vocabulary/predicate "object" .')),
      );
    });
  });
}
