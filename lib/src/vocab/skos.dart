/// Simple Knowledge Organization System (SKOS) Vocabulary
///
/// Provides constants for the [SKOS vocabulary](http://www.w3.org/2004/02/skos/core#),
/// which is used for representing knowledge organization systems such as thesauri,
/// classification schemes, subject heading lists and taxonomies.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/src/vocab/skos.dart';
/// final concept = SkosClasses.concept;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](https://www.w3.org/TR/skos-reference/)
library skos_vocab;

import 'package:rdf_core/src/graph/rdf_term.dart';

/// Base SKOS namespace and utility functions
class Skos {
  // coverage:ignore-start
  const Skos._();
  // coverage:ignore-end

  /// Base IRI for SKOS vocabulary
  /// [Spec](http://www.w3.org/2004/02/skos/core#)
  static const String namespace = 'http://www.w3.org/2004/02/skos/core#';
  static const String prefix = 'skos';
}

/// SKOS class constants.
///
/// Contains IRIs that represent classes defined in the SKOS vocabulary.
class SkosClasses {
  // coverage:ignore-start
  const SkosClasses._();
  // coverage:ignore-end

  /// IRI for skos:Concept
  /// [Spec](https://www.w3.org/TR/skos-reference/#concepts)
  ///
  /// An idea or notion; a unit of thought.
  static const concept = IriTerm.prevalidated('${Skos.namespace}Concept');

  /// IRI for skos:ConceptScheme
  /// [Spec](https://www.w3.org/TR/skos-reference/#schemes)
  ///
  /// A set of concepts, optionally including statements about semantic relationships between those concepts.
  static const conceptScheme = IriTerm.prevalidated(
    '${Skos.namespace}ConceptScheme',
  );

  /// IRI for skos:Collection
  /// [Spec](https://www.w3.org/TR/skos-reference/#collections)
  ///
  /// A meaningful collection of concepts.
  static const collection = IriTerm.prevalidated('${Skos.namespace}Collection');

  /// IRI for skos:OrderedCollection
  /// [Spec](https://www.w3.org/TR/skos-reference/#collections)
  ///
  /// An ordered collection of concepts, where both the grouping and the ordering are meaningful.
  static const orderedCollection = IriTerm.prevalidated(
    '${Skos.namespace}OrderedCollection',
  );
}

/// SKOS predicate constants for semantic relations.
///
/// Contains IRIs for properties defined in the SKOS vocabulary.
class SkosSemanticRelations {
  // coverage:ignore-start
  const SkosSemanticRelations._();
  // coverage:ignore-end

  /// IRI for skos:broader
  /// [Spec](https://www.w3.org/TR/skos-reference/#semantic-relations)
  ///
  /// Links a concept to a concept that is more general in meaning.
  static const broader = IriTerm.prevalidated('${Skos.namespace}broader');

  /// IRI for skos:narrower
  /// [Spec](https://www.w3.org/TR/skos-reference/#semantic-relations)
  ///
  /// Links a concept to a concept that is more specific in meaning.
  static const narrower = IriTerm.prevalidated('${Skos.namespace}narrower');

  /// IRI for skos:related
  /// [Spec](https://www.w3.org/TR/skos-reference/#semantic-relations)
  ///
  /// Links a concept to a concept with which there is an associative semantic relationship.
  static const related = IriTerm.prevalidated('${Skos.namespace}related');

  /// IRI for skos:broaderTransitive
  /// [Spec](https://www.w3.org/TR/skos-reference/#semantic-relations)
  ///
  /// The transitive closure of skos:broader.
  static const broaderTransitive = IriTerm.prevalidated(
    '${Skos.namespace}broaderTransitive',
  );

  /// IRI for skos:narrowerTransitive
  /// [Spec](https://www.w3.org/TR/skos-reference/#semantic-relations)
  ///
  /// The transitive closure of skos:narrower.
  static const narrowerTransitive = IriTerm.prevalidated(
    '${Skos.namespace}narrowerTransitive',
  );

  /// IRI for skos:semanticRelation
  /// [Spec](https://www.w3.org/TR/skos-reference/#semantic-relations)
  ///
  /// Links a concept to a concept that is related by meaning.
  static const semanticRelation = IriTerm.prevalidated(
    '${Skos.namespace}semanticRelation',
  );
}

/// SKOS predicate constants for concept scheme membership and mapping.
///
/// Contains IRIs for properties related to concept schemes and concept mapping.
class SkosConceptSchemePredicates {
  // coverage:ignore-start
  const SkosConceptSchemePredicates._();
  // coverage:ignore-end

  /// IRI for skos:inScheme
  /// [Spec](https://www.w3.org/TR/skos-reference/#schemes)
  ///
  /// Links a concept to a concept scheme in which it is included.
  static const inScheme = IriTerm.prevalidated('${Skos.namespace}inScheme');

