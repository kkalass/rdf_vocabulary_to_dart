import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/vocab/vocab.dart';
import 'package:test/test.dart';

void main() {
  group('Rdf', () {
    test('namespace uses correct RDF namespace URI', () {
      expect(
        Rdf.namespace,
        equals('http://www.w3.org/1999/02/22-rdf-syntax-ns#'),
      );
    });

    test('typeIri has correct value', () {
      expect(
        RdfPredicates.type,
        equals(IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')),
      );
    });

    test('langStringIri has correct value', () {
      expect(
        RdfTypes.langString,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#langString',
          ),
        ),
      );
    });

    test('propertyIri has correct value', () {
      expect(
        Rdf.property,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property',
          ),
        ),
      );
    });

    test('statementIri has correct value', () {
      expect(
        Rdf.statement,
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
        final typeIri = RdfPredicates.type as dynamic;
        typeIri.iri = 'modified';
      }, throwsNoSuchMethodError);
    });
  });

  group('RdfPredicates', () {
    group('containerMembership', () {
      test('returns correct IriTerm for valid indices', () {
        expect(
          RdfPredicates.containerMembership(1),
          equals(IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#_1')),
        );

        expect(
          RdfPredicates.containerMembership(42),
          equals(IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#_42')),
        );

        expect(
          RdfPredicates.containerMembership(999),
          equals(IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#_999')),
        );
      });

      test('throws ArgumentError for non-positive indices', () {
        expect(() => RdfPredicates.containerMembership(0), throwsArgumentError);

        expect(
          () => RdfPredicates.containerMembership(-1),
          throwsArgumentError,
        );
      });
    });
  });
}
