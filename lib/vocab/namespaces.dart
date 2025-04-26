/// RDF Namespace mappings
///
/// Defines standard mappings between RDF namespace prefixes and their corresponding URIs.
/// These mappings are commonly used in RDF serialization formats like Turtle and JSON-LD.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/vocab/namespaces.dart';
///
/// // Get a namespace URI from a prefix
/// final rdfNamespace = rdfNamespaceMappings['rdf']; // http://www.w3.org/1999/02/22-rdf-syntax-ns#
/// ```
library rdf_namespaces;

import 'acl.dart';
import 'dc.dart';
import 'dc_terms.dart';
import 'foaf.dart';
import 'ldp.dart';
import 'owl.dart';
import 'rdf.dart';
import 'rdfs.dart';
import 'schema.dart';
import 'skos.dart';
import 'solid.dart';
import 'vcard.dart';
import 'xsd.dart';

/// Standard mappings between RDF namespace prefixes and their corresponding URIs.
///
/// This constant provides a predefined set of common RDF namespace prefix-to-URI mappings
/// used across RDF serialization formats. These mappings follow common conventions in the
/// semantic web community.
const Map<String, String> rdfNamespaceMappings = {
  Acl.prefix: Acl.namespace,
  Dc.prefix: Dc.namespace,
  DcTerms.prefix: DcTerms.namespace,
  Foaf.prefix: Foaf.namespace,
  Ldp.prefix: Ldp.namespace,
  Owl.prefix: Owl.namespace,
  Rdf.prefix: Rdf.namespace,
  Rdfs.prefix: Rdfs.namespace,
  Schema.prefix: Schema.namespace,
  Skos.prefix: Skos.namespace,
  Solid.prefix: Solid.namespace,
  Vcard.prefix: Vcard.namespace,
  Xsd.prefix: Xsd.namespace,
};
