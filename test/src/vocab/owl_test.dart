// Tests for the Web Ontology Language (OWL) vocabulary
import 'package:rdf_core/src/graph/rdf_term.dart';
import 'package:rdf_core/src/vocab/owl.dart';
import 'package:test/test.dart';

void main() {
  group('Owl', () {
    test('namespace uses correct OWL namespace URI', () {
      expect(Owl.namespace, equals('http://www.w3.org/2002/07/owl#'));
    });

    test('prefix has correct value', () {
      expect(Owl.prefix, equals('owl'));
    });

    group('OwlClasses', () {
      test('class_ has correct value', () {
        expect(
          OwlClasses.class_,
          equals(IriTerm('http://www.w3.org/2002/07/owl#Class')),
        );
      });

      test('thing has correct value', () {
        expect(
          OwlClasses.thing,
          equals(IriTerm('http://www.w3.org/2002/07/owl#Thing')),
        );
      });

      test('nothing has correct value', () {
        expect(
          OwlClasses.nothing,
          equals(IriTerm('http://www.w3.org/2002/07/owl#Nothing')),
        );
      });

      test('restriction has correct value', () {
        expect(
          OwlClasses.restriction,
          equals(IriTerm('http://www.w3.org/2002/07/owl#Restriction')),
        );
      });

      test('objectProperty has correct value', () {
        expect(
          OwlClasses.objectProperty,
          equals(IriTerm('http://www.w3.org/2002/07/owl#ObjectProperty')),
        );
      });

      test('datatypeProperty has correct value', () {
        expect(
          OwlClasses.datatypeProperty,
          equals(IriTerm('http://www.w3.org/2002/07/owl#DatatypeProperty')),
        );
      });

      test('annotationProperty has correct value', () {
        expect(
          OwlClasses.annotationProperty,
          equals(IriTerm('http://www.w3.org/2002/07/owl#AnnotationProperty')),
        );
      });

      test('ontology has correct value', () {
        expect(
          OwlClasses.ontology,
          equals(IriTerm('http://www.w3.org/2002/07/owl#Ontology')),
        );
      });

      test('namedIndividual has correct value', () {
        expect(
          OwlClasses.namedIndividual,
          equals(IriTerm('http://www.w3.org/2002/07/owl#NamedIndividual')),
        );
      });
    });

    group('OwlPredicates', () {
      test('sameAs has correct value', () {
        expect(
          OwlPredicates.sameAs,
          equals(IriTerm('http://www.w3.org/2002/07/owl#sameAs')),
        );
      });

      test('differentFrom has correct value', () {
        expect(
          OwlPredicates.differentFrom,
          equals(IriTerm('http://www.w3.org/2002/07/owl#differentFrom')),
        );
      });

      test('equivalentClass has correct value', () {
        expect(
          OwlPredicates.equivalentClass,
          equals(IriTerm('http://www.w3.org/2002/07/owl#equivalentClass')),
        );
      });

      test('equivalentProperty has correct value', () {
        expect(
          OwlPredicates.equivalentProperty,
          equals(IriTerm('http://www.w3.org/2002/07/owl#equivalentProperty')),
        );
      });

      test('disjointWith has correct value', () {
        expect(
          OwlPredicates.disjointWith,
          equals(IriTerm('http://www.w3.org/2002/07/owl#disjointWith')),
        );
      });

      test('inverseOf has correct value', () {
        expect(
          OwlPredicates.inverseOf,
          equals(IriTerm('http://www.w3.org/2002/07/owl#inverseOf')),
        );
      });

      test('onProperty has correct value', () {
        expect(
          OwlPredicates.onProperty,
          equals(IriTerm('http://www.w3.org/2002/07/owl#onProperty')),
        );
      });

      test('imports has correct value', () {
        expect(
          OwlPredicates.imports,
          equals(IriTerm('http://www.w3.org/2002/07/owl#imports')),
        );
      });

      test('versionInfo has correct value', () {
        expect(
          OwlPredicates.versionInfo,
          equals(IriTerm('http://www.w3.org/2002/07/owl#versionInfo')),
        );
      });
    });

    group('OwlConstraints', () {
      test('someValuesFrom has correct value', () {
        expect(
          OwlConstraints.someValuesFrom,
          equals(IriTerm('http://www.w3.org/2002/07/owl#someValuesFrom')),
        );
      });

      test('allValuesFrom has correct value', () {
        expect(
          OwlConstraints.allValuesFrom,
          equals(IriTerm('http://www.w3.org/2002/07/owl#allValuesFrom')),
        );
      });

      test('minCardinality has correct value', () {
        expect(
          OwlConstraints.minCardinality,
          equals(IriTerm('http://www.w3.org/2002/07/owl#minCardinality')),
        );
      });

      test('maxCardinality has correct value', () {
        expect(
          OwlConstraints.maxCardinality,
          equals(IriTerm('http://www.w3.org/2002/07/owl#maxCardinality')),
        );
      });

      test('cardinality has correct value', () {
        expect(
          OwlConstraints.cardinality,
          equals(IriTerm('http://www.w3.org/2002/07/owl#cardinality')),
        );
      });

      test('hasValue has correct value', () {
        expect(
          OwlConstraints.hasValue,
          equals(IriTerm('http://www.w3.org/2002/07/owl#hasValue')),
        );
      });
    });
  });
}
