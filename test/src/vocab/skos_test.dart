// Tests for the Simple Knowledge Organization System (SKOS) vocabulary
import 'package:rdf_core/src/graph/rdf_term.dart';
import 'package:rdf_core/src/vocab/skos.dart';
import 'package:test/test.dart';

void main() {
  group('Skos', () {
    test('namespace uses correct SKOS namespace URI', () {
      expect(Skos.namespace, equals('http://www.w3.org/2004/02/skos/core#'));
    });

    test('prefix has correct value', () {
      expect(Skos.prefix, equals('skos'));
    });

    group('SkosClasses', () {
      test('concept has correct value', () {
        expect(
          SkosClasses.concept,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#Concept')),
        );
      });

      test('conceptScheme has correct value', () {
        expect(
          SkosClasses.conceptScheme,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#ConceptScheme')),
        );
      });

      test('collection has correct value', () {
        expect(
          SkosClasses.collection,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#Collection')),
        );
      });

      test('orderedCollection has correct value', () {
        expect(
          SkosClasses.orderedCollection,
          equals(
            IriTerm('http://www.w3.org/2004/02/skos/core#OrderedCollection'),
          ),
        );
      });
    });

    group('SkosSemanticRelations', () {
      test('broader has correct value', () {
        expect(
          SkosSemanticRelations.broader,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#broader')),
        );
      });

      test('narrower has correct value', () {
        expect(
          SkosSemanticRelations.narrower,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#narrower')),
        );
      });

      test('related has correct value', () {
        expect(
          SkosSemanticRelations.related,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#related')),
        );
      });

      test('broaderTransitive has correct value', () {
        expect(
          SkosSemanticRelations.broaderTransitive,
          equals(
            IriTerm('http://www.w3.org/2004/02/skos/core#broaderTransitive'),
          ),
        );
      });

      test('narrowerTransitive has correct value', () {
        expect(
          SkosSemanticRelations.narrowerTransitive,
          equals(
            IriTerm('http://www.w3.org/2004/02/skos/core#narrowerTransitive'),
          ),
        );
      });

      test('semanticRelation has correct value', () {
        expect(
          SkosSemanticRelations.semanticRelation,
          equals(
            IriTerm('http://www.w3.org/2004/02/skos/core#semanticRelation'),
          ),
        );
      });
    });

    group('SkosConceptSchemePredicates', () {
      test('inScheme has correct value', () {
        expect(
          SkosConceptSchemePredicates.inScheme,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#inScheme')),
        );
      });

      test('hasTopConcept has correct value', () {
        expect(
          SkosConceptSchemePredicates.hasTopConcept,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#hasTopConcept')),
        );
      });

      test('topConceptOf has correct value', () {
        expect(
          SkosConceptSchemePredicates.topConceptOf,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#topConceptOf')),
        );
      });
    });

    group('SkosLabelRelations', () {
      test('prefLabel has correct value', () {
        expect(
          SkosLabelRelations.prefLabel,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#prefLabel')),
        );
      });

      test('altLabel has correct value', () {
        expect(
          SkosLabelRelations.altLabel,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#altLabel')),
        );
      });

      test('hiddenLabel has correct value', () {
        expect(
          SkosLabelRelations.hiddenLabel,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#hiddenLabel')),
        );
      });
    });

    group('SkosDocumentationProps', () {
      test('note has correct value', () {
        expect(
          SkosDocumentationProps.note,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#note')),
        );
      });

      test('definition has correct value', () {
        expect(
          SkosDocumentationProps.definition,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#definition')),
        );
      });

      test('example has correct value', () {
        expect(
          SkosDocumentationProps.example,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#example')),
        );
      });

      test('scopeNote has correct value', () {
        expect(
          SkosDocumentationProps.scopeNote,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#scopeNote')),
        );
      });

      test('historyNote has correct value', () {
        expect(
          SkosDocumentationProps.historyNote,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#historyNote')),
        );
      });
    });

    group('SkosMappingProps', () {
      test('exactMatch has correct value', () {
        expect(
          SkosMappingProps.exactMatch,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#exactMatch')),
        );
      });

      test('closeMatch has correct value', () {
        expect(
          SkosMappingProps.closeMatch,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#closeMatch')),
        );
      });

      test('broadMatch has correct value', () {
        expect(
          SkosMappingProps.broadMatch,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#broadMatch')),
        );
      });

      test('narrowMatch has correct value', () {
        expect(
          SkosMappingProps.narrowMatch,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#narrowMatch')),
        );
      });

      test('relatedMatch has correct value', () {
        expect(
          SkosMappingProps.relatedMatch,
          equals(IriTerm('http://www.w3.org/2004/02/skos/core#relatedMatch')),
        );
      });
    });
  });
}
