/// Dublin Core Terms Vocabulary
///
/// Provides constants for the [Dublin Core Terms vocabulary](http://purl.org/dc/terms/),
/// which extends the basic Dublin Core Elements with additional metadata terms.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/src/vocab/dc_terms.dart';
/// final title = DcTermsPredicates.title;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](http://purl.org/dc/terms/)
library dc_terms_vocab;

import 'package:rdf_core/src/graph/rdf_term.dart';

/// Base Dublin Core Terms namespace and utility functions
class DcTerms {
  // coverage:ignore-start
  const DcTerms._();
  // coverage:ignore-end

  /// Base IRI for Dublin Core Terms vocabulary
  /// [Spec](http://purl.org/dc/terms/)
  static const String namespace = 'http://purl.org/dc/terms/';
  static const String prefix = 'dcterms';
}

/// Dublin Core Terms classes.
///
/// Contains IRIs for classes defined in the Dublin Core Terms vocabulary.
class DcTermsClasses {
  // coverage:ignore-start
  const DcTermsClasses._();
  // coverage:ignore-end

  /// IRI for dcterms:Agent
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/Agent)
  ///
  /// A resource that acts or has the power to act.
  static const agent = IriTerm.prevalidated('${DcTerms.namespace}Agent');

  /// IRI for dcterms:AgentClass
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/AgentClass)
  ///
  /// A group of agents.
  static const agentClass = IriTerm.prevalidated(
    '${DcTerms.namespace}AgentClass',
  );

  /// IRI for dcterms:BibliographicResource
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/BibliographicResource)
  ///
  /// A book, article, or other documentary resource.
  static const bibliographicResource = IriTerm.prevalidated(
    '${DcTerms.namespace}BibliographicResource',
  );

  /// IRI for dcterms:FileFormat
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/FileFormat)
  ///
  /// A digital resource format.
  static const fileFormat = IriTerm.prevalidated(
    '${DcTerms.namespace}FileFormat',
  );

  /// IRI for dcterms:LicenseDocument
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/LicenseDocument)
  ///
  /// A legal document giving official permission to do something with a resource.
  static const licenseDocument = IriTerm.prevalidated(
    '${DcTerms.namespace}LicenseDocument',
  );

  /// IRI for dcterms:LinguisticSystem
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/LinguisticSystem)
  ///
  /// A system of signs, symbols, sounds, gestures, or rules used in communication.
  static const linguisticSystem = IriTerm.prevalidated(
    '${DcTerms.namespace}LinguisticSystem',
  );

  /// IRI for dcterms:Location
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/Location)
  ///
  /// A spatial region or named place.
  static const location = IriTerm.prevalidated('${DcTerms.namespace}Location');

  /// IRI for dcterms:PeriodOfTime
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/PeriodOfTime)
  ///
  /// An interval of time that is named or defined by its start and end dates.
  static const periodOfTime = IriTerm.prevalidated(
    '${DcTerms.namespace}PeriodOfTime',
  );
}

/// Dublin Core Terms predicates.
///
/// Contains IRIs for properties defined in the Dublin Core Terms vocabulary.
class DcTermsPredicates {
  // coverage:ignore-start
  const DcTermsPredicates._();
  // coverage:ignore-end

  /// IRI for dcterms:abstract property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/abstract)
  ///
  /// A summary of the resource.
  static const abstract = IriTerm.prevalidated('${DcTerms.namespace}abstract');

  /// IRI for dcterms:accessRights property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/accessRights)
  ///
  /// Information about who can access the resource or an indication of its security status.
  static const accessRights = IriTerm.prevalidated(
    '${DcTerms.namespace}accessRights',
  );

  /// IRI for dcterms:accrualMethod property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/accrualMethod)
  ///
  /// The method by which items are added to a collection.
  static const accrualMethod = IriTerm.prevalidated(
    '${DcTerms.namespace}accrualMethod',
  );

  /// IRI for dcterms:accrualPeriodicity property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/accrualPeriodicity)
  ///
  /// The frequency with which items are added to a collection.
  static const accrualPeriodicity = IriTerm.prevalidated(
    '${DcTerms.namespace}accrualPeriodicity',
  );

  /// IRI for dcterms:accrualPolicy property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/accrualPolicy)
  ///
  /// The policy governing the addition of items to a collection.
  static const accrualPolicy = IriTerm.prevalidated(
    '${DcTerms.namespace}accrualPolicy',
  );

  /// IRI for dcterms:alternative property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/alternative)
  ///
  /// An alternative name for the resource.
  static const alternative = IriTerm.prevalidated(
    '${DcTerms.namespace}alternative',
  );

  /// IRI for dcterms:audience property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/audience)
  ///
  /// A class of entity for whom the resource is intended or useful.
  static const audience = IriTerm.prevalidated('${DcTerms.namespace}audience');

  /// IRI for dcterms:available property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/available)
  ///
  /// Date that the resource became or will become available.
  static const available = IriTerm.prevalidated(
    '${DcTerms.namespace}available',
  );

