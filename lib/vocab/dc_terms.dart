/// Dublin Core Terms Vocabulary
///
/// Provides constants for the [Dublin Core Terms vocabulary](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/).
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/vocab/dc_terms.dart';
/// final creator = DcTermsPredicates.creator;
/// ```
library dc_terms_vocab;

import 'package:rdf_core/graph/rdf_term.dart';

/// Dublin Core Terms namespace and basic utility functions
class DcTerms {
  const DcTerms._();

  /// Base IRI for Dublin Core Terms vocabulary
  static const String namespace = 'http://purl.org/dc/terms/';
  static const String prefix = 'dcterms';
}

/// Dublin Core Terms predicate constants
///
/// Contains IRIs for commonly used Dublin Core Terms properties.
class DcTermsPredicates {
  const DcTermsPredicates._();

  /// IRI for dcterms:created property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/created)
  static const created = IriTerm.prevalidated('${DcTerms.namespace}created');

  /// IRI for dcterms:creator property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/creator)
  static const creator = IriTerm.prevalidated('${DcTerms.namespace}creator');

  /// IRI for dcterms:modified property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/modified)
  static const modified = IriTerm.prevalidated('${DcTerms.namespace}modified');
}
