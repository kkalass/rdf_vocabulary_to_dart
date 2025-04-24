import 'package:rdf_core/constants/xsd_constants.dart';
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:test/test.dart';

void main() {
  group('XsdConstants', () {
    test('namespace uses correct XSD namespace URI', () {
      expect(
        XsdConstants.namespace,
        equals('http://www.w3.org/2001/XMLSchema#'),
      );
    });

    test('stringIri has correct value', () {
      expect(
        XsdConstants.stringIri,
        equals(const IriTerm('http://www.w3.org/2001/XMLSchema#string')),
      );
    });

    test('booleanIri has correct value', () {
      expect(
        XsdConstants.booleanIri,
        equals(const IriTerm('http://www.w3.org/2001/XMLSchema#boolean')),
      );
    });

    test('integerIri has correct value', () {
      expect(
        XsdConstants.integerIri,
        equals(const IriTerm('http://www.w3.org/2001/XMLSchema#integer')),
      );
    });

    test('decimalIri has correct value', () {
      expect(
        XsdConstants.decimalIri,
        equals(const IriTerm('http://www.w3.org/2001/XMLSchema#decimal')),
      );
    });

    test('dateTimeIri has correct value', () {
      expect(
        XsdConstants.dateTimeIri,
        equals(const IriTerm('http://www.w3.org/2001/XMLSchema#dateTime')),
      );
    });

    test('makeIri creates correct IRI from local name', () {
      expect(
        XsdConstants.makeIri('double'),
        equals(const IriTerm('http://www.w3.org/2001/XMLSchema#double')),
      );

      expect(
        XsdConstants.makeIri('float'),
        equals(const IriTerm('http://www.w3.org/2001/XMLSchema#float')),
      );

      // Verify custom types work too
      expect(
        XsdConstants.makeIri('customType'),
        equals(const IriTerm('http://www.w3.org/2001/XMLSchema#customType')),
      );
    });

    test('predefined constants equal their makeIri equivalents', () {
      expect(XsdConstants.stringIri, equals(XsdConstants.makeIri('string')));
      expect(XsdConstants.integerIri, equals(XsdConstants.makeIri('integer')));
      expect(XsdConstants.booleanIri, equals(XsdConstants.makeIri('boolean')));
    });
  });
}
