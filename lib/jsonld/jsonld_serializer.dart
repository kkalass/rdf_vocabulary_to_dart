/// JSON-LD Serializer Implementation
///
/// Implements the [JsonLdSerializer] class to convert RDF graphs to JSON-LD format.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/jsonld/jsonld_serializer.dart';
/// final serializer = JsonLdSerializer();
/// final jsonld = serializer.write(graph);
/// ```
///
/// See: [JSON-LD 1.1 Specification](https://www.w3.org/TR/json-ld11/)
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:rdf_core/constants/rdf_constants.dart';
import 'package:rdf_core/constants/xsd_constants.dart';
import 'package:rdf_core/graph/rdf_graph.dart';
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/graph/triple.dart';
import 'package:rdf_core/rdf_serializer.dart';

final _log = Logger("rdf.jsonld");

/// Serializer for converting RDF graphs to JSON-LD format.
///
/// JSON-LD is a lightweight Linked Data format that is easy for humans to read
/// and write and easy for machines to parse and generate. This serializer
/// transforms RDF data into compact, structured JSON documents by:
///
/// - Grouping triples by subject
/// - Creating a @context section for namespace prefixes
/// - Nesting objects for more readable representation
/// - Handling different RDF term types appropriately
///
/// The serializer produces compacted JSON-LD by default, using prefixes
/// to make property names more readable.
final class JsonLdSerializer implements RdfSerializer {
  /// Well-known common prefixes used for more readable JSON-LD output.
  static const Map<String, String> _commonPrefixes = {
    'rdf': 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
    'rdfs': 'http://www.w3.org/2000/01/rdf-schema#',
    'xsd': 'http://www.w3.org/2001/XMLSchema#',
    'owl': 'http://www.w3.org/2002/07/owl#',
    'foaf': 'http://xmlns.com/foaf/0.1/',
    'dc': 'http://purl.org/dc/elements/1.1/',
    'dcterms': 'http://purl.org/dc/terms/',
    'schema': 'http://schema.org/',
    'solid': 'http://www.w3.org/ns/solid/terms#',
    'acl': 'http://www.w3.org/ns/auth/acl#',
    'ldp': 'http://www.w3.org/ns/ldp#',
  };

  /// Creates a new JSON-LD serializer.
  JsonLdSerializer();

  @override
  String write(
    RdfGraph graph, {
    String? baseUri,
    Map<String, String> customPrefixes = const {},
  }) {
    _log.info('Serializing graph to JSON-LD');

    // Return empty JSON object for empty graph
    if (graph.isEmpty) {
      return '{}';
    }

    // Create context with prefixes
    final context = _createContext(graph, customPrefixes);

    // Group triples by subject
    final subjectGroups = _groupTriplesBySubject(graph.triples);

    // Check if we have only one subject group or multiple
    // For a single subject we create a JSON object, for multiple we use a JSON array
    if (subjectGroups.length == 1) {
      final Map<String, dynamic> result = {'@context': context};

      // Add the single subject node
      final entry = subjectGroups.entries.first;
      final subjectNode = _createNodeObject(entry.key, entry.value, context);
      result.addAll(subjectNode);

      return JsonEncoder.withIndent('  ').convert(result);
    } else {
      // Create a @graph structure for multiple subjects
      final Map<String, dynamic> result = {
        '@context': context,
        '@graph':
            subjectGroups.entries.map((entry) {
              return _createNodeObject(entry.key, entry.value, context);
            }).toList(),
      };

      return JsonEncoder.withIndent('  ').convert(result);
    }
  }

  /// Creates the @context object with prefix mappings.
  Map<String, String> _createContext(
    RdfGraph graph,
    Map<String, String> customPrefixes,
  ) {
    final context = <String, String>{};

    // Add all custom prefixes
    context.addAll(customPrefixes);

    // Add common prefixes that are used in the graph
    final allPrefixes = {..._commonPrefixes, ...customPrefixes};
    final usedPrefixes = _extractUsedPrefixes(graph, allPrefixes);

    // Add prefixes that don't conflict with custom ones
    for (final entry in usedPrefixes.entries) {
      if (!customPrefixes.containsKey(entry.key)) {
        context[entry.key] = entry.value;
      }
    }

    return context;
  }

  /// Extracts only those prefixes that are actually used in the graph's triples.
  Map<String, String> _extractUsedPrefixes(
    RdfGraph graph,
    Map<String, String> prefixCandidates,
  ) {
    final usedPrefixes = <String, String>{};

    // Create an inverted index for quick lookup
    final iriToPrefixMap = Map<String, String>.fromEntries(
      prefixCandidates.entries.map((e) => MapEntry(e.value, e.key)),
    );

    for (final triple in graph.triples) {
      // Check subject
      if (triple.subject is IriTerm) {
        _checkTermForPrefix(
          triple.subject as IriTerm,
          iriToPrefixMap,
          usedPrefixes,
          prefixCandidates,
        );
      }

      // Check predicate
      if (triple.predicate is IriTerm) {
        _checkTermForPrefix(
          triple.predicate as IriTerm,
          iriToPrefixMap,
          usedPrefixes,
          prefixCandidates,
        );
      }

      // Check object
      if (triple.object is IriTerm) {
        _checkTermForPrefix(
          triple.object as IriTerm,
          iriToPrefixMap,
          usedPrefixes,
          prefixCandidates,
        );
      } else if (triple.object is LiteralTerm) {
        final literal = triple.object as LiteralTerm;
        if (literal.datatype != XsdConstants.stringIri) {
          _checkTermForPrefix(
            literal.datatype,
            iriToPrefixMap,
            usedPrefixes,
            prefixCandidates,
          );
        }
      }
    }

    return usedPrefixes;
  }

