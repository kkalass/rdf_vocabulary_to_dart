import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/vocab/dc_terms.dart';
import 'package:test/test.dart';

void main() {
  group('DcTerms', () {
    test('namespace has correct Dublin Core Terms URI', () {
      expect(DcTerms.namespace, equals('http://purl.org/dc/terms/'));
    });

    test('createdIri has correct value', () {
      expect(
        DcTermsPredicates.created,
        equals(IriTerm('http://purl.org/dc/terms/created')),
      );
    });

    test('creatorIri has correct value', () {
      expect(
        DcTermsPredicates.creator,
        equals(IriTerm('http://purl.org/dc/terms/creator')),
      );
    });

    test('modifiedIri has correct value', () {
      expect(
        DcTermsPredicates.modified,
        equals(IriTerm('http://purl.org/dc/terms/modified')),
      );
    });

    test('constant values remain immutable', () {
      // Test immutability at runtime
      expect(() {
        final iri = DcTermsPredicates.created as dynamic;
        iri.iri = 'modified';
      }, throwsNoSuchMethodError);
    });
  });
}
