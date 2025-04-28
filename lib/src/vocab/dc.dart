/// Dublin Core Vocabulary
///
/// Provides constants for the [Dublin Core Metadata Initiative vocabulary](http://purl.org/dc/elements/1.1/),
/// which defines basic metadata terms for describing resources.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/src/vocab/dc.dart';
/// final title = DcPredicates.title;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](http://purl.org/dc/elements/1.1/)
library dc_vocab;

import 'package:rdf_core/src/graph/rdf_term.dart';

/// Base Dublin Core namespace and utility functions
class Dc {
  // coverage:ignore-start
  const Dc._();
  // coverage:ignore-end

  /// Base IRI for Dublin Core Elements vocabulary
  /// [Spec](http://purl.org/dc/elements/1.1/)
  static const String namespace = 'http://purl.org/dc/elements/1.1/';
  static const String prefix = 'dc';
}

/// Dublin Core predicates.
///
/// Contains IRIs for properties defined in the Dublin Core Elements vocabulary.
class DcPredicates {
  // coverage:ignore-start
  const DcPredicates._();
  // coverage:ignore-end

  /// IRI for dc:title
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/title/)
  ///
  /// A name given to the resource.
  static const title = IriTerm.prevalidated('${Dc.namespace}title');

  /// IRI for dc:creator
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/creator/)
  ///
  /// An entity primarily responsible for making the resource.
  static const creator = IriTerm.prevalidated('${Dc.namespace}creator');

  /// IRI for dc:subject
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/subject/)
  ///
  /// The topic of the resource.
  static const subject = IriTerm.prevalidated('${Dc.namespace}subject');

  /// IRI for dc:description
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/description/)
  ///
  /// An account of the resource.
  static const description = IriTerm.prevalidated('${Dc.namespace}description');

  /// IRI for dc:publisher
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/publisher/)
  ///
  /// An entity responsible for making the resource available.
  static const publisher = IriTerm.prevalidated('${Dc.namespace}publisher');

  /// IRI for dc:contributor
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/contributor/)
  ///
  /// An entity responsible for making contributions to the resource.
  static const contributor = IriTerm.prevalidated('${Dc.namespace}contributor');

  /// IRI for dc:date
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/date/)
  ///
  /// A point or period of time associated with an event in the lifecycle of the resource.
  static const date = IriTerm.prevalidated('${Dc.namespace}date');

  /// IRI for dc:type
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/type/)
  ///
  /// The nature or genre of the resource.
  static const type = IriTerm.prevalidated('${Dc.namespace}type');

  /// IRI for dc:format
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/format/)
  ///
  /// The file format, physical medium, or dimensions of the resource.
  static const format = IriTerm.prevalidated('${Dc.namespace}format');

  /// IRI for dc:identifier
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/identifier/)
  ///
  /// An unambiguous reference to the resource within a given context.
  static const identifier = IriTerm.prevalidated('${Dc.namespace}identifier');

  /// IRI for dc:source
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/source/)
  ///
  /// A related resource from which the described resource is derived.
  static const source = IriTerm.prevalidated('${Dc.namespace}source');

  /// IRI for dc:language
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/language/)
  ///
  /// A language of the resource.
  static const language = IriTerm.prevalidated('${Dc.namespace}language');

  /// IRI for dc:relation
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/relation/)
  ///
  /// A related resource.
  static const relation = IriTerm.prevalidated('${Dc.namespace}relation');

  /// IRI for dc:coverage
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/coverage/)
  ///
  /// The spatial or temporal topic of the resource, the spatial applicability of the resource,
  /// or the jurisdiction under which the resource is relevant.
  static const coverage = IriTerm.prevalidated('${Dc.namespace}coverage');

  /// IRI for dc:rights
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/terms/rights/)
  ///
  /// Information about rights held in and over the resource.
  static const rights = IriTerm.prevalidated('${Dc.namespace}rights');
}
