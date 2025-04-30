// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import '../../../../rdf_core.dart';

/// Logger for vocabulary model operations
final _log = Logger('VocabularyModel');

/// Represents a parsed RDF vocabulary in an intermediate format.
///
/// This model serves as a bridge between the parsed RDF graph and the
/// generated Dart code, providing a structured representation of the
/// vocabulary terms and their properties.
class VocabularyModel {
  /// The name of the vocabulary (e.g., 'rdf', 'xsd')
  final String name;

  /// The namespace IRI of this vocabulary
  final String namespace;

  /// The preferred prefix for this vocabulary
  final String prefix;

  /// Classes defined in this vocabulary
  final List<VocabularyClass> classes;

  /// Properties defined in this vocabulary
  final List<VocabularyProperty> properties;

  /// Datatypes defined in this vocabulary
  final List<VocabularyDatatype> datatypes;

  /// Other terms that don't fit into the above categories
  final List<VocabularyTerm> otherTerms;

  /// Creates a new vocabulary model.
  const VocabularyModel({
    required this.name,
    required this.namespace,
    required this.prefix,
    required this.classes,
    required this.properties,
    required this.datatypes,
    required this.otherTerms,
  });
}

/// Base class for vocabulary terms.
class VocabularyTerm {
  /// The local name of the term (e.g., 'type', 'Class')
  final String localName;

  /// The full IRI of the term
  final String iri;

  /// Human-readable label for the term
  final String? label;

  /// Human-readable description of the term
  final String? comment;

  /// Creates a new vocabulary term.
  const VocabularyTerm({
    required this.localName,
    required this.iri,
    this.label,
    this.comment,
  });
}

/// Represents a class defined in a vocabulary.
class VocabularyClass extends VocabularyTerm {
  /// Parent classes (superclasses) of this class
  final List<String> superClasses;

  /// Creates a new vocabulary class.
  const VocabularyClass({
    required super.localName,
    required super.iri,
    super.label,
    super.comment,
    this.superClasses = const [],
  });
}

/// Represents a property defined in a vocabulary.
class VocabularyProperty extends VocabularyTerm {
  /// The domain (subject class) of this property
  final List<String> domains;

  /// The range (object class or datatype) of this property
  final List<String> ranges;

  /// Creates a new vocabulary property.
  const VocabularyProperty({
    required super.localName,
    required super.iri,
    super.label,
    super.comment,
    this.domains = const [],
    this.ranges = const [],
  });
}

/// Represents a datatype defined in a vocabulary.
class VocabularyDatatype extends VocabularyTerm {
  /// Creates a new vocabulary datatype.
  const VocabularyDatatype({
    required super.localName,
    required super.iri,
    super.label,
    super.comment,
  });
}

/// Utility for extracting vocabulary models from RDF graphs.
class VocabularyModelExtractor {
  /// Extracts a vocabulary model from an RDF graph.
  ///
  /// [graph] The RDF graph containing the vocabulary definition
  /// [namespace] The namespace IRI of the vocabulary
  /// [name] The name to use for the vocabulary
  static VocabularyModel extractFrom(
    RdfGraph graph,
    String namespace,
    String name,
  ) {
    final prefix = _determinePrefix(name);

    final classes = <VocabularyClass>[];
    final properties = <VocabularyProperty>[];
    final datatypes = <VocabularyDatatype>[];
    final otherTerms = <VocabularyTerm>[];

    // Find all resources in the vocabulary namespace
    final vocabResources = _findVocabularyResources(graph, namespace);

    for (final resource in vocabResources) {
      try {
        final iri = resource.iri;
        final localName = _extractLocalName(iri, namespace);
        final label = _findLabel(graph, resource);
        final comment = _findComment(graph, resource);

        if (_isClass(graph, resource)) {
          classes.add(
            VocabularyClass(
              localName: localName,
              iri: iri,
              label: label,
              comment: comment,
              superClasses: _findSuperClasses(graph, resource),
            ),
          );
        } else if (_isProperty(graph, resource)) {
          properties.add(
            VocabularyProperty(
              localName: localName,
              iri: iri,
              label: label,
              comment: comment,
              domains: _findDomains(graph, resource),
              ranges: _findRanges(graph, resource),
            ),
          );
        } else if (_isDatatype(graph, resource)) {
          datatypes.add(
            VocabularyDatatype(
              localName: localName,
              iri: iri,
              label: label,
              comment: comment,
            ),
          );
        } else {
          // If we can't determine the type, add it as an "other" term
          otherTerms.add(
            VocabularyTerm(
              localName: localName,
              iri: iri,
              label: label,
              comment: comment,
            ),
          );
        }
      } catch (e, stackTrace) {
        _log.warning('Error processing resource $resource: $e\n$stackTrace');
      }
    }

    return VocabularyModel(
      name: name,
      namespace: namespace,
      prefix: prefix,
      classes: classes,
      properties: properties,
      datatypes: datatypes,
      otherTerms: otherTerms,
    );
  }

  /// Finds all resources that are part of the vocabulary namespace.
  static List<IriTerm> _findVocabularyResources(
    RdfGraph graph,
    String namespace,
  ) {
    final resources = <IriTerm>{};

    // Find resources as subjects
    for (final triple in graph.triples) {
      if (triple.subject is IriTerm) {
        final subject = triple.subject as IriTerm;
        if (subject.iri.startsWith(namespace)) {
          resources.add(subject);
        }
      }
    }

    // Find resources as predicates
    for (final triple in graph.triples) {
      IriTerm predicate = triple.predicate as IriTerm;
      if (predicate.iri.startsWith(namespace)) {
        resources.add(predicate);
      }
    }

    // Find resources as objects
    for (final triple in graph.triples) {
      if (triple.object is IriTerm) {
        final object = triple.object as IriTerm;
        if (object.iri.startsWith(namespace)) {
          resources.add(object);
        }
      }
    }

    return resources.toList();
  }

