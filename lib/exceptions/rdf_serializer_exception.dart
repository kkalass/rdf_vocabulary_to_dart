/// RDF Serializer Exceptions - Specialized exceptions for RDF serialization operations
///
/// This library defines exceptions specific to RDF serialization operations,
/// allowing applications to handle errors that occur when converting RDF graphs
/// to specific serialization formats. These exceptions provide detailed information
/// about format-specific limitations and errors that can occur during serialization.
library ext.rdf.core.exceptions.serializer;

import 'rdf_exception.dart';

/// Base exception class for all RDF serialization-related errors
///
/// This class serves as the parent for all serializer-specific exceptions,
/// adding information about which RDF format was the target of serialization
/// when the error occurred.
///
/// Serializer implementations should throw subclasses of this exception for
/// specific error conditions, or this exception directly for general
/// serialization errors.
class RdfSerializerException extends RdfException {
  /// Format being serialized to when the exception occurred
  ///
  /// This typically contains the MIME type (e.g., "text/turtle") or format name
  /// (e.g., "Turtle") of the target RDF serialization.
  final String format;

  /// Creates a new RDF serializer exception
  ///
  /// Parameters:
  /// - [message]: Required description of the error
  /// - [format]: Required target serialization format
  /// - [cause]: Optional underlying cause of this exception
  /// - [source]: Optional location information where the error occurred
  const RdfSerializerException(
    super.message, {
    required this.format,
    super.cause,
    super.source,
  });

  @override
  String toString() {
    return 'RdfSerializerException($format): $message${source != null ? ' at $source' : ''}${cause != null ? '\nCaused by: $cause' : ''}';
  }
}

/// Exception thrown when the serializer cannot represent a feature in the target format
///
/// This exception indicates that the RDF graph contains structures or values that
/// cannot be fully represented in the target serialization format due to limitations
/// of that format or the implementation.
///
/// Unlike parser exceptions, these issues arise not from invalid input but from
/// the limitations of the target format or the serializer implementation.
///
/// Examples include:
/// - RDF constructs that don't have a direct representation in the target format
/// - Complex graph patterns that the serializer doesn't support optimizing
/// - Format-specific limitations (e.g., character set restrictions)
class RdfUnsupportedSerializationFeatureException
    extends RdfSerializerException {
  /// Feature that is not supported
  ///
  /// A short identifier or description of the unsupported feature or construct.
  final String feature;

  /// Creates a new unsupported serialization feature exception
  ///
  /// Parameters:
  /// - [message]: Required explanation of why the feature can't be serialized
  /// - [feature]: Required identifier of the unsupported feature
  /// - [format]: Required target serialization format
  /// - [cause]: Optional underlying cause of this exception
  /// - [source]: Optional location information in the RDF graph
  const RdfUnsupportedSerializationFeatureException(
    super.message, {
    required this.feature,
    required super.format,
    super.cause,
    super.source,
  });

  @override
  String toString() {
    return 'RdfUnsupportedSerializationFeatureException($format): $feature - $message${source != null ? ' at $source' : ''}${cause != null ? '\nCaused by: $cause' : ''}';
  }
}

/// Exception thrown when the graph contains cycles that prevent serialization
///
/// Some RDF formats have limitations with cyclic structures, particularly
/// when using abbreviated syntax. This exception indicates that the graph
/// contains cyclical relationships that prevent effective serialization
/// in the target format.
class RdfCyclicGraphException extends RdfSerializerException {
  /// Creates a new cyclic graph exception
  ///
  /// Parameters:
  /// - [message]: Required explanation of the cycle issue
  /// - [format]: Required target serialization format
  /// - [cause]: Optional underlying cause of this exception
  /// - [source]: Optional location information in the RDF graph
  const RdfCyclicGraphException(
    super.message, {
    required super.format,
    super.cause,
    super.source,
  });

  @override
  String toString() {
    return 'RdfCyclicGraphException($format): $message${source != null ? ' at $source' : ''}${cause != null ? '\nCaused by: $cause' : ''}';
  }
}
