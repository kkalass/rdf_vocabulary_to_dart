import 'package:rdf_core/constants/dc_terms_constants.dart';
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:test/test.dart';

void main() {
  group('DcTermsConstants', () {
    test('namespace has correct Dublin Core Terms URI', () {
      expect(DcTermsConstants.namespace, equals('http://purl.org/dc/terms/'));
    });

    test('createdIri has correct value', () {
      expect(
        DcTermsConstants.createdIri,
        equals(const IriTerm('http://purl.org/dc/terms/created')),
      );
    });

    test('creatorIri has correct value', () {
      expect(
        DcTermsConstants.creatorIri,
        equals(const IriTerm('http://purl.org/dc/terms/creator')),
      );
    });

    test('modifiedIri has correct value', () {
      expect(
        DcTermsConstants.modifiedIri,
        equals(const IriTerm('http://purl.org/dc/terms/modified')),
      );
    });

    test('constant values remain immutable', () {
      // Test immutability at runtime
      expect(() {
        final iri = DcTermsConstants.createdIri as dynamic;
        iri.iri = 'modified';
      }, throwsNoSuchMethodError);
    });

    /*
    test('instance construction is prevented', () {
      // Test that the private constructor prevents instantiation
      expect(() {
        // ignore: invalid_use_of_protected_member
        DcTermsConstants._();
      }, throwsNoSuchMethodError);
    });
    */
  });
}
