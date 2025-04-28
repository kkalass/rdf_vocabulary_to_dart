// Tests for the Dublin Core Elements (DC) vocabulary
import 'package:rdf_core/src/graph/rdf_term.dart';
import 'package:rdf_core/src/vocab/dc.dart';

import 'package:test/test.dart';

void main() {
  group('Dc', () {
    test('namespace uses correct Dublin Core Elements namespace URI', () {
      expect(Dc.namespace, equals('http://purl.org/dc/elements/1.1/'));
    });

    test('prefix has correct value', () {
      expect(Dc.prefix, equals('dc'));
    });

    group('DcPredicates', () {
      test('title has correct value', () {
        expect(
          DcPredicates.title,
          equals(IriTerm('http://purl.org/dc/elements/1.1/title')),
        );
      });

      test('creator has correct value', () {
        expect(
          DcPredicates.creator,
          equals(IriTerm('http://purl.org/dc/elements/1.1/creator')),
        );
      });

      test('subject has correct value', () {
        expect(
          DcPredicates.subject,
          equals(IriTerm('http://purl.org/dc/elements/1.1/subject')),
        );
      });

      test('description has correct value', () {
        expect(
          DcPredicates.description,
          equals(IriTerm('http://purl.org/dc/elements/1.1/description')),
        );
      });

      test('publisher has correct value', () {
        expect(
          DcPredicates.publisher,
          equals(IriTerm('http://purl.org/dc/elements/1.1/publisher')),
        );
      });

      test('contributor has correct value', () {
        expect(
          DcPredicates.contributor,
          equals(IriTerm('http://purl.org/dc/elements/1.1/contributor')),
        );
      });

      test('date has correct value', () {
        expect(
          DcPredicates.date,
          equals(IriTerm('http://purl.org/dc/elements/1.1/date')),
        );
      });

      test('type has correct value', () {
        expect(
          DcPredicates.type,
          equals(IriTerm('http://purl.org/dc/elements/1.1/type')),
        );
      });

      test('format has correct value', () {
        expect(
          DcPredicates.format,
          equals(IriTerm('http://purl.org/dc/elements/1.1/format')),
        );
      });

      test('identifier has correct value', () {
        expect(
          DcPredicates.identifier,
          equals(IriTerm('http://purl.org/dc/elements/1.1/identifier')),
        );
      });

      test('source has correct value', () {
        expect(
          DcPredicates.source,
          equals(IriTerm('http://purl.org/dc/elements/1.1/source')),
        );
      });

      test('language has correct value', () {
        expect(
          DcPredicates.language,
          equals(IriTerm('http://purl.org/dc/elements/1.1/language')),
        );
      });

      test('relation has correct value', () {
        expect(
          DcPredicates.relation,
          equals(IriTerm('http://purl.org/dc/elements/1.1/relation')),
        );
      });

      test('coverage has correct value', () {
        expect(
          DcPredicates.coverage,
          equals(IriTerm('http://purl.org/dc/elements/1.1/coverage')),
        );
      });

      test('rights has correct value', () {
        expect(
          DcPredicates.rights,
          equals(IriTerm('http://purl.org/dc/elements/1.1/rights')),
        );
      });
    });
  });
}
