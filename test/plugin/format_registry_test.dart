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

    test('tries each format when detection fails', () {
      // Both formats return false for canParse, but one parser should work
      final undetectableFormat1 = _UndetectableButParsableFormat();
      final undetectableFormat2 = _UndetectableAndFailingFormat();

      registry.registerFormat(undetectableFormat1);
      registry.registerFormat(undetectableFormat2);

      final parser = FormatDetectingParser(registry);
      final result = parser.parse('dummy content');

      // Should use the first format since detection fails but parsing works
      expect(result, isA<RdfGraph>());
    });

    test('throws exception when all formats fail to parse', () {
      // Register formats that all fail to parse
      final failingFormat1 = _UndetectableAndFailingFormat();
      final failingFormat2 = _AnotherFailingFormat();

      registry.registerFormat(failingFormat1);
      registry.registerFormat(failingFormat2);

      final parser = FormatDetectingParser(registry);

      expect(
        () => parser.parse('dummy content'),
        throwsA(
          isA<FormatNotSupportedException>().having(
            (e) => e.toString(),
            'message contains last error',
            contains('Mock parsing error 2'),
          ),
        ),
      );
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

class _UndetectableButParsableFormat implements RdfFormat {
  @override
  bool canParse(String content) => false;

  @override
  RdfParser createParser() => _MockParser();

  @override
  RdfSerializer createSerializer() => _MockSerializer();

  @override
  String get primaryMimeType => 'application/undetectable';

  @override
  Set<String> get supportedMimeTypes => {'application/undetectable'};
}

class _UndetectableAndFailingFormat implements RdfFormat {
  @override
  bool canParse(String content) => false;

  @override
  RdfParser createParser() => _FailingParser('Mock parsing error 1');

  @override
  RdfSerializer createSerializer() => _MockSerializer();

  @override
  String get primaryMimeType => 'application/failing';

  @override
  Set<String> get supportedMimeTypes => {'application/failing'};
}

class _AnotherFailingFormat implements RdfFormat {
  @override
  bool canParse(String content) => false;

  @override
  RdfParser createParser() => _FailingParser('Mock parsing error 2');

  @override
  RdfSerializer createSerializer() => _MockSerializer();

  @override
  String get primaryMimeType => 'application/failing2';

  @override
  Set<String> get supportedMimeTypes => {'application/failing2'};
}

class _MockParser implements RdfParser {
  @override
  RdfGraph parse(String input, {String? documentUrl}) {
    // Just return an empty graph
    return RdfGraph();
  }
}

class _FailingParser implements RdfParser {
  final String errorMessage;

  _FailingParser(this.errorMessage);

  @override
  RdfGraph parse(String input, {String? documentUrl}) {
    throw FormatException(errorMessage);
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
