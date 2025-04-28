import 'package:rdf_core/jsonld/jsonld_format.dart';
import 'package:rdf_core/jsonld/jsonld_serializer.dart';
import 'package:test/test.dart';

void main() {
  group('JsonLdFormat', () {
    late JsonLdFormat format;

    setUp(() {
      format = const JsonLdFormat();
    });

    test('primaryMimeType returns application/ld+json', () {
      expect(format.primaryMimeType, equals('application/ld+json'));
    });

    test('supportedMimeTypes contains expected types', () {
      expect(
        format.supportedMimeTypes,
        containsAll(['application/ld+json', 'application/json+ld']),
      );
      expect(format.supportedMimeTypes.length, equals(2));
    });

    test('createParser returns a JsonLdParser adapter', () {
      final parser = format.createParser();
      expect(parser, isNotNull);
      // Can't check exact type since _JsonLdParserAdapter is private
      // but we can verify its behavior
      expect(parser.toString(), contains('JsonLd'));
    });

    test('createSerializer returns a JsonLdSerializer', () {
      final serializer = format.createSerializer();
      expect(serializer, isA<JsonLdSerializer>());
    });

    group('canParse', () {
      test('returns true for valid JSON-LD object with @context', () {
        final content = '''
          {
            "@context": "http://schema.org/",
            "@type": "Person",
            "name": "John Doe"
          }
        ''';
        expect(format.canParse(content), isTrue);
      });

      test('returns true for valid JSON-LD object with @id', () {
        final content = '''
          {
            "@id": "http://example.org/john",
            "http://xmlns.com/foaf/0.1/name": "John Doe"
          }
        ''';
        expect(format.canParse(content), isTrue);
      });

      test('returns true for valid JSON-LD object with @type', () {
        final content = '''
          {
            "@type": "http://schema.org/Person",
            "http://xmlns.com/foaf/0.1/name": "John Doe"
          }
        ''';
        expect(format.canParse(content), isTrue);
      });

      test('returns true for valid JSON-LD object with @graph', () {
        final content = '''
          {
            "@graph": [
              {
                "@id": "http://example.org/john",
                "http://xmlns.com/foaf/0.1/name": "John Doe"
              }
            ]
          }
        ''';
        expect(format.canParse(content), isTrue);
      });

      test('returns true for valid JSON-LD array', () {
        final content = '''
          [
            {
              "@id": "http://example.org/john",
              "http://xmlns.com/foaf/0.1/name": "John Doe"
            }
          ]
        ''';
        expect(format.canParse(content), isTrue);
      });

      test('returns false for non-JSON content', () {
        final content = 'This is just plain text';
        expect(format.canParse(content), isFalse);
      });

      test('returns false for JSON without JSON-LD keywords', () {
        final content = '''
          {
            "name": "John Doe",
            "email": "john@example.org"
          }
        ''';
        expect(format.canParse(content), isFalse);
      });

      test('handles whitespace in content correctly', () {
        final content = '''
          
          {
            "@context": "http://schema.org/",
            "@type": "Person"
          }
          
        ''';
        expect(format.canParse(content), isTrue);
      });
    });
  });
}