  /// Checks if a term's IRI matches any prefix and adds it to the usedPrefixes if it does.
  void _checkTermForPrefix(
    IriTerm term,
    Map<String, String> iriToPrefixMap,
    Map<String, String> usedPrefixes,
    Map<String, String> prefixCandidates,
  ) {
    final iri = term.iri;

    // First try direct match (for namespaces that are used completely)
    if (iriToPrefixMap.containsKey(iri)) {
      final prefix = iriToPrefixMap[iri]!;
      usedPrefixes[prefix] = iri;
      return;
    }

    // For prefix match, use the longest matching prefix (most specific)
    // This handles overlapping prefixes correctly (e.g., http://example.org/ and http://example.org/vocabulary/)
    var bestMatch = '';
    var bestPrefix = '';

    for (final entry in prefixCandidates.entries) {
      final namespace = entry.value;
      if (iri.startsWith(namespace) && namespace.length > bestMatch.length) {
        bestMatch = namespace;
        bestPrefix = entry.key;
      }
    }

    if (bestPrefix.isNotEmpty) {
      usedPrefixes[bestPrefix] = bestMatch;
    }
  }

  /// Groups triples by their subject for easier JSON-LD structure creation.
  Map<RdfSubject, List<Triple>> _groupTriplesBySubject(List<Triple> triples) {
    final Map<RdfSubject, List<Triple>> result = {};

    for (final triple in triples) {
      result.putIfAbsent(triple.subject, () => []).add(triple);
    }

    return result;
  }

  /// Creates a JSON object representing an RDF node with all its properties.
  Map<String, dynamic> _createNodeObject(
    RdfSubject subject,
    List<Triple> triples,
    Map<String, String> context,
  ) {
    final result = <String, dynamic>{'@id': _getSubjectId(subject)};

    // Group triples by predicate
    final predicateGroups = <String, List<RdfObject>>{};
    final typeObjects = <RdfObject>[];

    for (final triple in triples) {
      if (triple.predicate == RdfConstants.typeIri) {
        // Handle rdf:type specially
        typeObjects.add(triple.object);
      } else {
        final predicateKey = _getPredicateKey(triple.predicate, context);
        predicateGroups.putIfAbsent(predicateKey, () => []).add(triple.object);
      }
    }

    // Add types to the result
    if (typeObjects.isNotEmpty) {
      if (typeObjects.length == 1) {
        // Single type
        result['@type'] = _getObjectValue(typeObjects[0]);
      } else {
        // Multiple types
        result['@type'] = typeObjects.map(_getObjectValue).toList();
      }
    }

    // Add other predicates to the result
    for (final entry in predicateGroups.entries) {
      if (entry.value.length == 1) {
        // Single value for predicate
        result[entry.key] = _getObjectValue(entry.value[0]);
      } else {
        // Multiple values for predicate
        result[entry.key] = entry.value.map(_getObjectValue).toList();
      }
    }

    return result;
  }

  /// Returns the appropriate string ID for a subject term.
  String _getSubjectId(RdfSubject subject) {
    if (subject is IriTerm) {
      return subject.iri;
    } else if (subject is BlankNodeTerm) {
      return '_:${subject.label}';
    } else {
      return subject.toString();
    }
  }

  /// Returns the appropriate key name for a predicate.
  /// Uses prefixed notation when a matching prefix is available in the context.
  String _getPredicateKey(RdfPredicate predicate, Map<String, String> context) {
    if (predicate is! IriTerm) {
      return predicate.toString();
    }

    final iri = predicate.iri;

    // Find the longest (most specific) matching prefix in the context
    var bestMatch = '';
    var bestPrefix = '';

    for (final entry in context.entries) {
      final prefix = entry.key;
      final namespace = entry.value;

      if (iri.startsWith(namespace) && namespace.length > bestMatch.length) {
        bestMatch = namespace;
        bestPrefix = prefix;
      }
    }

    // If we found a matching prefix, use it to compact the IRI
    if (bestPrefix.isNotEmpty) {
      final localName = iri.substring(bestMatch.length);
      if (localName.isNotEmpty) {
        return '$bestPrefix:$localName';
      } else {
        return '$bestPrefix:';
      }
    }

    // If no prefix matches, use the full IRI
    return iri;
  }

  /// Converts an RDF object to its appropriate JSON-LD representation.
  dynamic _getObjectValue(RdfObject object) {
    if (object is IriTerm) {
      return {'@id': object.iri};
    } else if (object is BlankNodeTerm) {
      return {'@id': '_:${object.label}'};
    } else if (object is LiteralTerm) {
      return _getLiteralValue(object);
    } else {
      return object.toString();
    }
  }

  /// Converts an RDF literal to its appropriate JSON-LD representation.
  dynamic _getLiteralValue(LiteralTerm literal) {
    final value = literal.value;

    // Handle language-tagged strings
    if (literal.language != null) {
      return {'@value': value, '@language': literal.language};
    }

    // Handle different datatypes
    final datatype = literal.datatype;

    // String literals (default datatype)
    if (datatype == XsdConstants.stringIri) {
      return value;
    }

    // Number literals
    if (datatype == XsdConstants.integerIri) {
      return int.tryParse(value) ?? {'@value': value, '@type': datatype.iri};
    }

    if (datatype == XsdConstants.doubleIri ||
        datatype == XsdConstants.decimalIri) {
      return double.tryParse(value) ?? {'@value': value, '@type': datatype.iri};
    }

    // Boolean literals
    if (datatype == XsdConstants.booleanIri) {
      if (value == 'true') return true;
      if (value == 'false') return false;
      return {'@value': value, '@type': datatype.iri};
    }

    // Other typed literals
    return {'@value': value, '@type': datatype.iri};
  }
}
