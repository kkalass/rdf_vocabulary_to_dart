import 'package:rdf_core/rdf_core.dart';
import 'package:test/test.dart';

void main() {
  late RdfFormatRegistry registry;
  late RdfCore rdfLib;

  setUp(() {
    // Create a fresh registry for each test
    registry = RdfFormatRegistry();
    rdfLib = RdfCore.withStandardFormats();

    // Clear the registry to ensure tests are isolated
    registry.clear();
  });

  group('RdfCore', () {
    test('withStandardFormats registers standard formats', () {
      // The factory constructor should pre-register standard formats

      // Check that at least the standard formats are registered (Turtle, JSON-LD)
      final formats = rdfLib.registry.getAllFormats();
      expect(formats.length, greaterThanOrEqualTo(2));

      // Verify we can get a parser for Turtle
      final turtleParser = rdfLib.getParser(contentType: 'text/turtle');
      expect(turtleParser, isNotNull);

      // Verify we can get a parser for JSON-LD
      final jsonLdParser = rdfLib.getParser(contentType: 'application/ld+json');
      expect(jsonLdParser, isNotNull);
    });

    test('registerFormat adds custom format', () {
      final customFormat = _CustomRdfFormat();

      // Register our custom format
      rdfLib.registerFormat(customFormat);

      // Verify we can get a parser for our custom format
      final customParser = rdfLib.getParser(
        contentType: 'application/x-custom-rdf',
      );
      expect(customParser, isA<_CustomRdfParser>());

      // Verify we can get a serializer for our custom format
      final customSerializer = rdfLib.getSerializer(
        contentType: 'application/x-custom-rdf',
      );
      expect(customSerializer, isA<_CustomRdfSerializer>());
    });

    test('parse and serialize with custom format', () {
      final customFormat = _CustomRdfFormat();
      rdfLib.registerFormat(customFormat);

      // Custom format parsing should work
      final graph = rdfLib.parse(
        'custom content',
        contentType: 'application/x-custom-rdf',
      );
      expect(graph.size, equals(1));

      // Custom format serialization should work
      final serialized = rdfLib.serialize(
        graph,
        contentType: 'application/x-custom-rdf',
      );
      expect(serialized, equals('CUSTOM:1 triple(s)'));
    });

    test('auto-detection works with custom format', () {
      // Register our custom format that accepts any input
      rdfLib.registerFormat(_CustomRdfFormat());

      // Custom format should be detected
      final graph = rdfLib.parse('custom content');
      expect(graph.size, equals(1));
    });
  });
}

// Example of a custom format implementation

class _CustomRdfFormat implements RdfFormat {
  @override
  bool canParse(String content) => true; // Accept any content for testing

  @override
  RdfParser createParser() => _CustomRdfParser();

  @override
  RdfSerializer createSerializer() => _CustomRdfSerializer();

  @override
  String get primaryMimeType => 'application/x-custom-rdf';

  @override
  Set<String> get supportedMimeTypes => {
    'application/x-custom-rdf',
    'text/x-custom',
  };
}

class _CustomRdfParser implements RdfParser {
  @override
  RdfGraph parse(String input, {String? documentUrl}) {
    // For testing, always create a graph with one triple
    final subject = IriTerm('http://example.org/subject');
    final predicate = IriTerm('http://example.org/predicate');
    final object = LiteralTerm.string('Custom parsed content');

    return RdfGraph(triples: [Triple(subject, predicate, object)]);
  }
}

class _CustomRdfSerializer implements RdfSerializer {
  @override
  String write(
    RdfGraph graph, {
    String? baseUri,
    Map<String, String> customPrefixes = const {},
  }) {
    // For testing, just return a simple string with the triple count
    return 'CUSTOM:${graph.size} triple(s)';
  }
}
