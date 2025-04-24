/// RDF Parser Exceptions - Specialized exceptions for RDF parsing operations
///
/// This library defines a hierarchy of exceptions specific to RDF parsing operations,
/// allowing applications to handle different types of parsing errors with fine-grained
/// control. These exceptions provide detailed information about format-specific errors
/// that can occur when parsing RDF documents.
library ext.rdf.core.exceptions.parser;

import 'rdf_exception.dart';

/// Base exception class for all RDF parser-related errors
///
/// This class serves as the parent for all parser-specific exceptions,
/// adding information about which RDF format was being parsed when the
/// error occurred.
///
/// Parser implementations should throw subclasses of this exception for
/// specific error conditions, or this exception directly for general
/// parsing errors.
class RdfParserException extends RdfException {
  /// Format being parsed when the exception occurred
  ///
  /// This typically contains the MIME type (e.g., "text/turtle") or format name
  /// (e.g., "Turtle") of the RDF serialization being parsed.
  final String format;

  /// Creates a new RDF parser exception
  ///
  /// Parameters:
  /// - [message]: Required description of the error
  /// - [format]: Required format being parsed
  /// - [cause]: Optional underlying cause of this exception
  /// - [source]: Optional location information where the error occurred
  const RdfParserException(
    super.message, {
    required this.format,
    super.cause,
    super.source,
  });

  @override
  String toString() {
    return 'RdfParserException($format): $message${source != null ? ' at $source' : ''}${cause != null ? '\nCaused by: $cause' : ''}';
  }
}

/// Exception thrown when the parser encounters syntax errors in the input
///
/// This exception indicates that the input document contains syntax that violates
/// the rules of the RDF serialization format being parsed. These are typically
/// errors in the document itself, not in the parser.
///
/// Examples include:
/// - Missing closing tags or delimiters
/// - Invalid escape sequences in strings
/// - Malformed IRIs
/// - Unexpected tokens
class RdfSyntaxException extends RdfParserException {
  /// Creates a new RDF syntax exception
  ///
  /// Parameters:
  /// - [message]: Required description of the syntax error
  /// - [format]: Required format being parsed
  /// - [cause]: Optional underlying cause of this exception
  /// - [source]: Optional location information where the error occurred
  const RdfSyntaxException(
    super.message, {
    required super.format,
    super.cause,
    super.source,
  });

  @override
  String toString() {
    return 'RdfSyntaxException($format): $message${source != null ? ' at $source' : ''}${cause != null ? '\nCaused by: $cause' : ''}';
  }
}

/// Exception thrown when the parser encounters an unsupported feature
///
/// This exception indicates that the input document uses a feature of the
/// RDF serialization format that is valid according to the specification
/// but not implemented by this parser.
///
/// This differs from a syntax exception in that the document is valid
/// according to the format specification, but contains features beyond
/// what the current implementation supports.
///
/// Examples include:
/// - Advanced language features in Turtle like collections
/// - Complex JSON-LD constructs like context processing
/// - Format extensions or newer specification features
class RdfUnsupportedFeatureException extends RdfParserException {
  /// Feature that is not supported
  ///
  /// A short identifier or name of the feature that is not supported.
  final String feature;

  /// Creates a new unsupported feature exception
  ///
  /// Parameters:
  /// - [message]: Required description of why the feature isn't supported
  /// - [feature]: Required identifier of the unsupported feature
  /// - [format]: Required format being parsed
  /// - [cause]: Optional underlying cause of this exception
  /// - [source]: Optional location information where the error occurred
  const RdfUnsupportedFeatureException(
    super.message, {
    required this.feature,
    required super.format,
    super.cause,
    super.source,
  });

  @override
  String toString() {
    return 'RdfUnsupportedFeatureException($format): $feature - $message${source != null ? ' at $source' : ''}${cause != null ? '\nCaused by: $cause' : ''}';
  }
}

/// Exception thrown when the parser encounters an invalid IRI
///
/// This exception indicates that the input document contains an IRI
/// that doesn't conform to the IRI syntax rules specified in RFC 3987.
///
/// IRIs are fundamental to RDF as they identify resources, so invalid
/// IRIs are treated as a specific error case rather than a general syntax error.
class RdfInvalidIriException extends RdfParserException {
  /// The invalid IRI
  ///
  /// The string representation of the IRI that failed validation.
  final String iri;

  /// Creates a new invalid IRI exception
  ///
  /// Parameters:
  /// - [message]: Required description of why the IRI is invalid
  /// - [iri]: Required string representation of the invalid IRI
  /// - [format]: Required format being parsed
  /// - [cause]: Optional underlying cause of this exception
  /// - [source]: Optional location information where the error occurred
  const RdfInvalidIriException(
    super.message, {
    required this.iri,
    required super.format,
    super.cause,
    super.source,
  });

  @override
  String toString() {
    return 'RdfInvalidIriException($format): Invalid IRI "$iri" - $message${source != null ? ' at $source' : ''}${cause != null ? '\nCaused by: $cause' : ''}';
  }
}
