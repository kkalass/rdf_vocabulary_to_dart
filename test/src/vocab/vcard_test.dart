// Tests for the vCard Ontology vocabulary
import 'package:rdf_core/src/graph/rdf_term.dart';
import 'package:rdf_core/src/vocab/vcard.dart';
import 'package:test/test.dart';

void main() {
  group('Vcard', () {
    test('namespace uses correct vCard namespace URI', () {
      expect(Vcard.namespace, equals('http://www.w3.org/2006/vcard/ns#'));
    });

    test('prefix has correct value', () {
      expect(Vcard.prefix, equals('vcard'));
    });

    group('VcardClasses', () {
      test('vcard has correct value', () {
        expect(
          VcardClasses.vcard,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#VCard')),
        );
      });

      test('name has correct value', () {
        expect(
          VcardClasses.name,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#Name')),
        );
      });

      test('organization has correct value', () {
        expect(
          VcardClasses.organization,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#Organization')),
        );
      });

      test('address has correct value', () {
        expect(
          VcardClasses.address,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#Address')),
        );
      });

      test('email has correct value', () {
        expect(
          VcardClasses.email,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#Email')),
        );
      });

      test('tel has correct value', () {
        expect(
          VcardClasses.tel,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#Tel')),
        );
      });
    });

    group('VcardPredicates', () {
      test('fn has correct value', () {
        expect(
          VcardPredicates.fn,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#fn')),
        );
      });

      test('hasFN has correct value', () {
        expect(
          VcardPredicates.hasFN,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#hasFN')),
        );
      });

      test('hasName has correct value', () {
        expect(
          VcardPredicates.hasName,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#hasName')),
        );
      });

      test('givenName has correct value', () {
        expect(
          VcardPredicates.givenName,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#given-name')),
        );
      });

      test('familyName has correct value', () {
        expect(
          VcardPredicates.familyName,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#family-name')),
        );
      });

      test('additionalName has correct value', () {
        expect(
          VcardPredicates.additionalName,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#additional-name')),
        );
      });

      test('honorificPrefix has correct value', () {
        expect(
          VcardPredicates.honorificPrefix,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#honorific-prefix')),
        );
      });

      test('honorificSuffix has correct value', () {
        expect(
          VcardPredicates.honorificSuffix,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#honorific-suffix')),
        );
      });

      test('hasAddress has correct value', () {
        expect(
          VcardPredicates.hasAddress,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#hasAddress')),
        );
      });

      test('streetAddress has correct value', () {
        expect(
          VcardPredicates.streetAddress,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#street-address')),
        );
      });

      test('locality has correct value', () {
        expect(
          VcardPredicates.locality,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#locality')),
        );
      });

      test('region has correct value', () {
        expect(
          VcardPredicates.region,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#region')),
        );
      });

      test('postalCode has correct value', () {
        expect(
          VcardPredicates.postalCode,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#postal-code')),
        );
      });

      test('countryName has correct value', () {
        expect(
          VcardPredicates.countryName,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#country-name')),
        );
      });

      test('hasEmail has correct value', () {
        expect(
          VcardPredicates.hasEmail,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#hasEmail')),
        );
      });

      test('hasTel has correct value', () {
        expect(
          VcardPredicates.hasTel,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#hasTel')),
        );
      });

      test('hasURL has correct value', () {
        expect(
          VcardPredicates.hasURL,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#hasURL')),
        );
      });

      test('hasPhoto has correct value', () {
        expect(
          VcardPredicates.hasPhoto,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#hasPhoto')),
        );
      });

      test('bday has correct value', () {
        expect(
          VcardPredicates.bday,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#bday')),
        );
      });

      test('role has correct value', () {
        expect(
          VcardPredicates.role,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#role')),
        );
      });

      test('title has correct value', () {
        expect(
          VcardPredicates.title,
          equals(IriTerm('http://www.w3.org/2006/vcard/ns#title')),
        );
      });
    });
  });
}
