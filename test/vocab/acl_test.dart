// Tests for the Web Access Control (ACL) vocabulary
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/vocab/vocab.dart';
import 'package:test/test.dart';

void main() {
  group('Acl', () {
    test('namespace uses correct ACL namespace URI', () {
      expect(
        Acl.namespace,
        equals('http://www.w3.org/ns/auth/acl#'),
      );
    });

    test('prefix has correct value', () {
      expect(Acl.prefix, equals('acl'));
    });

    group('AclClasses', () {
      test('authorization has correct value', () {
        expect(
          AclClasses.authorization,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#Authorization')),
        );
      });

      test('accessControl has correct value', () {
        expect(
          AclClasses.accessControl,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#accessControl')),
        );
      });
    });

    group('AclModes', () {
      test('read has correct value', () {
        expect(
          AclModes.read,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#Read')),
        );
      });

      test('write has correct value', () {
        expect(
          AclModes.write,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#Write')),
        );
      });

      test('control has correct value', () {
        expect(
          AclModes.control,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#Control')),
        );
      });

      test('append has correct value', () {
        expect(
          AclModes.append,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#Append')),
        );
      });
    });

    group('AclPredicates', () {
      test('accessTo has correct value', () {
        expect(
          AclPredicates.accessTo,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#accessTo')),
        );
      });

      test('accessToClass has correct value', () {
        expect(
          AclPredicates.accessToClass,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#accessToClass')),
        );
      });

      test('agent has correct value', () {
        expect(
          AclPredicates.agent,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#agent')),
        );
      });

      test('agentClass has correct value', () {
        expect(
          AclPredicates.agentClass,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#agentClass')),
        );
      });

      test('agentGroup has correct value', () {
        expect(
          AclPredicates.agentGroup,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#agentGroup')),
        );
      });

      test('mode has correct value', () {
        expect(
          AclPredicates.mode,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#mode')),
        );
      });

      test('default_ has correct value', () {
        expect(
          AclPredicates.default_,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#default')),
        );
      });

      test('defaultForNew has correct value', () {
        expect(
          AclPredicates.defaultForNew,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#defaultForNew')),
        );
      });

      test('origin has correct value', () {
        expect(
          AclPredicates.origin,
          equals(IriTerm('http://www.w3.org/ns/auth/acl#origin')),
        );
      });
    });
  });
}