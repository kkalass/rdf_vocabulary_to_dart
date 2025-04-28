// Tests for the Linked Data Platform (LDP) vocabulary
import 'package:rdf_core/src/graph/rdf_term.dart';
import 'package:rdf_core/src/vocab/ldp.dart';
import 'package:test/test.dart';

void main() {
  group('Ldp', () {
    test('namespace uses correct LDP namespace URI', () {
      expect(Ldp.namespace, equals('http://www.w3.org/ns/ldp#'));
    });

    test('prefix has correct value', () {
      expect(Ldp.prefix, equals('ldp'));
    });

    group('LdpClasses', () {
      test('resource has correct value', () {
        expect(
          LdpClasses.resource,
          equals(IriTerm('http://www.w3.org/ns/ldp#Resource')),
        );
      });

      test('rdfSource has correct value', () {
        expect(
          LdpClasses.rdfSource,
          equals(IriTerm('http://www.w3.org/ns/ldp#RDFSource')),
        );
      });

      test('nonRDFSource has correct value', () {
        expect(
          LdpClasses.nonRDFSource,
          equals(IriTerm('http://www.w3.org/ns/ldp#NonRDFSource')),
        );
      });

      test('container has correct value', () {
        expect(
          LdpClasses.container,
          equals(IriTerm('http://www.w3.org/ns/ldp#Container')),
        );
      });

      test('basicContainer has correct value', () {
        expect(
          LdpClasses.basicContainer,
          equals(IriTerm('http://www.w3.org/ns/ldp#BasicContainer')),
        );
      });

      test('directContainer has correct value', () {
        expect(
          LdpClasses.directContainer,
          equals(IriTerm('http://www.w3.org/ns/ldp#DirectContainer')),
        );
      });

      test('indirectContainer has correct value', () {
        expect(
          LdpClasses.indirectContainer,
          equals(IriTerm('http://www.w3.org/ns/ldp#IndirectContainer')),
        );
      });
    });

    group('LdpPredicates', () {
      test('contains has correct value', () {
        expect(
          LdpPredicates.contains,
          equals(IriTerm('http://www.w3.org/ns/ldp#contains')),
        );
      });

      test('member has correct value', () {
        expect(
          LdpPredicates.member,
          equals(IriTerm('http://www.w3.org/ns/ldp#member')),
        );
      });

      test('membershipResource has correct value', () {
        expect(
          LdpPredicates.membershipResource,
          equals(IriTerm('http://www.w3.org/ns/ldp#membershipResource')),
        );
      });

      test('hasMemberRelation has correct value', () {
        expect(
          LdpPredicates.hasMemberRelation,
          equals(IriTerm('http://www.w3.org/ns/ldp#hasMemberRelation')),
        );
      });

      test('isMemberOfRelation has correct value', () {
        expect(
          LdpPredicates.isMemberOfRelation,
          equals(IriTerm('http://www.w3.org/ns/ldp#isMemberOfRelation')),
        );
      });

      test('insertedContentRelation has correct value', () {
        expect(
          LdpPredicates.insertedContentRelation,
          equals(IriTerm('http://www.w3.org/ns/ldp#insertedContentRelation')),
        );
      });

      test('constrainedBy has correct value', () {
        expect(
          LdpPredicates.constrainedBy,
          equals(IriTerm('http://www.w3.org/ns/ldp#constrainedBy')),
        );
      });
    });

    group('LdpPreferences', () {
      test('preferContainment has correct value', () {
        expect(
          LdpPreferences.preferContainment,
          equals(IriTerm('http://www.w3.org/ns/ldp#PreferContainment')),
        );
      });

      test('preferMembership has correct value', () {
        expect(
          LdpPreferences.preferMembership,
          equals(IriTerm('http://www.w3.org/ns/ldp#PreferMembership')),
        );
      });

      test('preferMinimalContainer has correct value', () {
        expect(
          LdpPreferences.preferMinimalContainer,
          equals(IriTerm('http://www.w3.org/ns/ldp#PreferMinimalContainer')),
        );
      });
    });
  });
}
