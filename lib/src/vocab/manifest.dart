// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

/// Defines vocabularies to be generated during the build process.
///
/// Add entries to this map to include additional vocabularies in the generation process.
/// Each entry maps a vocabulary name to its source (URL or file path).
final vocabularyManifest = <String, VocabularySource>{
  'rdf': UrlVocabularySource('http://www.w3.org/1999/02/22-rdf-syntax-ns#'),
  'rdfs': UrlVocabularySource('http://www.w3.org/2000/01/rdf-schema#'),
  'xsd': UrlVocabularySource('http://www.w3.org/2001/XMLSchema#'),
  'owl': UrlVocabularySource('http://www.w3.org/2002/07/owl#'),
  'dc': UrlVocabularySource('http://purl.org/dc/elements/1.1/'),
  'dcterms': UrlVocabularySource('http://purl.org/dc/terms/'),
  'foaf': UrlVocabularySource('http://xmlns.com/foaf/0.1/'),
  'skos': UrlVocabularySource('http://www.w3.org/2004/02/skos/core#'),
  'vcard': UrlVocabularySource('http://www.w3.org/2006/vcard/ns#'),
  'acl': UrlVocabularySource('http://www.w3.org/ns/auth/acl#'),
  'ldp': UrlVocabularySource('http://www.w3.org/ns/ldp#'),
  'schema': UrlVocabularySource('https://schema.org/'),
  'solid': UrlVocabularySource('http://www.w3.org/ns/solid/terms#'),
};

/// Base class for vocabulary sources.
///
/// Provides an abstraction for loading vocabulary content from different sources,
/// such as URLs or local files.
abstract class VocabularySource {
  /// The URI namespace of this vocabulary.
  String get namespace;

  const VocabularySource();

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
    } else if (namespace.endsWith('.rdf') || namespace.endsWith('.xml')) {
      return 'rdf/xml';
    } else {
      // Default to Turtle for most vocabularies
      return 'turtle';
    }
  }
}

/// Vocabulary source that loads from a URL.
class UrlVocabularySource extends VocabularySource {
  @override
  final String namespace;

  const UrlVocabularySource(this.namespace);

  @override
  Future<String> loadContent() async {
    try {
      // Add content negotiation headers for RDF
      final headers = {
        'Accept':
            'text/turtle, application/rdf+xml;q=0.9, application/xml;q=0.8',
      };

      final response = await http.get(Uri.parse(namespace), headers: headers);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load vocabulary from $namespace: ${response.statusCode}',
        );
      }

      return utf8.decode(response.bodyBytes);
    } catch (e) {
      throw Exception('Error loading vocabulary from $namespace: $e');
    }
  }

  @override
  String getFormat() {
    // Try to detect format from content-type header
    // For simplicity, we default to the parent implementation
    return super.getFormat();
  }
}

/// Vocabulary source that loads from a file.
class FileVocabularySource extends VocabularySource {
  final String filePath;

  @override
  final String namespace;

  const FileVocabularySource(this.filePath, this.namespace);

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
        return 'rdf/xml';
      case '.jsonld':
        return 'json-ld';
      case '.n3':
        return 'notation3';
      default:
        return super.getFormat();
    }
  }
}
