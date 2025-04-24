import 'package:rdf_core/graph/rdf_graph.dart';
import 'package:rdf_core/plugin/format_plugin.dart';
import 'package:rdf_core/rdf_parser.dart';
import 'package:rdf_core/rdf_serializer.dart';
import 'package:test/test.dart';

void main() {
  final registry = RdfFormatRegistry();

  setUp(() {
    // Clear the registry before each test
    registry.clear();
  });

  group('RdfFormatRegistry', () {
    test('registerFormat adds format to registry', () {
      final mockFormat = _MockFormat();
      registry.registerFormat(mockFormat);

      final retrievedFormat = registry.getFormat('application/test');
      expect(retrievedFormat, equals(mockFormat));
    });

    test('getFormat returns null for unregistered MIME type', () {
      final retrievedFormat = registry.getFormat('application/not-registered');
      expect(retrievedFormat, isNull);
    });

    test('getFormat handles case insensitivity', () {
      final mockFormat = _MockFormat();
      registry.registerFormat(mockFormat);

      final retrievedFormat = registry.getFormat('APPLICATION/TEST');
      expect(retrievedFormat, equals(mockFormat));
    });

    test('getAllFormats returns all registered formats', () {
      final mockFormat1 = _MockFormat();
      final mockFormat2 = _MockFormat2();

      registry.registerFormat(mockFormat1);
      registry.registerFormat(mockFormat2);

      final formats = registry.getAllFormats();
      expect(formats.length, equals(2));
      expect(formats, contains(mockFormat1));
      expect(formats, contains(mockFormat2));
    });

    test('detectFormat calls canParse on each format', () {
      final alwaysFalseFormat = _MockFormat();
      final alwaysTrueFormat = _MockFormat2();

      registry.registerFormat(alwaysFalseFormat);
      registry.registerFormat(alwaysTrueFormat);

      final detectedFormat = registry.detectFormat('dummy content');
      expect(detectedFormat, equals(alwaysTrueFormat));
    });

    test('detectFormat returns null when no format matches', () {
      final alwaysFalseFormat = _MockFormat();
      registry.registerFormat(alwaysFalseFormat);

      final detectedFormat = registry.detectFormat('dummy content');
      expect(detectedFormat, isNull);
    });

    test('getParser returns detecting parser when format not found', () {
      // Don't register any formats

      final parser = registry.getParser('application/not-registered');
      expect(parser, isA<FormatDetectingParser>());
    });

    test('getSerializer throws when format not found', () {
      // Don't register any formats

      expect(
        () => registry.getSerializer('application/not-registered'),
        throwsA(isA<FormatNotSupportedException>()),
      );
    });

    test(
      'getSerializer throws when no formats registered and none specified',
      () {
        // Don't register any formats

        expect(
          () => registry.getSerializer(null),
          throwsA(isA<FormatNotSupportedException>()),
        );
      },
    );
  });

  group('FormatDetectingParser', () {
    test('tries each format in sequence', () {
      final mockFormat1 = _MockFormat();
      final mockFormat2 = _MockFormat2();

      registry.registerFormat(mockFormat1);
      registry.registerFormat(mockFormat2);

      final parser = FormatDetectingParser(registry);
      final result = parser.parse('dummy content');

      // Should use the second format since the first returns null
      expect(result, isA<RdfGraph>());
    });

    test('throws exception when no formats registered', () {
      // Don't register any formats
      final parser = FormatDetectingParser(registry);

      expect(
        () => parser.parse('dummy content'),
        throwsA(isA<FormatNotSupportedException>()),
      );
    });
  });
}

// Mock implementations for testing

class _MockFormat implements RdfFormat {
  @override
  bool canParse(String content) => false;

  @override
  RdfParser createParser() => _MockParser();

  @override
  RdfSerializer createSerializer() => _MockSerializer();

  @override
  String get primaryMimeType => 'application/test';

  @override
  Set<String> get supportedMimeTypes => {'application/test'};
}

class _MockFormat2 implements RdfFormat {
  @override
  bool canParse(String content) => true;

  @override
  RdfParser createParser() => _MockParser();

  @override
  RdfSerializer createSerializer() => _MockSerializer();

  @override
  String get primaryMimeType => 'application/test2';

  @override
  Set<String> get supportedMimeTypes => {'application/test2'};
}

class _MockParser implements RdfParser {
  @override
  RdfGraph parse(String input, {String? documentUrl}) {
    // Just return an empty graph
    return RdfGraph();
  }
}

class _MockSerializer implements RdfSerializer {
  @override
  String write(
    RdfGraph graph, {
    String? baseUri,
    Map<String, String> customPrefixes = const {},
  }) {
    return 'mock serialized content';
  }
}
