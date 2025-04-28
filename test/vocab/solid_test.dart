// Tests for the Solid Terms vocabulary
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/vocab/vocab.dart';
import 'package:test/test.dart';

void main() {
  group('Solid', () {
    test('namespace uses correct Solid namespace URI', () {
      expect(Solid.namespace, equals('http://www.w3.org/ns/solid/terms#'));
    });

    test('prefix has correct value', () {
      expect(Solid.prefix, equals('solid'));
    });

    group('SolidClasses', () {
      test('typeRegistration has correct value', () {
        expect(
          SolidClasses.typeRegistration,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#TypeRegistration')),
        );
      });

      test('typeIndex has correct value', () {
        expect(
          SolidClasses.typeIndex,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#TypeIndex')),
        );
      });

      test('insertDeletePatch has correct value', () {
        expect(
          SolidClasses.insertDeletePatch,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#InsertDeletePatch')),
        );
      });

      test('notification has correct value', () {
        expect(
          SolidClasses.notification,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#Notification')),
        );
      });

      test('workspace has correct value', () {
        expect(
          SolidClasses.workspace,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#Workspace')),
        );
      });
    });

    group('SolidPredicates', () {
      test('oidcIssuer has correct value', () {
        expect(
          SolidPredicates.oidcIssuer,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#oidcIssuer')),
        );
      });

      test('publicTypeIndex has correct value', () {
        expect(
          SolidPredicates.publicTypeIndex,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#publicTypeIndex')),
        );
      });

      test('privateTypeIndex has correct value', () {
        expect(
          SolidPredicates.privateTypeIndex,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#privateTypeIndex')),
        );
      });

      test('forClass has correct value', () {
        expect(
          SolidPredicates.forClass,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#forClass')),
        );
      });

      test('instance has correct value', () {
        expect(
          SolidPredicates.instance,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#instance')),
        );
      });

      test('instanceContainer has correct value', () {
        expect(
          SolidPredicates.instanceContainer,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#instanceContainer')),
        );
      });

      test('read has correct value', () {
        expect(
          SolidPredicates.read,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#read')),
        );
      });

      test('write has correct value', () {
        expect(
          SolidPredicates.write,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#write')),
        );
      });

      test('storageType has correct value', () {
        expect(
          SolidPredicates.storageType,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#storageType')),
        );
      });

      test('deletes has correct value', () {
        expect(
          SolidPredicates.deletes,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#deletes')),
        );
      });

      test('inserts has correct value', () {
        expect(
          SolidPredicates.inserts,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#inserts')),
        );
      });

      test('timeline has correct value', () {
        expect(
          SolidPredicates.timeline,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#timeline')),
        );
      });

      test('notification has correct value', () {
        expect(
          SolidPredicates.notification,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#notification')),
        );
      });

      test('source has correct value', () {
        expect(
          SolidPredicates.source,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#source')),
        );
      });

      test('workspace has correct value', () {
        expect(
          SolidPredicates.workspace,
          equals(IriTerm('http://www.w3.org/ns/solid/terms#workspace')),
        );
      });
    });
  });
}
