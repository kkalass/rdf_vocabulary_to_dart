import 'package:rdf_core/src/plugin/format_plugin.dart';
import 'package:rdf_core/rdf_parser.dart';
import 'package:test/test.dart';

void main() {
  late RdfFormatRegistry registry;
  late RdfParserFactory factory;

  setUp(() {
    registry = RdfFormatRegistry();
    factory = RdfParserFactory(registry);
  });

  group('RdfParserFactory', () {
    test('returns a detecting parser for null content type', () {
      final parser = factory.createParser();
      expect(parser, isA<FormatDetectingParser>());
    });

    test('returns a detecting parser for unknown content type', () {
      final parser = factory.createParser(contentType: 'unknown/type');
      expect(parser, isA<FormatDetectingParser>());
    });

    // More tests here would normally check if turtle and JSON-LD parsers
    // are returned, but that would require registering mock formats
  });
}
