// Tests for the Schema.org vocabulary
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/vocab/vocab.dart';
import 'package:test/test.dart';

void main() {
  group('Schema', () {
    test('namespace uses correct Schema.org namespace URI', () {
      expect(Schema.namespace, equals('https://schema.org/'));
    });

    test('prefix has correct value', () {
      expect(Schema.prefix, equals('schema'));
    });

    group('SchemaClasses', () {
      test('thing has correct value', () {
        expect(
          SchemaClasses.thing,
          equals(IriTerm('https://schema.org/Thing')),
        );
      });

      test('person has correct value', () {
        expect(
          SchemaClasses.person,
          equals(IriTerm('https://schema.org/Person')),
        );
      });

      test('organization has correct value', () {
        expect(
          SchemaClasses.organization,
          equals(IriTerm('https://schema.org/Organization')),
        );
      });

      test('place has correct value', () {
        expect(
          SchemaClasses.place,
          equals(IriTerm('https://schema.org/Place')),
        );
      });

      test('event has correct value', () {
        expect(
          SchemaClasses.event,
          equals(IriTerm('https://schema.org/Event')),
        );
      });

      test('creativeWork has correct value', () {
        expect(
          SchemaClasses.creativeWork,
          equals(IriTerm('https://schema.org/CreativeWork')),
        );
      });

      test('product has correct value', () {
        expect(
          SchemaClasses.product,
          equals(IriTerm('https://schema.org/Product')),
        );
      });

      test('action has correct value', () {
        expect(
          SchemaClasses.action,
          equals(IriTerm('https://schema.org/Action')),
        );
      });

      test('offer has correct value', () {
        expect(
          SchemaClasses.offer,
          equals(IriTerm('https://schema.org/Offer')),
        );
      });
    });

    group('SchemaProperties', () {
      test('name has correct value', () {
        expect(
          SchemaProperties.name,
          equals(IriTerm('https://schema.org/name')),
        );
      });

      test('description has correct value', () {
        expect(
          SchemaProperties.description,
          equals(IriTerm('https://schema.org/description')),
        );
      });

      test('url has correct value', () {
        expect(SchemaProperties.url, equals(IriTerm('https://schema.org/url')));
      });

      test('image has correct value', () {
        expect(
          SchemaProperties.image,
          equals(IriTerm('https://schema.org/image')),
        );
      });

      test('dateCreated has correct value', () {
        expect(
          SchemaProperties.dateCreated,
          equals(IriTerm('https://schema.org/dateCreated')),
        );
      });

      test('dateModified has correct value', () {
        expect(
          SchemaProperties.dateModified,
          equals(IriTerm('https://schema.org/dateModified')),
        );
      });

      test('datePublished has correct value', () {
        expect(
          SchemaProperties.datePublished,
          equals(IriTerm('https://schema.org/datePublished')),
        );
      });

      test('author has correct value', () {
        expect(
          SchemaProperties.author,
          equals(IriTerm('https://schema.org/author')),
        );
      });

      test('creator has correct value', () {
        expect(
          SchemaProperties.creator,
          equals(IriTerm('https://schema.org/creator')),
        );
      });

      test('publisher has correct value', () {
        expect(
          SchemaProperties.publisher,
          equals(IriTerm('https://schema.org/publisher')),
        );
      });
    });

    group('SchemaPersonProperties', () {
      test('givenName has correct value', () {
        expect(
          SchemaPersonProperties.givenName,
          equals(IriTerm('https://schema.org/givenName')),
        );
      });

      test('familyName has correct value', () {
        expect(
          SchemaPersonProperties.familyName,
          equals(IriTerm('https://schema.org/familyName')),
        );
      });

      test('birthDate has correct value', () {
        expect(
          SchemaPersonProperties.birthDate,
          equals(IriTerm('https://schema.org/birthDate')),
        );
      });

      test('email has correct value', () {
        expect(
          SchemaPersonProperties.email,
          equals(IriTerm('https://schema.org/email')),
        );
      });

      test('telephone has correct value', () {
        expect(
          SchemaPersonProperties.telephone,
          equals(IriTerm('https://schema.org/telephone')),
        );
      });

      test('jobTitle has correct value', () {
        expect(
          SchemaPersonProperties.jobTitle,
          equals(IriTerm('https://schema.org/jobTitle')),
        );
      });

      test('address has correct value', () {
        expect(
          SchemaPersonProperties.address,
          equals(IriTerm('https://schema.org/address')),
        );
      });
    });

    group('SchemaOrganizationProperties', () {
      test('legalName has correct value', () {
        expect(
          SchemaOrganizationProperties.legalName,
          equals(IriTerm('https://schema.org/legalName')),
        );
      });

      test('foundingDate has correct value', () {
        expect(
          SchemaOrganizationProperties.foundingDate,
          equals(IriTerm('https://schema.org/foundingDate')),
        );
      });

      test('employee has correct value', () {
        expect(
          SchemaOrganizationProperties.employee,
          equals(IriTerm('https://schema.org/employee')),
        );
      });

      test('member has correct value', () {
        expect(
          SchemaOrganizationProperties.member,
          equals(IriTerm('https://schema.org/member')),
        );
      });
    });
  });
}
