/// RDF Serialization Framework - Components for writing RDF data in various formats
///
/// This file defines interfaces and implementations for serializing RDF data
/// from in-memory graph structures to various text-based serialization formats.
/// It complements the parser framework by providing the reverse operation.
library rdf_serializer;

import 'graph/rdf_graph.dart';
import 'plugin/format_plugin.dart';

/// Interface for writing RDF graphs to different serialization formats.
///
/// This interface defines the contract for serializing RDF graphs into textual
/// representations using various formats like Turtle, JSON-LD, etc. It's part of
/// the Strategy pattern implementation that allows the library to support multiple
/// serialization formats.
///
/// Format-specific serializers should implement this interface to be registered
/// with the RDF library's serialization framework.
///
/// Serializers are responsible for:
/// - Determining how to represent triples in their specific format
/// - Handling namespace prefixes and base URIs
/// - Applying format-specific optimizations for readability or size
abstract interface class RdfSerializer {
  /// Serializes an RDF graph to a string representation in a specific format.
  ///
  /// Transforms an in-memory RDF graph into a serialized text format that can be
  /// stored or transmitted. The exact output format depends on the implementing class.
  ///
  /// Parameters:
  /// - [graph] The RDF graph to serialize.
  /// - [baseUri] Optional base URI for resolving/shortening IRIs in the output.
  ///   When provided, the serializer may use this to produce more compact output.
  /// - [customPrefixes] Optional map of prefix to namespace mappings to use in serialization.
  ///   Allows caller-specified namespace abbreviations for readable output.
  ///
  /// Returns:
  /// - The serialized representation of the graph as a string.
  String write(
    RdfGraph graph, {
    String? baseUri,
    Map<String, String> customPrefixes = const {},
  });
}

/// Interface for serializer factories that create RDF serializer instances
///
/// This interface defines the contract for factories that create serializers
/// for different RDF serialization formats. It follows the Abstract Factory pattern,
/// providing a way to create related serializer objects without specifying their
/// concrete classes.
abstract interface class RdfSerializerFactoryBase {
  /// Creates an RdfSerializer for the specified content type.
  ///
  /// The factory selects and instantiates an appropriate serializer based on
  /// the requested MIME type.
  ///
  /// Parameters:
  /// - [contentType] MIME type that determines which serializer to use (e.g., "text/turtle").
  ///   If null, uses the default serializer (typically the first registered format).
  ///
  /// Returns:
  /// - An [RdfSerializer] instance for the specified content type.
  ///
  /// Throws:
  /// - [FormatNotSupportedException] if no serializer is available for the content type
  RdfSerializer createSerializer({String? contentType});

  /// Directly serialize an RDF graph to the specified format
  ///
  /// Convenience method that creates a serializer and uses it to serialize the graph.
  /// This simplifies the common case where the caller just wants to serialize a graph
  /// without managing serializer instances.
  ///
  /// Parameters:
  /// - [graph] The RDF graph to serialize.
  /// - [contentType] Optional MIME type to specify the output format (e.g., "text/turtle").
  /// - [baseUri] Optional base URI for shortening IRIs in the output.
  /// - [customPrefixes] Optional map of prefix to namespace mappings to use in serialization.
  ///
  /// Returns:
  /// - The serialized representation of the graph as a string.
  ///
  /// Throws:
  /// - [FormatNotSupportedException] if no serializer is available for the content type
  String write(
    RdfGraph graph, {
    String? contentType,
    String? baseUri,
    Map<String, String> customPrefixes = const {},
  });
}

/// Factory for creating RDF serializers based on content type.
///
/// This class implements the Factory pattern to create appropriate RdfSerializer
/// implementations based on the requested content type. It delegates the actual
/// serializer creation to a format registry that maintains the mapping between
/// MIME types and format implementations.
///
/// Example usage:
/// ```dart
/// final registry = RdfFormatRegistry();
/// registry.registerFormat(const TurtleFormat());
/// registry.registerFormat(const JsonLdFormat());
///
/// final factory = RdfSerializerFactory(registry);
///
/// // Create a serializer for a specific format
/// final turtleSerializer = factory.createSerializer(contentType: 'text/turtle');
///
/// // Or serialize directly
/// final turtle = factory.write(
///   graph,
///   contentType: 'text/turtle',
///   customPrefixes: {'foaf': 'http://xmlns.com/foaf/0.1/'}
/// );
/// ```
final class RdfSerializerFactory implements RdfSerializerFactoryBase {
  final RdfFormatRegistry _registry;

  /// Creates a new serializer factory using the specified registry
  ///
  /// The registry provides the format implementations that this factory can use
  /// to create serializers for different content types.
  ///
  /// Parameters:
  /// - [registry] The format registry containing available RDF format implementations.
  RdfSerializerFactory(this._registry);

  @override
  RdfSerializer createSerializer({String? contentType}) {
    return _registry.getSerializer(contentType);
  }

  @override
  String write(
    RdfGraph graph, {
    String? contentType,
    String? baseUri,
    Map<String, String> customPrefixes = const {},
  }) {
    final serializer = createSerializer(contentType: contentType);
    return serializer.write(
      graph,
      baseUri: baseUri,
      customPrefixes: customPrefixes,
    );
  }
}
