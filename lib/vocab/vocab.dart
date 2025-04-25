/// RDF Core Vocabulary Library
library vocab;

///
/// Barrel file exporting all RDF-related vocabulary terms for easy import.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/vocab/vocab.dart';
/// final rdfType = RdfPredicates.type;
/// ```

import 'dc_terms.dart';
import 'rdf.dart';
import 'xsd.dart';

export 'dc_terms.dart';
export 'rdf.dart';
export 'xsd.dart';

const Map<String, String> commonPrefixes = {
  Rdf.prefix: Rdf.namespace,
  'rdfs': 'http://www.w3.org/2000/01/rdf-schema#',
  Xsd.prefix: Xsd.namespace,
  'owl': 'http://www.w3.org/2002/07/owl#',
  'foaf': 'http://xmlns.com/foaf/0.1/',
  'dc': 'http://purl.org/dc/elements/1.1/',
  DcTerms.prefix: DcTerms.namespace,
  'skos': 'http://www.w3.org/2004/02/skos/core#',
  'vcard': 'http://www.w3.org/2006/vcard/ns#',
  'schema': 'http://schema.org/',
  'solid': 'http://www.w3.org/ns/solid/terms#',
  'acl': 'http://www.w3.org/ns/auth/acl#',
  'ldp': 'http://www.w3.org/ns/ldp#',
};
