/// Schema.org Vocabulary
///
/// Provides constants for the [Schema.org vocabulary](https://schema.org/),
/// which defines schemas for structured data on the internet.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/vocab/schema.dart';
/// final person = SchemaClasses.person;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](https://schema.org/docs/schemas.html)
library schema_vocab;

import 'package:rdf_core/graph/rdf_term.dart';

/// Base Schema.org namespace and utility functions
class Schema {
  // coverage:ignore-start
  const Schema._();
  // coverage:ignore-end

  /// Base IRI for Schema.org vocabulary
  /// [Spec](http://schema.org/)
  static const String namespace = 'https://schema.org/';
  static const String prefix = 'schema';
}

/// Schema.org class constants.
///
/// Contains IRIs that represent classes defined in the Schema.org vocabulary.
class SchemaClasses {
  // coverage:ignore-start
  const SchemaClasses._();
  // coverage:ignore-end

  /// IRI for schema:Thing
  /// [Spec](https://schema.org/Thing)
  ///
  /// The most generic type of item. All other schema.org types inherit from this type.
  static const thing = IriTerm.prevalidated('${Schema.namespace}Thing');

  /// IRI for schema:Person
  /// [Spec](https://schema.org/Person)
  ///
  /// A person (alive, dead, undead, or fictional).
  static const person = IriTerm.prevalidated('${Schema.namespace}Person');

  /// IRI for schema:Organization
  /// [Spec](https://schema.org/Organization)
  ///
  /// An organization such as a school, NGO, corporation, club, etc.
  static const organization = IriTerm.prevalidated(
    '${Schema.namespace}Organization',
  );

  /// IRI for schema:Place
  /// [Spec](https://schema.org/Place)
  ///
  /// Entities that have a somewhat fixed, physical extension.
  static const place = IriTerm.prevalidated('${Schema.namespace}Place');

  /// IRI for schema:Event
  /// [Spec](https://schema.org/Event)
  ///
  /// An event happening at a certain time and location, such as a concert, lecture, or festival.
  static const event = IriTerm.prevalidated('${Schema.namespace}Event');

  /// IRI for schema:CreativeWork
  /// [Spec](https://schema.org/CreativeWork)
  ///
  /// The most generic kind of creative work, including books, movies, photographs, software programs, etc.
  static const creativeWork = IriTerm.prevalidated(
    '${Schema.namespace}CreativeWork',
  );

  /// IRI for schema:Product
  /// [Spec](https://schema.org/Product)
  ///
  /// Any offered product or service. For example: a pair of shoes; a concert ticket; a rental car.
  static const product = IriTerm.prevalidated('${Schema.namespace}Product');

  /// IRI for schema:Action
  /// [Spec](https://schema.org/Action)
  ///
  /// An action performed by a direct agent and indirect participants upon a direct object.
  static const action = IriTerm.prevalidated('${Schema.namespace}Action');

  /// IRI for schema:Offer
  /// [Spec](https://schema.org/Offer)
  ///
  /// An offer to transfer some rights to an item or to provide a service.
  static const offer = IriTerm.prevalidated('${Schema.namespace}Offer');

  /// IRI for schema:PostalAddress
  /// [Spec](https://schema.org/PostalAddress)
  ///
  /// The mailing address.
  static const postalAddress = IriTerm.prevalidated(
    '${Schema.namespace}PostalAddress',
  );

  /// IRI for schema:ContactPoint
  /// [Spec](https://schema.org/ContactPoint)
  ///
  /// A contact point—for example, a Customer Service department.
  static const contactPoint = IriTerm.prevalidated(
    '${Schema.namespace}ContactPoint',
  );

  /// IRI for schema:Country
  /// [Spec](https://schema.org/Country)
  ///
  /// A country.
  static const country = IriTerm.prevalidated('${Schema.namespace}Country');
}

/// Schema.org predicate constants.
///
/// Contains IRIs for properties defined in the Schema.org vocabulary.
class SchemaProperties {
  // coverage:ignore-start
  const SchemaProperties._();
  // coverage:ignore-end

