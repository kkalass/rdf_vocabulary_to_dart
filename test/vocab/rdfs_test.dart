// Tests for the RDF Schema (RDFS) vocabulary
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/vocab/vocab.dart';
import 'package:test/test.dart';

void main() {
  group('Rdfs', () {
    test('namespace uses correct RDFS namespace URI', () {
      expect(Rdfs.namespace, equals('http://www.w3.org/2000/01/rdf-schema#'));
    });

    test('prefix has correct value', () {
      expect(Rdfs.prefix, equals('rdfs'));
    });

    group('RdfsClasses', () {
      test('resource has correct value', () {
        expect(
          RdfsClasses.resource,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#Resource')),
        );
      });

      test('class_ has correct value', () {
        expect(
          RdfsClasses.class_,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#Class')),
        );
      });

      test('literal has correct value', () {
        expect(
          RdfsClasses.literal,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#Literal')),
        );
      });

      test('datatype has correct value', () {
        expect(
          RdfsClasses.datatype,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#Datatype')),
        );
      });

      test('container has correct value', () {
        expect(
          RdfsClasses.container,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#Container')),
        );
      });

      test('containerMembershipProperty has correct value', () {
        expect(
          RdfsClasses.containerMembershipProperty,
          equals(
            IriTerm(
              'http://www.w3.org/2000/01/rdf-schema#ContainerMembershipProperty',
            ),
          ),
        );
      });
    });

    group('RdfsPredicates', () {
      test('domain has correct value', () {
        expect(
          RdfsPredicates.domain,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#domain')),
        );
      });

      test('range has correct value', () {
        expect(
          RdfsPredicates.range,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#range')),
        );
      });

      test('subPropertyOf has correct value', () {
        expect(
          RdfsPredicates.subPropertyOf,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#subPropertyOf')),
        );
      });

      test('subClassOf has correct value', () {
        expect(
          RdfsPredicates.subClassOf,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#subClassOf')),
        );
      });

      test('label has correct value', () {
        expect(
          RdfsPredicates.label,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#label')),
        );
      });

      test('comment has correct value', () {
        expect(
          RdfsPredicates.comment,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#comment')),
        );
      });

      test('member has correct value', () {
        expect(
          RdfsPredicates.member,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#member')),
        );
      });

      test('seeAlso has correct value', () {
        expect(
          RdfsPredicates.seeAlso,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#seeAlso')),
        );
      });

      test('isDefinedBy has correct value', () {
        expect(
          RdfsPredicates.isDefinedBy,
          equals(IriTerm('http://www.w3.org/2000/01/rdf-schema#isDefinedBy')),
        );
      });
    });
  });
}