  /// IRI for dcterms:bibliographicCitation property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/bibliographicCitation)
  ///
  /// A bibliographic reference for the resource.
  static const bibliographicCitation = IriTerm.prevalidated(
    '${DcTerms.namespace}bibliographicCitation',
  );

  /// IRI for dcterms:conformsTo property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/conformsTo)
  ///
  /// An established standard to which the described resource conforms.
  static const conformsTo = IriTerm.prevalidated(
    '${DcTerms.namespace}conformsTo',
  );

  /// IRI for dcterms:contributor property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/contributor)
  ///
  /// An entity responsible for making contributions to the resource.
  static const contributor = IriTerm.prevalidated(
    '${DcTerms.namespace}contributor',
  );

  /// IRI for dcterms:coverage property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/coverage)
  ///
  /// The spatial or temporal topic of the resource, spatial applicability, or jurisdiction.
  static const coverage = IriTerm.prevalidated('${DcTerms.namespace}coverage');

  /// IRI for dcterms:created property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/created)
  static const created = IriTerm.prevalidated('${DcTerms.namespace}created');

  /// IRI for dcterms:creator property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/creator)
  static const creator = IriTerm.prevalidated('${DcTerms.namespace}creator');

  /// IRI for dcterms:date property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/date)
  ///
  /// A point or period of time associated with an event in the lifecycle of the resource.
  static const date = IriTerm.prevalidated('${DcTerms.namespace}date');

  /// IRI for dcterms:dateAccepted property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/dateAccepted)
  ///
  /// Date of acceptance of the resource.
  static const dateAccepted = IriTerm.prevalidated(
    '${DcTerms.namespace}dateAccepted',
  );

  /// IRI for dcterms:dateCopyrighted property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/dateCopyrighted)
  ///
  /// Date of copyright of the resource.
  static const dateCopyrighted = IriTerm.prevalidated(
    '${DcTerms.namespace}dateCopyrighted',
  );

  /// IRI for dcterms:dateSubmitted property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/dateSubmitted)
  ///
  /// Date of submission of the resource.
  static const dateSubmitted = IriTerm.prevalidated(
    '${DcTerms.namespace}dateSubmitted',
  );

  /// IRI for dcterms:description property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/description)
  ///
  /// An account of the resource.
  static const description = IriTerm.prevalidated(
    '${DcTerms.namespace}description',
  );

  /// IRI for dcterms:educationLevel property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/educationLevel)
  ///
  /// A class of entity, defined in terms of progression through an educational context.
  static const educationLevel = IriTerm.prevalidated(
    '${DcTerms.namespace}educationLevel',
  );

  /// IRI for dcterms:extent property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/extent)
  ///
  /// The size or duration of the resource.
  static const extent = IriTerm.prevalidated('${DcTerms.namespace}extent');

  /// IRI for dcterms:format property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/format)
  ///
  /// The file format, physical medium, or dimensions of the resource.
  static const format = IriTerm.prevalidated('${DcTerms.namespace}format');

  /// IRI for dcterms:hasFormat property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/hasFormat)
  ///
  /// A related resource that is substantially the same as the described resource, but in another format.
  static const hasFormat = IriTerm.prevalidated(
    '${DcTerms.namespace}hasFormat',
  );

  /// IRI for dcterms:hasPart property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/hasPart)
  ///
  /// A related resource that is included either physically or logically in the described resource.
  static const hasPart = IriTerm.prevalidated('${DcTerms.namespace}hasPart');

  /// IRI for dcterms:hasVersion property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/hasVersion)
  ///
  /// A related resource that is a version, edition, or adaptation of the described resource.
  static const hasVersion = IriTerm.prevalidated(
    '${DcTerms.namespace}hasVersion',
  );

  /// IRI for dcterms:identifier property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/identifier)
  ///
  /// An unambiguous reference to the resource within a given context.
  static const identifier = IriTerm.prevalidated(
    '${DcTerms.namespace}identifier',
  );

  /// IRI for dcterms:instructionalMethod property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/instructionalMethod)
  ///
  /// A process, used to engender knowledge, attitudes and skills, that the resource is designed to support.
  static const instructionalMethod = IriTerm.prevalidated(
    '${DcTerms.namespace}instructionalMethod',
  );

  /// IRI for dcterms:isFormatOf property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/isFormatOf)
  ///
  /// A related resource that is substantially the same as the described resource, but in another format.
  static const isFormatOf = IriTerm.prevalidated(
    '${DcTerms.namespace}isFormatOf',
  );

  /// IRI for dcterms:isPartOf property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/isPartOf)
  ///
  /// A related resource in which the described resource is physically or logically included.
  static const isPartOf = IriTerm.prevalidated('${DcTerms.namespace}isPartOf');

  /// IRI for dcterms:isReferencedBy property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/isReferencedBy)
  ///
  /// A related resource that references, cites, or otherwise points to the described resource.
  static const isReferencedBy = IriTerm.prevalidated(
    '${DcTerms.namespace}isReferencedBy',
  );

