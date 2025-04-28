// Tests for the Friend of a Friend (FOAF) vocabulary
import 'package:rdf_core/src/graph/rdf_term.dart';
import 'package:rdf_core/src/vocab/foaf.dart';

import 'package:test/test.dart';

void main() {
  group('Foaf', () {
    test('namespace uses correct FOAF namespace URI', () {
      expect(Foaf.namespace, equals('http://xmlns.com/foaf/0.1/'));
    });

    test('prefix has correct value', () {
      expect(Foaf.prefix, equals('foaf'));
    });

    group('FoafClasses', () {
      test('agent has correct value', () {
        expect(
          FoafClasses.agent,
          equals(IriTerm('http://xmlns.com/foaf/0.1/Agent')),
        );
      });

      test('person has correct value', () {
        expect(
          FoafClasses.person,
          equals(IriTerm('http://xmlns.com/foaf/0.1/Person')),
        );
      });

      test('organization has correct value', () {
        expect(
          FoafClasses.organization,
          equals(IriTerm('http://xmlns.com/foaf/0.1/Organization')),
        );
      });

      test('group has correct value', () {
        expect(
          FoafClasses.group,
          equals(IriTerm('http://xmlns.com/foaf/0.1/Group')),
        );
      });

      test('document has correct value', () {
        expect(
          FoafClasses.document,
          equals(IriTerm('http://xmlns.com/foaf/0.1/Document')),
        );
      });

      test('project has correct value', () {
        expect(
          FoafClasses.project,
          equals(IriTerm('http://xmlns.com/foaf/0.1/Project')),
        );
      });

      test('image has correct value', () {
        expect(
          FoafClasses.image,
          equals(IriTerm('http://xmlns.com/foaf/0.1/Image')),
        );
      });

      test('onlineAccount has correct value', () {
        expect(
          FoafClasses.onlineAccount,
          equals(IriTerm('http://xmlns.com/foaf/0.1/OnlineAccount')),
        );
      });
    });

    group('FoafPredicates', () {
      test('name has correct value', () {
        expect(
          FoafPredicates.name,
          equals(IriTerm('http://xmlns.com/foaf/0.1/name')),
        );
      });

      test('givenName has correct value', () {
        expect(
          FoafPredicates.givenName,
          equals(IriTerm('http://xmlns.com/foaf/0.1/givenName')),
        );
      });

      test('familyName has correct value', () {
        expect(
          FoafPredicates.familyName,
          equals(IriTerm('http://xmlns.com/foaf/0.1/familyName')),
        );
      });

      test('knows has correct value', () {
        expect(
          FoafPredicates.knows,
          equals(IriTerm('http://xmlns.com/foaf/0.1/knows')),
        );
      });

      test('mbox has correct value', () {
        expect(
          FoafPredicates.mbox,
          equals(IriTerm('http://xmlns.com/foaf/0.1/mbox')),
        );
      });

      test('mboxSha1sum has correct value', () {
        expect(
          FoafPredicates.mboxSha1sum,
          equals(IriTerm('http://xmlns.com/foaf/0.1/mbox_sha1sum')),
        );
      });

      // Test a selection of additional predicates to ensure coverage
      test('homepage has correct value', () {
        expect(
          FoafPredicates.homepage,
          equals(IriTerm('http://xmlns.com/foaf/0.1/homepage')),
        );
      });

      test('weblog has correct value', () {
        expect(
          FoafPredicates.weblog,
          equals(IriTerm('http://xmlns.com/foaf/0.1/weblog')),
        );
      });

      test('img has correct value', () {
        expect(
          FoafPredicates.img,
          equals(IriTerm('http://xmlns.com/foaf/0.1/img')),
        );
      });

      test('depiction has correct value', () {
        expect(
          FoafPredicates.depiction,
          equals(IriTerm('http://xmlns.com/foaf/0.1/depiction')),
        );
      });

      test('primaryTopic has correct value', () {
        expect(
          FoafPredicates.primaryTopic,
          equals(IriTerm('http://xmlns.com/foaf/0.1/primaryTopic')),
        );
      });

      test('isPrimaryTopicOf has correct value', () {
        expect(
          FoafPredicates.isPrimaryTopicOf,
          equals(IriTerm('http://xmlns.com/foaf/0.1/isPrimaryTopicOf')),
        );
      });
    });
  });
}
