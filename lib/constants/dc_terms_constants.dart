/// Dublin Core Terms Constants
library dc_terms_constants;
///
/// Provides constants for the [Dublin Core Terms vocabulary](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/).
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/constants/dc_terms_constants.dart';
/// final creator = DcTermsConstants.creatorIri;
/// ```
import 'package:rdf_core/graph/rdf_term.dart';

/// Dublin Core Terms namespace constants
class DcTermsConstants {
  const DcTermsConstants._();

  /// Base IRI for Dublin Core Terms vocabulary
  static const String namespace = 'http://purl.org/dc/terms/';

  /// IRI for dcterms:created property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/created)
  static const createdIri = IriTerm('${namespace}created');

  /// IRI for dcterms:creator property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/creator)
  static const creatorIri = IriTerm('${namespace}creator');

  /// IRI for dcterms:modified property
  /// [Spec](https://www.dublincore.org/specifications/dublin-core/dcmi-terms/#http://purl.org/dc/terms/modified)
  static const modifiedIri = IriTerm('${namespace}modified');
}
