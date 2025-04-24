import 'package:rdf_core/graph/rdf_term.dart';

/// Dublin Core Terms namespace constants
class DcTermsConstants {
  const DcTermsConstants._();

  /// Base IRI for Dublin Core Terms vocabulary
  static const String namespace = 'http://purl.org/dc/terms/';

  /// IRI for dcterms:created property
  static const createdIri = IriTerm('${namespace}created');

  /// IRI for dcterms:creator property
  static const creatorIri = IriTerm('${namespace}creator');

  /// IRI for dcterms:modified property
  static const modifiedIri = IriTerm('${namespace}modified');
}