  /// IRI for schema:name
  /// [Spec](https://schema.org/name)
  ///
  /// The name of the item.
  static const name = IriTerm.prevalidated('${Schema.namespace}name');

  /// IRI for schema:description
  /// [Spec](https://schema.org/description)
  ///
  /// A description of the item.
  static const description = IriTerm.prevalidated(
    '${Schema.namespace}description',
  );

  /// IRI for schema:url
  /// [Spec](https://schema.org/url)
  ///
  /// URL of the item.
  static const url = IriTerm.prevalidated('${Schema.namespace}url');

  /// IRI for schema:image
  /// [Spec](https://schema.org/image)
  ///
  /// An image of the item. This can be a URL or a fully described ImageObject.
  static const image = IriTerm.prevalidated('${Schema.namespace}image');

  /// IRI for schema:dateCreated
  /// [Spec](https://schema.org/dateCreated)
  ///
  /// The date on which something was created.
  static const dateCreated = IriTerm.prevalidated(
    '${Schema.namespace}dateCreated',
  );

  /// IRI for schema:dateModified
  /// [Spec](https://schema.org/dateModified)
  ///
  /// The date on which something was most recently modified.
  static const dateModified = IriTerm.prevalidated(
    '${Schema.namespace}dateModified',
  );

  /// IRI for schema:datePublished
  /// [Spec](https://schema.org/datePublished)
  ///
  /// Date of first broadcast/publication.
  static const datePublished = IriTerm.prevalidated(
    '${Schema.namespace}datePublished',
  );

  /// IRI for schema:author
  /// [Spec](https://schema.org/author)
  ///
  /// The author of this content or rating.
  static const author = IriTerm.prevalidated('${Schema.namespace}author');

  /// IRI for schema:creator
  /// [Spec](https://schema.org/creator)
  ///
  /// The creator/author of this CreativeWork.
  static const creator = IriTerm.prevalidated('${Schema.namespace}creator');

  /// IRI for schema:publisher
  /// [Spec](https://schema.org/publisher)
  ///
  /// The publisher of the creative work.
  static const publisher = IriTerm.prevalidated('${Schema.namespace}publisher');
}

/// Person-related Schema.org property constants.
///
/// Contains IRIs for person-related properties in the Schema.org vocabulary.
class SchemaPersonProperties {
  // coverage:ignore-start
  const SchemaPersonProperties._();
  // coverage:ignore-end

  /// IRI for schema:givenName
  /// [Spec](https://schema.org/givenName)
  ///
  /// Given name. In the U.S., the first name of a Person.
  static const givenName = IriTerm.prevalidated('${Schema.namespace}givenName');

  /// IRI for schema:familyName
  /// [Spec](https://schema.org/familyName)
  ///
  /// Family name. In the U.S., the last name of a Person.
  static const familyName = IriTerm.prevalidated(
    '${Schema.namespace}familyName',
  );

  /// IRI for schema:birthDate
  /// [Spec](https://schema.org/birthDate)
  ///
  /// Date of birth.
  static const birthDate = IriTerm.prevalidated('${Schema.namespace}birthDate');

  /// IRI for schema:email
  /// [Spec](https://schema.org/email)
  ///
  /// Email address.
  static const email = IriTerm.prevalidated('${Schema.namespace}email');

  /// IRI for schema:telephone
  /// [Spec](https://schema.org/telephone)
  ///
  /// The telephone number.
  static const telephone = IriTerm.prevalidated('${Schema.namespace}telephone');

  /// IRI for schema:jobTitle
  /// [Spec](https://schema.org/jobTitle)
  ///
  /// The job title of the person.
  static const jobTitle = IriTerm.prevalidated('${Schema.namespace}jobTitle');

  /// IRI for schema:address
  /// [Spec](https://schema.org/address)
  ///
  /// Physical address of the item.
  static const address = IriTerm.prevalidated('${Schema.namespace}address');
}