  /// IRI for dcterms:isReplacedBy property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/isReplacedBy)
  ///
  /// A related resource that supplants, displaces, or supersedes the described resource.
  static const isReplacedBy = IriTerm.prevalidated(
    '${DcTerms.namespace}isReplacedBy',
  );

  /// IRI for dcterms:isRequiredBy property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/isRequiredBy)
  ///
  /// A related resource that requires the described resource to support its function, delivery, or coherence.
  static const isRequiredBy = IriTerm.prevalidated(
    '${DcTerms.namespace}isRequiredBy',
  );

  /// IRI for dcterms:isVersionOf property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/isVersionOf)
  ///
  /// A related resource of which the described resource is a version, edition, or adaptation.
  static const isVersionOf = IriTerm.prevalidated(
    '${DcTerms.namespace}isVersionOf',
  );

  /// IRI for dcterms:issued property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/issued)
  ///
  /// Date of formal issuance of the resource.
  static const issued = IriTerm.prevalidated('${DcTerms.namespace}issued');

  /// IRI for dcterms:language property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/language)
  ///
  /// A language of the resource.
  static const language = IriTerm.prevalidated('${DcTerms.namespace}language');

  /// IRI for dcterms:license property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/license)
  ///
  /// A legal document giving official permission to do something with the resource.
  static const license = IriTerm.prevalidated('${DcTerms.namespace}license');

  /// IRI for dcterms:mediator property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/mediator)
  ///
  /// An entity that mediates access to the resource.
  static const mediator = IriTerm.prevalidated('${DcTerms.namespace}mediator');

  /// IRI for dcterms:medium property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/medium)
  ///
  /// The material or physical carrier of the resource.
  static const medium = IriTerm.prevalidated('${DcTerms.namespace}medium');

  /// IRI for dcterms:modified property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/modified)
  static const modified = IriTerm.prevalidated('${DcTerms.namespace}modified');

  /// IRI for dcterms:provenance property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/provenance)
  ///
  /// A statement of any changes in ownership and custody of the resource since its creation.
  static const provenance = IriTerm.prevalidated(
    '${DcTerms.namespace}provenance',
  );

  /// IRI for dcterms:publisher property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/publisher)
  ///
  /// An entity responsible for making the resource available.
  static const publisher = IriTerm.prevalidated(
    '${DcTerms.namespace}publisher',
  );

  /// IRI for dcterms:references property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/references)
  ///
  /// A related resource that is referenced, cited, or otherwise pointed to by the described resource.
  static const references = IriTerm.prevalidated(
    '${DcTerms.namespace}references',
  );

  /// IRI for dcterms:relation property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/relation)
  ///
  /// A related resource.
  static const relation = IriTerm.prevalidated('${DcTerms.namespace}relation');

  /// IRI for dcterms:replaces property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/replaces)
  ///
  /// A related resource that is supplanted, displaced, or superseded by the described resource.
  static const replaces = IriTerm.prevalidated('${DcTerms.namespace}replaces');

  /// IRI for dcterms:requires property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/requires)
  ///
  /// A related resource that is required by the described resource to support its function, delivery, or coherence.
  static const requires = IriTerm.prevalidated('${DcTerms.namespace}requires');

  /// IRI for dcterms:rights property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/rights)
  ///
  /// Information about rights held in and over the resource.
  static const rights = IriTerm.prevalidated('${DcTerms.namespace}rights');

  /// IRI for dcterms:rightsHolder property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/rightsHolder)
  ///
  /// A person or organization owning or managing rights over the resource.
  static const rightsHolder = IriTerm.prevalidated(
    '${DcTerms.namespace}rightsHolder',
  );

  /// IRI for dcterms:source property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/source)
  ///
  /// A related resource from which the described resource is derived.
  static const source = IriTerm.prevalidated('${DcTerms.namespace}source');

  /// IRI for dcterms:spatial property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/spatial)
  ///
  /// Spatial characteristics of the resource.
  static const spatial = IriTerm.prevalidated('${DcTerms.namespace}spatial');

  /// IRI for dcterms:subject property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/subject)
  ///
  /// The topic of the resource.
  static const subject = IriTerm.prevalidated('${DcTerms.namespace}subject');

  /// IRI for dcterms:tableOfContents property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/tableOfContents)
  ///
  /// A list of subunits of the resource.
  static const tableOfContents = IriTerm.prevalidated(
    '${DcTerms.namespace}tableOfContents',
  );

  /// IRI for dcterms:temporal property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/temporal)
  ///
  /// Temporal characteristics of the resource.
  static const temporal = IriTerm.prevalidated('${DcTerms.namespace}temporal');

  /// IRI for dcterms:title property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/title)
  ///
  /// A name given to the resource.
  static const title = IriTerm.prevalidated('${DcTerms.namespace}title');

  /// IRI for dcterms:type property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/type)
  ///
  /// The nature or genre of the resource.
  static const type = IriTerm.prevalidated('${DcTerms.namespace}type');

  /// IRI for dcterms:valid property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/valid)
  ///
  /// Date (often a range) of validity of a resource.
  static const valid = IriTerm.prevalidated('${DcTerms.namespace}valid');
}