  /// Determines if a resource is a class.
  static bool _isClass(RdfGraph graph, IriTerm resource) {
    const classTypes = [
      'http://www.w3.org/2000/01/rdf-schema#Class',
      'http://www.w3.org/2002/07/owl#Class',
    ];

    for (final classType in classTypes) {
      final typeTriples = graph.findTriples(
        subject: resource,
        predicate: IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
        object: IriTerm(classType),
      );

      if (typeTriples.isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  /// Determines if a resource is a property.
  static bool _isProperty(RdfGraph graph, IriTerm resource) {
    const propertyTypes = [
      'http://www.w3.org/1999/02/22-rdf-syntax-ns#Property',
      'http://www.w3.org/2002/07/owl#ObjectProperty',
      'http://www.w3.org/2002/07/owl#DatatypeProperty',
      'http://www.w3.org/2002/07/owl#AnnotationProperty',
    ];

    for (final propertyType in propertyTypes) {
      final typeTriples = graph.findTriples(
        subject: resource,
        predicate: IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
        object: IriTerm(propertyType),
      );

      if (typeTriples.isNotEmpty) {
        return true;
      }
    }

    // Check if it's used as a predicate in the graph
    for (final triple in graph.triples) {
      if (triple.predicate == resource) {
        return true;
      }
    }

    return false;
  }

  /// Determines if a resource is a datatype.
  static bool _isDatatype(RdfGraph graph, IriTerm resource) {
    final typeTriples = graph.findTriples(
      subject: resource,
      predicate: IriTerm('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
      object: IriTerm('http://www.w3.org/2000/01/rdf-schema#Datatype'),
    );

    return typeTriples.isNotEmpty;
  }

  /// Finds the label of a resource.
  static String? _findLabel(RdfGraph graph, IriTerm resource) {
    final labelTriples = graph.findTriples(
      subject: resource,
      predicate: IriTerm('http://www.w3.org/2000/01/rdf-schema#label'),
    );

    if (labelTriples.isNotEmpty) {
      final label = labelTriples.first.object;
      if (label is LiteralTerm) {
        return label.value;
      }
    }

    return null;
  }

  /// Finds the comment of a resource.
  static String? _findComment(RdfGraph graph, IriTerm resource) {
    final commentTriples = graph.findTriples(
      subject: resource,
      predicate: IriTerm('http://www.w3.org/2000/01/rdf-schema#comment'),
    );

    if (commentTriples.isNotEmpty) {
      final comment = commentTriples.first.object;
      if (comment is LiteralTerm) {
        return comment.value;
      }
    }

    return null;
  }

  /// Finds the superclasses of a class.
  static List<String> _findSuperClasses(RdfGraph graph, IriTerm resource) {
    final superClassTriples = graph.findTriples(
      subject: resource,
      predicate: IriTerm('http://www.w3.org/2000/01/rdf-schema#subClassOf'),
    );

    return superClassTriples
        .where((triple) => triple.object is IriTerm)
        .map((triple) => (triple.object as IriTerm).iri)
        .toList();
  }

  /// Finds the domains of a property.
  static List<String> _findDomains(RdfGraph graph, IriTerm resource) {
    final domainTriples = graph.findTriples(
      subject: resource,
      predicate: IriTerm('http://www.w3.org/2000/01/rdf-schema#domain'),
    );

    return domainTriples
        .where((triple) => triple.object is IriTerm)
        .map((triple) => (triple.object as IriTerm).iri)
        .toList();
  }

  /// Finds the ranges of a property.
  static List<String> _findRanges(RdfGraph graph, IriTerm resource) {
    final rangeTriples = graph.findTriples(
      subject: resource,
      predicate: IriTerm('http://www.w3.org/2000/01/rdf-schema#range'),
    );

    return rangeTriples
        .where((triple) => triple.object is IriTerm)
        .map((triple) => (triple.object as IriTerm).iri)
        .toList();
  }

  /// Extracts the local name from an IRI.
  static String _extractLocalName(String iri, String namespace) {
    if (iri.startsWith(namespace)) {
      final localName = iri.substring(namespace.length);
      // If there's a hash or slash at the end of the namespace, it's already separated
      if (localName.isNotEmpty) {
        return localName;
      }
    }

    // Fallback: extract the last segment after # or /
    final hashIndex = iri.lastIndexOf('#');
    if (hashIndex != -1 && hashIndex < iri.length - 1) {
      return iri.substring(hashIndex + 1);
    }

    final slashIndex = iri.lastIndexOf('/');
    if (slashIndex != -1 && slashIndex < iri.length - 1) {
      return iri.substring(slashIndex + 1);
    }

    // Couldn't determine a reasonable local name
    _log.warning('Could not extract local name from IRI: $iri');
    return iri;
  }

  /// Determines the preferred prefix for a vocabulary name.
  static String _determinePrefix(String name) {
    switch (name.toLowerCase()) {
      case 'dcterms':
        return 'dcterms';
      default:
        return name.toLowerCase();
    }
  }
}
