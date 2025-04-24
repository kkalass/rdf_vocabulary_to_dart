/// RDF Parser Framework - Components for parsing RDF data in various formats
///
/// This file defines the interfaces and implementations related to parsing RDF data
/// from various serialization formats. It provides a common parsing API regardless
/// of the underlying serialization format.
library rdf_parser;

import 'package:logging/logging.dart';

import 'graph/rdf_graph.dart';
import 'plugin/format_plugin.dart';

/// Interface for parsing RDF documents in various formats
///
/// This interface abstracts the parsing process for different RDF serializations
/// (such as Turtle, JSON-LD, RDF/XML, etc.) to provide a common parsing API.
/// Each format implements this interface to handle its specific syntax rules.
///
/// Format-specific parsers should implement this interface to be used with the
/// RDF library's parsing framework.
abstract interface class RdfParser {
  /// Parse an RDF document and return an RDF graph
  ///
  /// This method transforms a textual RDF document into a structured RdfGraph object
  /// containing triples parsed from the input.
  ///
  /// Parameters:
  /// - [input] is the RDF document to parse, as a string.
  /// - [documentUrl] is the absolute URL of the document, used for resolving relative IRIs.
  ///   If not provided, relative IRIs will be kept as-is or handled according to format-specific rules.
  ///
  /// Returns:
  /// - An [RdfGraph] containing the triples parsed from the input.
  ///
  /// The specific parsing behavior depends on the implementation of this interface,
  /// which will handle format-specific details like prefix resolution, blank node handling, etc.
  RdfGraph parse(String input, {String? documentUrl});
}

/// Interface for parser factories that create RDF parser instances
///
/// This interface defines the contract for factories that can create parsers
/// for different RDF serialization formats.
abstract interface class RdfParserFactoryBase {
  /// Creates a specialized RdfParser for a specific format.
  ///
  /// The factory selects the appropriate parser based on the content type.
  /// If no content type is provided, it should return a parser that can auto-detect
  /// the format from the input.
  ///
  /// Parameters:
  /// - [contentType] MIME type that determines which parser to create (e.g., "text/turtle").
  ///   If null, returns an auto-detecting parser.
  ///
  /// Returns:
  /// - An [RdfParser] instance for the specified content type.
  ///
  /// Throws:
  /// - [FormatNotSupportedException] if the requested format is not supported.
  RdfParser createParser({String? contentType});

  /// Directly parse an RDF document
  ///
  /// Convenience method that creates a parser and uses it to parse the input.
  /// This simplifies the common case where the caller just wants to parse a document
  /// without managing parser instances.
  ///
  /// Parameters:
  /// - [input] RDF document to parse, as a string.
  /// - [contentType] Optional MIME type to specify the format (e.g., "text/turtle").
  /// - [documentUrl] Optional base URL for resolving relative IRIs in the document.
  ///
  /// Returns:
  /// - An [RdfGraph] containing the triples parsed from the input.
  RdfGraph parse(String input, {String? contentType, String? documentUrl});
}

/// Factory for creating RDF parsers based on content type.
///
/// This class implements the Factory pattern to create appropriate RdfParser implementations
/// based on content type. It delegates the actual parser creation to a format registry
/// that maintains the mapping between MIME types and format implementations.
///
/// Example usage:
/// ```dart
/// final registry = RdfFormatRegistry();
/// registry.registerFormat(const TurtleFormat());
/// registry.registerFormat(const JsonLdFormat());
///
/// final factory = RdfParserFactory(registry);
///
/// // Create a parser for a specific format
/// final turtleParser = factory.createParser(contentType: 'text/turtle');
///
/// // Or parse directly
/// final graph = factory.parse(turtleData, contentType: 'text/turtle');
/// ```
final class RdfParserFactory implements RdfParserFactoryBase {
  final _logger = Logger("rdf.parser.factory");
  final RdfFormatRegistry _registry;

  /// Creates a new parser factory using the specified registry
  ///
  /// The registry provides the format implementations that this factory can use
  /// to create parsers for different content types.
  ///
  /// Parameters:
  /// - [registry] The format registry containing available RDF format implementations.
  RdfParserFactory(this._registry);

  @override
  RdfParser createParser({String? contentType}) {
    _logger.fine(
      'Creating parser for content type: ${contentType ?? "auto-detect"}',
    );
    return _registry.getParser(contentType);
  }

  @override
  RdfGraph parse(String input, {String? contentType, String? documentUrl}) {
    final parser = createParser(contentType: contentType);
    return parser.parse(input, documentUrl: documentUrl);
  }
}
