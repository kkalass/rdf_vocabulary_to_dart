import 'package:rdf_core/src/graph/rdf_term.dart';
import 'package:rdf_core/src/vocab/rdf.dart';
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

    test('nil has correct value', () {
      expect(
        Rdf.nil,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#nil',
          ),
        ),
      );
    });

    test('list has correct value', () {
      expect(
        Rdf.list,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#List',
          ),
        ),
      );
    });

    test('alt has correct value', () {
      expect(
        Rdf.alt,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#Alt',
          ),
        ),
      );
    });

    test('bag has correct value', () {
      expect(
        Rdf.bag,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#Bag',
          ),
        ),
      );
    });

    test('seq has correct value', () {
      expect(
        Rdf.seq,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#Seq',
          ),
        ),
      );
    });

    test('container has correct value', () {
      expect(
        Rdf.container,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#Container',
          ),
        ),
      );
    });

    test('xmlLiteral has correct value', () {
      expect(
        Rdf.xmlLiteral,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral',
          ),
        ),
      );
    });

    test('html has correct value', () {
      expect(
        Rdf.html,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#HTML',
          ),
        ),
      );
    });

    test('subject has correct value', () {
      expect(
        Rdf.subject,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#subject',
          ),
        ),
      );
    });

    test('predicate has correct value', () {
      expect(
        Rdf.predicate,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate',
          ),
        ),
      );
    });

    test('object has correct value', () {
      expect(
        Rdf.object,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#object',
          ),
        ),
      );
    });

    test('first has correct value', () {
      expect(
        Rdf.first,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#first',
          ),
        ),
      );
    });

    test('rest has correct value', () {
      expect(
        Rdf.rest,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#rest',
          ),
        ),
      );
    });

    test('value has correct value', () {
      expect(
        Rdf.value,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#value',
          ),
        ),
      );
    });

    test('json has correct value', () {
      expect(
        Rdf.json,
        equals(
          const IriTerm.prevalidated(
            'http://www.w3.org/1999/02/22-rdf-syntax-ns#JSON',
          ),
        ),
      );
    });

    test('prefix has correct value', () {
      expect(Rdf.prefix, equals('rdf'));
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
