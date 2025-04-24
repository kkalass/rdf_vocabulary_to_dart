/// RDF Triple - The fundamental unit of RDF data
///
/// This file defines the Triple class, which represents the atomic data unit in RDF:
/// a single statement about a resource. RDF represents information as a collection
/// of these subject-predicate-object statements.
library rdf_triple;

import 'package:rdf_core/graph/rdf_term.dart';

/// Represents an RDF triple.
///
/// A triple is the atomic unit of data in RDF, consisting of three components:
/// - subject: The resource being described (IRI or BlankNode)
/// - predicate: The property or relationship (always an IRI)
/// - object: The value or related resource (IRI, BlankNode, or Literal)
///
/// Triple data structures implement the constraints of the RDF data model using
/// Dart's type system to ensure that only valid RDF statements can be created.
///
/// Example in Turtle syntax:
/// ```turtle
/// # A triple stating that "John has the name 'John Smith'"
/// <http://example.com/john> <http://xmlns.com/foaf/0.1/name> "John Smith" .
///
/// # A triple stating that "John knows Jane"
/// <http://example.com/john> <http://xmlns.com/foaf/0.1/knows> <http://example.com/jane> .
/// ```
class Triple {
  /// The subject of the triple, representing the resource being described.
  /// Must be either an IRI or a blank node.
  final RdfSubject subject;

  /// The predicate of the triple, representing the property or relationship.
  /// Must be an IRI.
  final RdfPredicate predicate;

  /// The object of the triple, representing the value or related resource.
  /// Can be an IRI, a blank node, or a literal.
  final RdfObject object;

  /// Creates a new triple with the specified subject, predicate, and object.
  ///
  /// The constructor accepts any values that conform to the RDF term types
  /// that are allowed in each position, ensuring that only valid RDF triples
  /// can be created.
  ///
  /// Example:
  /// ```dart
  /// // Create a triple: <http://example.org/john> <http://xmlns.com/foaf/0.1/name> "John Smith"
  /// final john = IriTerm('http://example.org/john');
  /// final name = IriTerm('http://xmlns.com/foaf/0.1/name');
  /// final johnSmith = LiteralTerm.string('John Smith');
  /// final triple = Triple(john, name, johnSmith);
  /// ```
  Triple(this.subject, this.predicate, this.object);

  @override
  bool operator ==(Object other) {
    return other is Triple &&
        subject == other.subject &&
        predicate == other.predicate &&
        object == other.object;
  }

  @override
  int get hashCode => Object.hash(subject, predicate, object);

  @override
  String toString() => 'Triple($subject, $predicate, $object)';
}
