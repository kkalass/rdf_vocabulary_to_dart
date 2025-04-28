/// RDF Core Vocabulary
///
/// Provides constants for the [RDF vocabulary](http://www.w3.org/1999/02/22-rdf-syntax-ns#),
/// which defines the core concepts and properties of the RDF data model.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/src/vocab/rdf.dart';
/// final type = RdfPredicates.type;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](https://www.w3.org/TR/rdf11-concepts/)
library rdf_vocab;

import 'package:rdf_core/src/graph/rdf_term.dart';

/// Base RDF namespace and utility functions
class Rdf {
  // coverage:ignore-start
  const Rdf._();
  // coverage:ignore-end

  /// Base IRI for RDF vocabulary
  /// [Spec](http://www.w3.org/1999/02/22-rdf-syntax-ns#)
  static const String namespace = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
  static const String prefix = 'rdf';

  /// IRI for rdf:nil
  ///
  /// Represents an empty RDF List.
  static const nil = IriTerm.prevalidated('${Rdf.namespace}nil');

  /// IRI for rdf:Property
  ///
  /// Represents the class of RDF properties. Properties in RDF are
  /// resources that are used as predicates in RDF statements.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/name> rdf:type rdf:Property .
  /// ```
  static const property = IriTerm.prevalidated('${Rdf.namespace}Property');

  /// IRI for rdf:Statement
  ///
  /// Represents the class of reified RDF statements. Reification is
  /// a mechanism in RDF to make statements about other statements.
  ///
  /// Example in Turtle (reifying a statement):
  /// ```turtle
  /// _:stmt rdf:type rdf:Statement ;
  ///        rdf:subject <http://example.org/john> ;
  ///        rdf:predicate <http://example.org/knows> ;
  ///        rdf:object <http://example.org/jane> .
  /// ```
  static const statement = IriTerm.prevalidated('${Rdf.namespace}Statement');

  /// IRI for rdf:List
  ///
  /// Represents the class of RDF Lists.
  static const list = IriTerm.prevalidated('${Rdf.namespace}List');

  /// IRI for rdf:Alt
  ///
  /// Represents the class of unordered containers for alternatives.
  static const alt = IriTerm.prevalidated('${Rdf.namespace}Alt');

  /// IRI for rdf:Bag
  ///
  /// Represents the class of unordered containers.
  static const bag = IriTerm.prevalidated('${Rdf.namespace}Bag');

  /// IRI for rdf:Seq
  ///
  /// Represents the class of ordered containers.
  static const seq = IriTerm.prevalidated('${Rdf.namespace}Seq');

  /// IRI for rdf:Container
  ///
  /// Represents the superclass of container classes.
  static const container = IriTerm.prevalidated('${Rdf.namespace}Container');

  /// IRI for rdf:XMLLiteral
  ///
  /// Represents the datatype of XML literal values.
  static const xmlLiteral = IriTerm.prevalidated('${Rdf.namespace}XMLLiteral');

  /// IRI for rdf:HTML
  ///
  /// Represents the datatype of HTML content.
  static const html = IriTerm.prevalidated('${Rdf.namespace}HTML');

  /// IRI for rdf:subject
  ///
  /// Used in reification to specify the subject of a statement.
  static const subject = IriTerm.prevalidated('${Rdf.namespace}subject');

  /// IRI for rdf:predicate
  ///
  /// Used in reification to specify the predicate of a statement.
  static const predicate = IriTerm.prevalidated('${Rdf.namespace}predicate');

  /// IRI for rdf:object
  ///
  /// Used in reification to specify the object of a statement.
  static const object = IriTerm.prevalidated('${Rdf.namespace}object');

  /// IRI for rdf:first
  ///
  /// Used to specify the first element in an RDF List.
  static const first = IriTerm.prevalidated('${Rdf.namespace}first');

  /// IRI for rdf:rest
  ///
  /// Used to specify the remainder of an RDF List after the first element.
  static const rest = IriTerm.prevalidated('${Rdf.namespace}rest');

  /// IRI for rdf:value
  ///
  /// The property rdf:value is used to relate a structured value to its
  /// primary value, or to relate a property/value pair to its value.
  static const value = IriTerm.prevalidated('${Rdf.namespace}value');

  /// IRI for rdf:JSON
  ///
  /// Represents the datatype of JSON content.
  static const json = IriTerm.prevalidated('${Rdf.namespace}JSON');
}

/// RDF type/class constants.
///
/// Contains IRIs that represent classes or types defined in the RDF vocabulary.
class RdfTypes {
  // coverage:ignore-start
  const RdfTypes._();
  // coverage:ignore-end

  /// IRI for rdf:langString datatype
  ///
  /// Represents the datatype for language-tagged string literals.
  /// According to the RDF specification, all language-tagged strings
  /// must have this datatype.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/book> <http://example.org/title> "The Title"@en .
  /// ```
  static const langString = IriTerm.prevalidated('${Rdf.namespace}langString');
}

/// RDF predicate constants.
///
/// Contains IRIs for properties defined in the RDF vocabulary.
class RdfPredicates {
  // coverage:ignore-start
  const RdfPredicates._();
  // coverage:ignore-end

  /// IRI for rdf:type predicate
  /// [Spec](https://www.w3.org/TR/rdf11-concepts/#section-triples)
  ///
  /// Represents the relationship between a resource and its type/class.
  /// This is one of the most commonly used properties in RDF.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/john> rdf:type foaf:Person .
  /// ```
  static const type = IriTerm.prevalidated('${Rdf.namespace}type');

  /// IRI for rdf:_1, rdf:_2, etc. predicates (container membership properties)
  ///
  /// Creates an RDF container membership property for the given index.
  /// These are used for ordered containers (rdf:Seq) and unordered containers
  /// (rdf:Bag, rdf:Alt).
  ///
  /// Parameters:
  /// - [index]: A positive integer representing the position in the container.
  ///
  /// Returns:
  /// - An IriTerm representing the container membership property.
  ///
  /// Example:
  /// ```dart
  /// // Create the rdf:_1 property
  /// final firstItem = RdfPredicates.containerMembership(1);
  /// ```
  static IriTerm containerMembership(int index) {
    if (index < 1) {
      throw ArgumentError('Container membership index must be positive');
    }
    return IriTerm('${Rdf.namespace}_$index');
  }
}
