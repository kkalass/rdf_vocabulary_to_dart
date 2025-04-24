/// rdf_core: A type-safe, modular Dart library for RDF concepts.
///
/// This library provides the fundamental building blocks for representing and
/// manipulating RDF data in Dart. It is serialization-agnostic and keeps RDF
/// model concepts cleanly separated from serialization formats like Turtle or JSON-LD.

library rdf_core;

/// Example: An RDF Node (IRI, Literal, or Blank Node)
abstract class RdfNode {}

/// An RDF IRI Node
class Iri extends RdfNode {
  final String value;
  Iri(this.value);
  @override
  String toString() => value;
}

/// An RDF Literal Node
class Literal extends RdfNode {
  final String value;
  final String? datatype;
  final String? language;
  Literal(this.value, {this.datatype, this.language});
  @override
  String toString() => language != null ? '"$value"@$language' : datatype != null ? '"$value"^^<$datatype>' : '"$value"';
}

/// An RDF Triple
class Triple {
  final RdfNode subject;
  final Iri predicate;
  final RdfNode object;
  Triple(this.subject, this.predicate, this.object);
  @override
  String toString() => '$subject $predicate $object .';
}