  /// IRI for skos:hasTopConcept
  /// [Spec](https://www.w3.org/TR/skos-reference/#schemes)
  ///
  /// Links a concept scheme to a concept which is topmost in the hierarchical relation.
  static const hasTopConcept = IriTerm.prevalidated(
    '${Skos.namespace}hasTopConcept',
  );

  /// IRI for skos:topConceptOf
  /// [Spec](https://www.w3.org/TR/skos-reference/#schemes)
  ///
  /// Links a concept to the concept scheme that it is a top level concept of.
  static const topConceptOf = IriTerm.prevalidated(
    '${Skos.namespace}topConceptOf',
  );
}

/// SKOS predicate constants for lexical labels.
///
/// Contains IRIs for properties that represent lexical labels in the SKOS vocabulary.
class SkosLabelRelations {
  // coverage:ignore-start
  const SkosLabelRelations._();
  // coverage:ignore-end

  /// IRI for skos:prefLabel
  /// [Spec](https://www.w3.org/TR/skos-reference/#labels)
  ///
  /// The preferred lexical label for a resource, in a given language.
  static const prefLabel = IriTerm.prevalidated('${Skos.namespace}prefLabel');

  /// IRI for skos:altLabel
  /// [Spec](https://www.w3.org/TR/skos-reference/#labels)
  ///
  /// An alternative lexical label for a resource.
  static const altLabel = IriTerm.prevalidated('${Skos.namespace}altLabel');

  /// IRI for skos:hiddenLabel
  /// [Spec](https://www.w3.org/TR/skos-reference/#labels)
  ///
  /// A lexical label for a resource that should be hidden when generating visual displays.
  static const hiddenLabel = IriTerm.prevalidated(
    '${Skos.namespace}hiddenLabel',
  );
}

/// SKOS predicate constants for documentation properties.
///
/// Contains IRIs for properties that represent documentation in the SKOS vocabulary.
class SkosDocumentationProps {
  // coverage:ignore-start
  const SkosDocumentationProps._();
  // coverage:ignore-end

  /// IRI for skos:note
  /// [Spec](https://www.w3.org/TR/skos-reference/#notes)
  ///
  /// A general note, for any purpose.
  static const note = IriTerm.prevalidated('${Skos.namespace}note');

  /// IRI for skos:definition
  /// [Spec](https://www.w3.org/TR/skos-reference/#notes)
  ///
  /// A complete explanation of the intended meaning of a concept.
  static const definition = IriTerm.prevalidated('${Skos.namespace}definition');

  /// IRI for skos:example
  /// [Spec](https://www.w3.org/TR/skos-reference/#notes)
  ///
  /// An example of the use of a concept.
  static const example = IriTerm.prevalidated('${Skos.namespace}example');

  /// IRI for skos:scopeNote
  /// [Spec](https://www.w3.org/TR/skos-reference/#notes)
  ///
  /// A note that helps to clarify the meaning and/or the use of a concept.
  static const scopeNote = IriTerm.prevalidated('${Skos.namespace}scopeNote');

  /// IRI for skos:historyNote
  /// [Spec](https://www.w3.org/TR/skos-reference/#notes)
  ///
  /// A note about the past state/use/meaning of a concept.
  static const historyNote = IriTerm.prevalidated(
    '${Skos.namespace}historyNote',
  );
}

/// SKOS predicate constants for mapping properties.
///
/// Contains IRIs for properties that represent mappings between concepts in different schemes.
class SkosMappingProps {
  // coverage:ignore-start
  const SkosMappingProps._();
  // coverage:ignore-end

  /// IRI for skos:exactMatch
  /// [Spec](https://www.w3.org/TR/skos-reference/#mapping)
  ///
  /// Indicates that two concepts are semantically equivalent.
  static const exactMatch = IriTerm.prevalidated('${Skos.namespace}exactMatch');

  /// IRI for skos:closeMatch
  /// [Spec](https://www.w3.org/TR/skos-reference/#mapping)
  ///
  /// Indicates that two concepts are sufficiently similar that they can be used interchangeably.
  static const closeMatch = IriTerm.prevalidated('${Skos.namespace}closeMatch');

  /// IRI for skos:broadMatch
  /// [Spec](https://www.w3.org/TR/skos-reference/#mapping)
  ///
  /// Indicates that the target concept is broader than the source concept.
  static const broadMatch = IriTerm.prevalidated('${Skos.namespace}broadMatch');

  /// IRI for skos:narrowMatch
  /// [Spec](https://www.w3.org/TR/skos-reference/#mapping)
  ///
  /// Indicates that the target concept is narrower than the source concept.
  static const narrowMatch = IriTerm.prevalidated(
    '${Skos.namespace}narrowMatch',
  );

  /// IRI for skos:relatedMatch
  /// [Spec](https://www.w3.org/TR/skos-reference/#mapping)
  ///
  /// Indicates that there is an associative mapping between two concepts.
  static const relatedMatch = IriTerm.prevalidated(
    '${Skos.namespace}relatedMatch',
  );
}
