import 'package:rdf_core/constants/rdf_constants.dart';
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:test/test.dart';

void main() {
  group('RdfConstants', () {
    test('namespace uses correct RDF namespace URI', () {
      expect(
        RdfConstants.namespace,
        equals('http://www.w3.org/1999/02/22-rdf-syntax-ns#'),
      );
    });

    test('typeIri has correct value', () {
      expect(
        RdfConstants.typeIri,
        equals(IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')),
      );
    });

    test('langStringIri has correct value', () {
      expect(
        RdfConstants.langStringIri,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#langString',
          ),
        ),
      );
    });

    test('propertyIri has correct value', () {
      expect(
        RdfConstants.propertyIri,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property',
          ),
        ),
      );
    });

    test('statementIri has correct value', () {
      expect(
        RdfConstants.statementIri,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement',
          ),
        ),
      );
    });

    test('constant IRIs are immutable', () {
      expect(() {
        // This should not compile, but we'll check it at runtime too
        // Dynamic cast is used to bypass compile-time check for demonstration
        final typeIri = RdfConstants.typeIri as dynamic;
        typeIri.iri = 'modified';
      }, throwsNoSuchMethodError);
    });
  });
}
