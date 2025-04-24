/// RDF Format Plugin System - Extensible support for RDF serialization formats
///
/// This file defines the plugin architecture that enables the RDF library to support
/// multiple serialization formats through a unified API. It implements the Strategy pattern
/// to allow different parsing and serialization strategies to be selected at runtime.
///
/// The plugin system allows:
/// - Registration of format implementations (Turtle, JSON-LD, etc.)
/// - Format auto-detection based on content
/// - Format selection based on MIME type
/// - A unified API for parsing and serialization regardless of format
library format_plugin;

import 'package:logging/logging.dart';

import '../graph/rdf_graph.dart';
import '../rdf_parser.dart';
import '../rdf_serializer.dart';

/// Represents a content format that can be handled by the RDF framework.
///
/// A format plugin encapsulates all the logic needed to work with a specific
/// RDF serialization format (like Turtle, JSON-LD, RDF/XML, etc.). It provides
/// both parsing and serialization capabilities for the format.
///
/// To add support for a new RDF format, implement this interface and register
/// an instance with the RdfFormatRegistry.
///
/// Example of implementing a new format:
/// ```dart
/// class MyCustomFormat implements RdfFormat {
///   @override
///   String get primaryMimeType => 'application/x-custom-rdf';
///
///   @override
///   Set<String> get supportedMimeTypes => {primaryMimeType};
///
///   @override
///   RdfParser createParser() => MyCustomParser();
///
///   @override
///   RdfSerializer createSerializer() => MyCustomSerializer();
///
///   @override
///   bool canParse(String content) {
///     // Check if the content appears to be in this format
///     return content.contains('CUSTOM-RDF-FORMAT');
///   }
/// }
/// ```
abstract interface class RdfFormat {
  /// The primary MIME type for this format
  ///
  /// This is the canonical MIME type used to identify the format,
  /// typically the one registered with IANA.
  String get primaryMimeType;

  /// All MIME types supported by this format
  ///
  /// Some formats may have multiple MIME types associated with them,
  /// including older or deprecated ones. This set should include all
  /// MIME types that the format implementation can handle.
  Set<String> get supportedMimeTypes;

  /// Creates a parser instance for this format
  ///
  /// Returns a new instance of a parser that can convert text in this format
  /// to an RdfGraph object.
  RdfParser createParser();

  /// Creates a serializer instance for this format
  ///
  /// Returns a new instance of a serializer that can convert an RdfGraph
  /// to text in this format.
  RdfSerializer createSerializer();

  /// Tests if the provided content is likely in this format
  ///
  /// This method is used for format auto-detection when no explicit MIME type
  /// is available. It should perform quick heuristic checks to determine if
  /// the content appears to be in the format supported by this plugin.
  ///
  /// The method should balance accuracy with performance - it should not
  /// perform a full parse, but should do enough checking to make a reasonable
  /// determination.
  ///
  /// @param content The string content to check
  /// @return true if the content appears to be in this format
  bool canParse(String content);
}

/// Manages registration and discovery of RDF format plugins.
///
/// This registry acts as the central point for format plugin management, providing
/// a mechanism for plugin registration, discovery, and format auto-detection.
/// It implements a plugin system that allows the core RDF library to be extended
/// with additional serialization formats.
///
/// Example usage:
/// ```dart
/// // Create a registry
/// final registry = RdfFormatRegistry();
///
/// // Register format plugins
/// registry.registerFormat(const TurtleFormat());
/// registry.registerFormat(const JsonLdFormat());
///
/// // Get a parser for a specific MIME type
/// final turtleParser = registry.getParser('text/turtle');
///
/// // Or let the system detect the format
/// final autoParser = registry.getParser(null); // Will auto-detect
/// ```
final class RdfFormatRegistry {
  final _logger = Logger('rdf.format_registry');
  final Map<String, RdfFormat> _formatsByMimeType = {};
  final List<RdfFormat> _formats = [];

  /// Creates a new format registry
  ///
  /// The registry starts empty, with no formats registered.
  /// Format implementations must be registered using the registerFormat method.
  RdfFormatRegistry();

  /// Register a new format with the registry
  ///
  /// This will make the format available for parsing and serialization
  /// when requested by any of its supported MIME types. The format will also
  /// be considered during auto-detection of unknown content.
  ///
  /// @param format The format implementation to register
  void registerFormat(RdfFormat format) {
    _logger.fine('Registering format: ${format.primaryMimeType}');
    _formats.add(format);

    for (final mimeType in format.supportedMimeTypes) {
      final normalized = _normalizeMimeType(mimeType);
      _formatsByMimeType[normalized] = format;
    }
  }

  /// Retrieves a format instance by MIME type
  ///
  /// Looks up and returns a registered format that supports the given MIME type.
  ///
  /// @param mimeType The MIME type to look up
  /// @return The format implementation supporting this MIME type, or null if none found
  RdfFormat? getFormat(String? mimeType) {
    if (mimeType == null) return null;
    return _formatsByMimeType[_normalizeMimeType(mimeType)];
  }

  /// Retrieves all registered formats
  ///
  /// Returns an unmodifiable list of all format implementations currently registered.
  /// This can be useful for iterating through available formats or for diagnostics.
  ///
  /// @return An unmodifiable list of all registered formats
  List<RdfFormat> getAllFormats() => List.unmodifiable(_formats);

