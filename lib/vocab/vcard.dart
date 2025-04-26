/// vCard Ontology Vocabulary
///
/// Provides constants for the [vCard Ontology](https://www.w3.org/TR/vcard-rdf/).
/// This vocabulary corresponds to the RDF encoding of vCard data.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/vocab/vcard.dart';
/// final fullName = VcardPredicates.fn;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](https://www.w3.org/TR/vcard-rdf/)
library vcard_vocab;

import 'package:rdf_core/graph/rdf_term.dart';

/// Base vCard namespace and utility functions
class Vcard {
  const Vcard._();

  /// Base IRI for vCard vocabulary
  /// [Spec](https://www.w3.org/TR/vcard-rdf/)
  static const String namespace = 'http://www.w3.org/2006/vcard/ns#';
  static const String prefix = 'vcard';
}

/// vCard class constants.
///
/// Contains IRIs that represent classes defined in the vCard vocabulary.
class VcardClasses {
  const VcardClasses._();

  /// IRI for vcard:VCard
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e183)
  ///
  /// The main class for vCard objects.
  static const vcard = IriTerm.prevalidated('${Vcard.namespace}VCard');

  /// IRI for vcard:Name
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e429)
  ///
  /// To specify the components of the name of the object the vCard represents.
  static const name = IriTerm.prevalidated('${Vcard.namespace}Name');

  /// IRI for vcard:Organization
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e783)
  ///
  /// To specify the organizational name associated with the vCard.
  static const organization = IriTerm.prevalidated(
    '${Vcard.namespace}Organization',
  );

  /// IRI for vcard:Address
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e907)
  ///
  /// To specify a delivery address for the vCard object.
  static const address = IriTerm.prevalidated('${Vcard.namespace}Address');

  /// IRI for vcard:Email
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e1057)
  ///
  /// To specify the electronic mail address for communication with the vCard object.
  static const email = IriTerm.prevalidated('${Vcard.namespace}Email');

  /// IRI for vcard:Tel
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e1126)
  ///
  /// To specify the telephone number for telephony communication with the vCard object.
  static const tel = IriTerm.prevalidated('${Vcard.namespace}Tel');
}

/// vCard predicate constants.
///
/// Contains IRIs for properties defined in the vCard vocabulary.
class VcardPredicates {
  const VcardPredicates._();

  /// IRI for vcard:fn
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e398)
  ///
  /// The formatted text corresponding to the name of the object the vCard represents.
  static const fn = IriTerm.prevalidated('${Vcard.namespace}fn');

  /// IRI for vcard:hasFN
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e398)
  ///
  /// To specify the formatted text corresponding to the name of the object.
  static const hasFN = IriTerm.prevalidated('${Vcard.namespace}hasFN');

  /// IRI for vcard:hasName
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e429)
  ///
  /// To specify the components of the name of the object.
  static const hasName = IriTerm.prevalidated('${Vcard.namespace}hasName');

  /// IRI for vcard:given-name
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e513)
  ///
  /// The given name (or first name) associated with the vCard object.
  static const givenName = IriTerm.prevalidated('${Vcard.namespace}given-name');

  /// IRI for vcard:family-name
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e483)
  ///
  /// The family name (or last name) associated with the vCard object.
  static const familyName = IriTerm.prevalidated(
    '${Vcard.namespace}family-name',
  );

  /// IRI for vcard:additional-name
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e540)
  ///
  /// The additional name (or middle name) associated with the vCard object.
  static const additionalName = IriTerm.prevalidated(
    '${Vcard.namespace}additional-name',
  );

  /// IRI for vcard:honorific-prefix
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e567)
  ///
  /// The honorific prefix of the name associated with the vCard object.
  static const honorificPrefix = IriTerm.prevalidated(
    '${Vcard.namespace}honorific-prefix',
  );

  /// IRI for vcard:honorific-suffix
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e594)
  ///
  /// The honorific suffix of the name associated with the vCard object.
  static const honorificSuffix = IriTerm.prevalidated(
    '${Vcard.namespace}honorific-suffix',
  );

  /// IRI for vcard:hasAddress
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e907)
  ///
  /// To specify a delivery address for the vCard object.
  static const hasAddress = IriTerm.prevalidated(
    '${Vcard.namespace}hasAddress',
  );

  /// IRI for vcard:street-address
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e935)
  ///
  /// The street address associated with the vCard object.
  static const streetAddress = IriTerm.prevalidated(
    '${Vcard.namespace}street-address',
  );

  /// IRI for vcard:locality
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e959)
  ///
  /// The locality (e.g., city) associated with the vCard object.
  static const locality = IriTerm.prevalidated('${Vcard.namespace}locality');

  /// IRI for vcard:region
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e984)
  ///
  /// The region (e.g., state, province) associated with the vCard object.
  static const region = IriTerm.prevalidated('${Vcard.namespace}region');

  /// IRI for vcard:postal-code
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e1007)
  ///
  /// The postal code associated with the vCard object.
  static const postalCode = IriTerm.prevalidated(
    '${Vcard.namespace}postal-code',
  );

  /// IRI for vcard:country-name
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e1032)
  ///
  /// The country name associated with the vCard object.
  static const countryName = IriTerm.prevalidated(
    '${Vcard.namespace}country-name',
  );

  /// IRI for vcard:hasEmail
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e1057)
  ///
  /// To specify the electronic mail address for communication with the vCard object.
  static const hasEmail = IriTerm.prevalidated('${Vcard.namespace}hasEmail');

  /// IRI for vcard:hasTel
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e1126)
  ///
  /// To specify the telephone number for telephony communication with the vCard object.
  static const hasTel = IriTerm.prevalidated('${Vcard.namespace}hasTel');

  /// IRI for vcard:hasURL
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e1202)
  ///
  /// To specify a URL for a website that represents the person or organization.
  static const hasURL = IriTerm.prevalidated('${Vcard.namespace}hasURL');

  /// IRI for vcard:hasPhoto
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e1290)
  ///
  /// To specify an image or photograph that represents the vCard object.
  static const hasPhoto = IriTerm.prevalidated('${Vcard.namespace}hasPhoto');

  /// IRI for vcard:bday
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e1380)
  ///
  /// To specify the birth date of the vCard object.
  static const bday = IriTerm.prevalidated('${Vcard.namespace}bday');

  /// IRI for vcard:role
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e1485)
  ///
  /// To specify the role, occupation, or business category of the vCard object.
  static const role = IriTerm.prevalidated('${Vcard.namespace}role');

  /// IRI for vcard:title
  /// [Spec](https://www.w3.org/TR/vcard-rdf/#d4e1520)
  ///
  /// To specify the job title, functional position or function of the vCard object.
  static const title = IriTerm.prevalidated('${Vcard.namespace}title');
}