/// Organization-related Schema.org property constants.
///
/// Contains IRIs for organization-related properties in the Schema.org vocabulary.
class SchemaOrganizationProperties {
  // coverage:ignore-start
  const SchemaOrganizationProperties._();
  // coverage:ignore-end

  /// IRI for schema:legalName
  /// [Spec](https://schema.org/legalName)
  ///
  /// The official name of the organization, e.g. the registered company name.
  static const legalName = IriTerm.prevalidated('${Schema.namespace}legalName');

  /// IRI for schema:foundingDate
  /// [Spec](https://schema.org/foundingDate)
  ///
  /// The date that this organization was founded.
  static const foundingDate = IriTerm.prevalidated(
    '${Schema.namespace}foundingDate',
  );

  /// IRI for schema:employee
  /// [Spec](https://schema.org/employee)
  ///
  /// Someone working for this organization.
  static const employee = IriTerm.prevalidated('${Schema.namespace}employee');

  /// IRI for schema:member
  /// [Spec](https://schema.org/member)
  ///
  /// A member of an Organization or a ProgramMembership.
  static const member = IriTerm.prevalidated('${Schema.namespace}member');
}

/// Address-related Schema.org property constants.
///
/// Contains IRIs for address-related properties in the Schema.org vocabulary.
/// These properties are typically used with PostalAddress entities.
class SchemaAddressProperties {
  // coverage:ignore-start
  const SchemaAddressProperties._();
  // coverage:ignore-end

  /// IRI for schema:streetAddress
  /// [Spec](https://schema.org/streetAddress)
  ///
  /// The street address. For example, 1600 Amphitheatre Pkwy.
  static const streetAddress = IriTerm.prevalidated(
    '${Schema.namespace}streetAddress',
  );

  /// IRI for schema:addressLocality
  /// [Spec](https://schema.org/addressLocality)
  ///
  /// The locality in which the street address is, and which is in the region.
  /// For example, Mountain View.
  static const addressLocality = IriTerm.prevalidated(
    '${Schema.namespace}addressLocality',
  );

  /// IRI for schema:addressRegion
  /// [Spec](https://schema.org/addressRegion)
  ///
  /// The region in which the locality is, and which is in the country.
  /// For example, California or another appropriate first-level
  /// Administrative division.
  static const addressRegion = IriTerm.prevalidated(
    '${Schema.namespace}addressRegion',
  );

  /// IRI for schema:postalCode
  /// [Spec](https://schema.org/postalCode)
  ///
  /// The postal code. For example, 94043.
  static const postalCode = IriTerm.prevalidated(
    '${Schema.namespace}postalCode',
  );

  /// IRI for schema:postOfficeBoxNumber
  /// [Spec](https://schema.org/postOfficeBoxNumber)
  ///
  /// The post office box number for PO box addresses.
  static const postOfficeBoxNumber = IriTerm.prevalidated(
    '${Schema.namespace}postOfficeBoxNumber',
  );

  /// IRI for schema:addressCountry
  /// [Spec](https://schema.org/addressCountry)
  ///
  /// The country. For example, USA. You can also provide the two-letter
  /// ISO 3166-1 alpha-2 country code.
  static const addressCountry = IriTerm.prevalidated(
    '${Schema.namespace}addressCountry',
  );

  /// IRI for schema:areaServed
  /// [Spec](https://schema.org/areaServed)
  ///
  /// The geographic area where a service or offered item is provided.
  static const areaServed = IriTerm.prevalidated(
    '${Schema.namespace}areaServed',
  );

  /// IRI for schema:contactType
  /// [Spec](https://schema.org/contactType)
  ///
  /// A person or organization can have different contact points, for different purposes.
  /// For example, a sales contact point, a PR contact point and so on.
  /// This property is used to specify the kind of contact point.
  static const contactType = IriTerm.prevalidated(
    '${Schema.namespace}contactType',
  );
}