  /// Detect format from content when no MIME type is available
  ///
  /// Attempts to identify the format by examining the content structure.
  /// Each registered format is asked if it can parse the content, and the
  /// first one that responds positively is returned.
  ///
  /// @param content The content string to analyze
  /// @return The first format that claims it can parse the content, or null if none found
  RdfFormat? detectFormat(String content) {
    _logger.fine('Attempting to detect format from content');

    for (final format in _formats) {
      if (format.canParse(content)) {
        _logger.fine('Detected format: ${format.primaryMimeType}');
        return format;
      }
    }

    _logger.fine('No format detected');
    return null;
  }

  /// Get a parser for a specific MIME type
  ///
  /// Returns a parser appropriate for the requested MIME type. If no MIME type
  /// is specified or no matching format is found, returns a special parser that
  /// attempts to auto-detect the format from the content.
  ///
  /// This method will never return null - if no suitable parser is found, it
  /// returns a parser that will attempt detection during the parse operation.
  ///
  /// @param mimeType Optional MIME type to specify the format to parse
  /// @return A parser for the requested format, or an auto-detecting parser
  RdfParser getParser(String? mimeType) {
    final format = getFormat(mimeType);
    if (format != null) {
      return format.createParser();
    }

    // No specific format found, return a detecting parser
    return FormatDetectingParser(this);
  }

  /// Get a serializer for a specific MIME type
  ///
  /// Returns a serializer for the requested MIME type. If no MIME type is specified,
  /// returns a serializer for the default format (the first one registered).
  ///
  /// Unlike getParser, this method may throw an exception if no matching format
  /// is found, since auto-detection isn't applicable for serialization.
  ///
  /// @param mimeType Optional MIME type to specify the format to serialize to
  /// @return A serializer for the requested format
  /// @throws FormatNotSupportedException if no matching format is found
  RdfSerializer getSerializer(String? mimeType) {
    if (mimeType == null) {
      // Use the first registered format as default
      if (_formats.isNotEmpty) {
        return _formats.first.createSerializer();
      }
      throw FormatNotSupportedException('No formats registered');
    }

    final format = getFormat(mimeType);
    if (format == null) {
      throw FormatNotSupportedException(
        'No serializer available for MIME type: $mimeType',
      );
    }

    return format.createSerializer();
  }

  /// Helper method to normalize MIME types for consistent lookup
  ///
  /// Ensures that MIME types are compared case-insensitively and without
  /// extraneous whitespace.
  ///
  /// @param mimeType The MIME type string to normalize
  /// @return The normalized MIME type string
  static String _normalizeMimeType(String mimeType) {
    return mimeType.trim().toLowerCase();
  }

  /// Clear all registered formats (mainly for testing)
  ///
  /// Removes all registered formats from the registry. This is primarily
  /// useful for unit testing to ensure a clean state.
  void clear() {
    _formats.clear();
    _formatsByMimeType.clear();
  }
}

/// Exception thrown when an attempt is made to use an unsupported format
///
/// This exception is thrown when:
/// - A serializer is requested for an unregistered MIME type
/// - No formats are registered when a serializer is requested
/// - Auto-detection fails to identify a usable format for parsing
class FormatNotSupportedException implements Exception {
  /// Error message describing the problem
  final String message;

  /// Creates a new format not supported exception
  ///
  /// @param message A description of why the format is not supported
  FormatNotSupportedException(this.message);

  @override
  String toString() => 'FormatNotSupportedException: $message';
}

/// A parser that detects the format from content and delegates to the appropriate parser
///
/// This specialized parser implements the auto-detection mechanism used when
/// no specific format is specified. It attempts to determine the format from
/// the content and then delegates to the appropriate parser implementation.
///
/// This class is primarily used internally by the RdfFormatRegistry and is not
/// typically instantiated directly by library users.
final class FormatDetectingParser implements RdfParser {
  final _logger = Logger('rdf.format_detecting_parser');
  final RdfFormatRegistry _registry;

  /// Creates a new format-detecting parser
  ///
  /// @param registry The format registry to use for detection and parser creation
  FormatDetectingParser(this._registry);

  @override
  RdfGraph parse(String input, {String? documentUrl}) {
    final format = _registry.detectFormat(input);

    if (format != null) {
      _logger.fine('Using detected format: ${format.primaryMimeType}');
      return format.createParser().parse(input, documentUrl: documentUrl);
    }

    // If we can't detect, try the first available format
    final formats = _registry.getAllFormats();
    if (formats.isEmpty) {
      throw FormatNotSupportedException('No RDF formats registered');
    }

    // Try each format in sequence until one works
    Exception? lastException;
    for (final format in formats) {
      try {
        _logger.fine('Trying format: ${format.primaryMimeType}');
        return format.createParser().parse(input, documentUrl: documentUrl);
      } catch (e) {
        _logger.fine('Failed with format ${format.primaryMimeType}: $e');
        lastException = e is Exception ? e : Exception(e.toString());
      }
    }

    throw FormatNotSupportedException(
      'Could not parse content with any registered format: ${lastException?.toString() ?? "unknown error"}',
    );
  }
}
