/// JSON-LD RDF Format - Linked Data in JSON
///
/// This file defines the implementation of JSON-LD (JavaScript Object Notation for Linked Data)
/// serialization format for RDF data. JSON-LD enables the expression of linked data using
/// standard JSON syntax, making it both web-friendly and developer-friendly.
library jsonld_format;

import '../graph/rdf_graph.dart';
import '../plugin/format_plugin.dart';
import '../../rdf_parser.dart';
import '../../rdf_serializer.dart';
import 'jsonld_parser.dart';
import 'jsonld_serializer.dart';

/// RDF Format implementation for the JSON-LD serialization format.
///
/// JSON-LD (JavaScript Object Notation for Linked Data) is a method of encoding
/// Linked Data using JSON. It was designed to be easy for humans to read and write,
/// while providing a way to represent RDF data in the widely-used JSON format.
///
/// ## JSON-LD Key Concepts
///
/// JSON-LD extends JSON with several special keywords (always prefixed with @):
///
/// - **@context**: Maps terms to IRIs and defines data types for values
///   - Enables shorthand property names in place of full IRIs
///   - Specifies how to interpret values (strings, numbers, dates, etc.)
///
/// - **@id**: Uniquely identifies a node (equivalent to the subject in RDF)
///
/// - **@type**: Indicates the resource's type (equivalent to rdf:type)
///
/// - **@graph**: Contains a set of nodes in a named graph
///
/// ## Example JSON-LD Document
///
/// ```json
/// {
///   "@context": {
///     "name": "http://xmlns.com/foaf/0.1/name",
///     "knows": {
///       "@id": "http://xmlns.com/foaf/0.1/knows",
///       "@type": "@id"
///     },
///     "born": {
///       "@id": "http://example.org/born",
///       "@type": "http://www.w3.org/2001/XMLSchema#date"
///     }
///   },
///   "@id": "http://example.org/john",
///   "name": "John Smith",
///   "born": "1980-03-15",
///   "knows": [
///     {
///       "@id": "http://example.org/jane",
///       "name": "Jane Doe"
///     }
///   ]
/// }
/// ```
///
/// ## Benefits of JSON-LD
///
/// - Uses standard JSON syntax, familiar to web developers
/// - Compatible with existing JSON APIs and tools
/// - Designed to integrate easily with the web (HTTP, REST)
/// - Can express complex RDF data models in a human-readable form
/// - Supports framing, compaction, and expansion operations
///
/// ## File Extension and MIME Types
///
/// JSON-LD files typically use the `.jsonld` file extension.
/// The primary MIME type is `application/ld+json`.
final class JsonLdFormat implements RdfFormat {
  static const _primaryMimeType = 'application/ld+json';

  /// All MIME types that this format implementation can handle
  static const _supportedMimeTypes = {_primaryMimeType, 'application/json+ld'};

  /// Creates a new JSON-LD format handler
  const JsonLdFormat();

  @override
  String get primaryMimeType => _primaryMimeType;

  @override
  Set<String> get supportedMimeTypes => _supportedMimeTypes;

  @override
  RdfParser createParser() => _JsonLdParserAdapter();

  @override
  RdfSerializer createSerializer() => JsonLdSerializer();

  @override
  bool canParse(String content) {
    // Simple heuristics for detecting JSON-LD format
    final trimmed = content.trim();

    // Must be valid JSON (starts with { or [)
    if (!(trimmed.startsWith('{') || trimmed.startsWith('['))) {
      return false;
    }

    // Must contain at least one of these JSON-LD keywords
    return trimmed.contains('"@context"') ||
        trimmed.contains('"@id"') ||
        trimmed.contains('"@type"') ||
        trimmed.contains('"@graph"');
  }
}

/// Parser adapter for JSON-LD format
///
/// Internal adapter that bridges the RdfParser interface to the
/// implementation-specific JsonLdParser.
class _JsonLdParserAdapter implements RdfParser {
  @override
  RdfGraph parse(String input, {String? documentUrl}) {
    final parser = JsonLdParser(input, baseUri: documentUrl);
    return RdfGraph.fromTriples(parser.parse());
  }
}
