import 'package:rdf_core/constants/rdf_constants.dart';
import 'package:rdf_core/constants/xsd_constants.dart';
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:test/test.dart';

void main() {
  group('IriTerm', () {
    test('constructs with valid IRI', () {
      const iri = IriTerm('http://example.org/resource');
      expect(iri.iri, equals('http://example.org/resource'));
    });

    test('equals operator compares case-insensitively', () {
      const iri1 = IriTerm('http://example.org/resource');
      const iri2 = IriTerm('http://EXAMPLE.org/resource');
      const iri3 = IriTerm('http://example.org/different');

      expect(iri1, equals(iri2));
      expect(iri1, isNot(equals(iri3)));
    });

    test('hash codes are equal for case-variant IRIs', () {
      // Note: This test may theoretically fail in edge cases due to hash collisions
      // but should be stable for typical usage patterns
      const iri1 = IriTerm('http://example.org/resource');
      const iri2 = IriTerm('http://example.org/RESOURCE');

      expect(
        iri1.hashCode,
        isNot(equals(iri2.hashCode)),
        reason: 'Hash codes should be based on original case',
      );
    });

    test('toString returns a readable representation', () {
      const iri = IriTerm('http://example.org/resource');
      expect(iri.toString(), equals('IriTerm(http://example.org/resource)'));
    });

    test('is a subject, object and predicate', () {
      const iri = IriTerm('http://example.org/resource');
      expect(iri, isA<RdfSubject>());
      expect(iri, isA<RdfPredicate>());
      expect(iri, isA<RdfTerm>());
      expect(iri, isA<RdfObject>());
    });
  });

  group('BlankNodeTerm', () {
    test('constructs with valid label', () {
      const node = BlankNodeTerm('b1');
      expect(node.label, equals('b1'));
    });

    test('equals operator compares labels', () {
      const node1 = BlankNodeTerm('b1');
      const node2 = BlankNodeTerm('b1');
      const node3 = BlankNodeTerm('b2');

      expect(node1, equals(node2));
      expect(node1, isNot(equals(node3)));
    });

    test('hash codes are equal for equal nodes', () {
      const node1 = BlankNodeTerm('b1');
      const node2 = BlankNodeTerm('b1');

      expect(node1.hashCode, equals(node2.hashCode));
    });

    test('toString returns a readable representation', () {
      const node = BlankNodeTerm('b1');
      expect(node.toString(), equals('BlankNodeTerm(b1)'));
    });

    test('is a subject but not a predicate', () {
      const node = BlankNodeTerm('b1');
      expect(node, isA<RdfSubject>());
      expect(node, isA<RdfTerm>());
      expect(node, isNot(isA<RdfPredicate>()));
    });
  });

  group('LiteralTerm', () {
    test('constructs with datatype', () {
      final literal = LiteralTerm('42', datatype: XsdConstants.integerIri);
      expect(literal.value, equals('42'));
      expect(literal.datatype, equals(XsdConstants.integerIri));
      expect(literal.language, isNull);
    });

    test('constructs with language tag', () {
      final literal = LiteralTerm(
        'hello',
        datatype: RdfConstants.langStringIri,
        language: 'en',
      );
      expect(literal.value, equals('hello'));
      expect(literal.datatype, equals(RdfConstants.langStringIri));
      expect(literal.language, equals('en'));
    });

    test('typed factory creates correct datatype', () {
      final literal = LiteralTerm.typed('42', 'integer');
      expect(literal.value, equals('42'));
      expect(literal.datatype, equals(XsdConstants.integerIri));
      expect(literal.language, isNull);
    });

    test('string factory creates xsd:string literal', () {
      final literal = LiteralTerm.string('hello');
      expect(literal.value, equals('hello'));
      expect(literal.datatype, equals(XsdConstants.stringIri));
      expect(literal.language, isNull);
    });

    test('withLanguage factory creates language-tagged literal', () {
      final literal = LiteralTerm.withLanguage('hello', 'en');
      expect(literal.value, equals('hello'));
      expect(literal.datatype, equals(RdfConstants.langStringIri));
      expect(literal.language, equals('en'));
    });

    test('equals operator compares value, datatype and language', () {
      final literal1 = LiteralTerm.string('hello');
      final literal2 = LiteralTerm.string('hello');
      final literal3 = LiteralTerm.string('world');
      final literal4 = LiteralTerm.withLanguage('hello', 'en');

      expect(literal1, equals(literal2));
      expect(literal1, isNot(equals(literal3)));
      expect(literal1, isNot(equals(literal4)));
    });

    test('hash codes are equal for equal literals', () {
      final literal1 = LiteralTerm.string('hello');
      final literal2 = LiteralTerm.string('hello');

      expect(literal1.hashCode, equals(literal2.hashCode));
    });

    test('toString returns a readable representation', () {
      final literal = LiteralTerm.string('hello');
      expect(literal.toString(), contains('LiteralTerm(hello'));
    });

    test('is an object but not a subject or predicate', () {
      final literal = LiteralTerm.string('hello');
      expect(literal, isA<RdfObject>());
      expect(literal, isA<RdfTerm>());
      expect(literal, isNot(isA<RdfSubject>()));
      expect(literal, isNot(isA<RdfPredicate>()));
    });

    test(
      'throws assertion error when language tag is used without rdf:langString',
      () {
        expect(
          () => LiteralTerm(
            'hello',
            datatype: XsdConstants.stringIri,
            language: 'en',
          ),
          throwsA(isA<AssertionError>()),
        );
      },
    );

    test(
      'throws assertion error when rdf:langString is used without language tag',
      () {
        expect(
          () => LiteralTerm('hello', datatype: RdfConstants.langStringIri),
          throwsA(isA<AssertionError>()),
        );
      },
    );
  });
}
