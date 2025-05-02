// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:logging/logging.dart';

/// Logger for vocabulary sources
final _log = Logger('rdf.vocab.source');

/// Base class for vocabulary sources.
///
/// Provides an abstraction for loading vocabulary content from different sources,
/// such as URLs or local files.
abstract class VocabularySource {
  /// The URI namespace of this vocabulary.
  final String namespace;

  /// Optional set of Turtle parsing flags.
  ///
  /// These flags are passed to the TurtleFormat when parsing Turtle files.
  /// They correspond to the TurtleParsingFlag values from rdf_core.
  final List<String>? parsingFlags;

  const VocabularySource(this.namespace, {this.parsingFlags});

  /// Loads the vocabulary content.
  ///
  /// Returns the content as a string, which will be parsed by the appropriate
  /// format parser. Implementations should handle different content formats
  /// like Turtle, RDF/XML, etc.
  Future<String> loadContent();

  /// Returns the format of the vocabulary content.
  ///
  /// This is used to select the appropriate parser for the content.
  /// Default implementation tries to infer format from namespace.
  String getFormat() {
    // Infer format from namespace or content
    if (namespace.endsWith('.ttl')) {
      return 'turtle';
    } else if (namespace.endsWith('.rdf') ||
        namespace.endsWith('.xml') ||
        namespace.endsWith('.owl')) {
      return 'rdf/xml';
    } else if (namespace.endsWith('.jsonld') || namespace.endsWith('.json')) {
      return 'json-ld';
    } else {
      // Default to Turtle for most vocabularies
      return 'turtle';
    }
  }
}

/// Vocabulary source that loads from a URL.
class UrlVocabularySource extends VocabularySource {
  /// The actual URL to load the vocabulary content from
  final String sourceUrl;

  /// Maximum number of redirects to follow
  final int maxRedirects;

  /// Timeout for HTTP requests in seconds
  final int timeoutSeconds;

  const UrlVocabularySource(
    String namespace, {
    String? sourceUrl,
    this.maxRedirects = 5,
    this.timeoutSeconds = 30,
    List<String>? parsingFlags,
  }) : sourceUrl = sourceUrl ?? namespace,
       super(namespace, parsingFlags: parsingFlags);

  @override
  Future<String> loadContent() async {
    final client = http.Client();
    try {
      // Add content negotiation headers for RDF
      final headers = {
        'Accept':
            'text/turtle, application/rdf+xml;q=0.9, application/ld+json;q=0.8, text/html;q=0.7',
        'User-Agent': 'RDF Vocabulary Builder (Dart/HTTP Client)',
      };

      _log.info(
        'Loading vocabulary from URL: $sourceUrl (namespace: $namespace)',
      );

      final request = http.Request('GET', Uri.parse(sourceUrl));
      request.headers.addAll(headers);

      // Create a custom HTTP client that can handle redirects manually
      final response = await client
          .send(request)
          .timeout(Duration(seconds: timeoutSeconds));

      // Handle redirects manually to avoid issues with server redirects
      if (response.isRedirect && maxRedirects > 0) {
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          _log.info('Following redirect to: $redirectUrl');
          client.close();
          return await UrlVocabularySource(
            namespace,
            sourceUrl: redirectUrl,
            maxRedirects: maxRedirects - 1,
            timeoutSeconds: timeoutSeconds,
            parsingFlags: parsingFlags,
          ).loadContent();
        }
      }

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load vocabulary from $sourceUrl: ${response.statusCode}',
        );
      }

      final bytes = await response.stream.toBytes();

      // Try to determine the correct encoding
      String? charset;
      if (response.headers.containsKey('content-type')) {
        final contentType = response.headers['content-type']!;
        final charsetMatch = RegExp(
          r'charset=([^\s;]+)',
        ).firstMatch(contentType);
        if (charsetMatch != null) {
          charset = charsetMatch.group(1);
        }
      }

      // Detect format from content-type if available
      if (response.headers.containsKey('content-type')) {
        final contentType = response.headers['content-type']!.toLowerCase();
        if (contentType.contains('turtle')) {
          _log.info('Detected Turtle format from Content-Type');
        } else if (contentType.contains('rdf+xml') ||
            contentType.contains('xml')) {
          _log.info('Detected RDF/XML format from Content-Type');
        } else if (contentType.contains('json')) {
          _log.info('Detected JSON format from Content-Type');
        }
      }

      // Try to decode with the specified charset, fallback to UTF-8
      try {
        if (charset != null) {
          return utf8.decode(bytes, allowMalformed: true);
        } else {
          return utf8.decode(bytes);
        }
      } catch (e) {
        // Fallback to Latin-1 (ISO-8859-1) if UTF-8 decoding fails
        _log.warning('UTF-8 decoding failed, trying ISO-8859-1: $e');
        return latin1.decode(bytes);
      }
    } catch (e) {
      throw Exception('Error loading vocabulary from $sourceUrl: $e');
    } finally {
      client.close();
    }
  }

  @override
  String getFormat() {
    // Try to detect format from URL path or extension first
    final uri = Uri.tryParse(sourceUrl);
    if (uri != null && uri.path.isNotEmpty) {
      final extension = path.extension(uri.path).toLowerCase();

      switch (extension) {
        case '.ttl':
          return 'turtle';
        case '.rdf':
        case '.xml':
        case '.owl':
          return 'rdf/xml';
        case '.jsonld':
        case '.json':
          return 'json-ld';
        case '.nt':
          return 'n-triples';
      }
    }

    // For schema.org and similar endpoints, prefer JSON-LD
    if (sourceUrl.contains('schema.org')) {
      return 'json-ld';
    }

    return super.getFormat();
  }
}

/// Vocabulary source that loads from a file.
class FileVocabularySource extends VocabularySource {
  final String filePath;

  const FileVocabularySource(
    this.filePath,
    String namespace, {
    List<String>? parsingFlags,
  }) : super(namespace, parsingFlags: parsingFlags);

  @override
  Future<String> loadContent() async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Vocabulary file not found: $filePath');
      }

      return await file.readAsString();
    } catch (e) {
      throw Exception('Error loading vocabulary from file $filePath: $e');
    }
  }

  @override
  String getFormat() {
    // Detect format from file extension
    final extension = path.extension(filePath).toLowerCase();

    switch (extension) {
      case '.ttl':
        return 'turtle';
      case '.rdf':
      case '.xml':
      case '.owl':
        return 'rdf/xml';
      case '.jsonld':
      case '.json':
        return 'json-ld';
      case '.nt':
        return 'n-triples';
      default:
        return super.getFormat();
    }
  }
}
