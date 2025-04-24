/// RDF Graph - A collection of related RDF triples
///
/// This file defines the RdfGraph class, which represents a set of RDF triples that
/// collectively express related statements about resources. RDF graphs are the primary
/// data structure for working with RDF data and form the basis for knowledge representation.
library rdf_graph;

import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/graph/triple.dart';

/// Represents an immutable RDF graph with triple pattern matching capabilities
///
/// An RDF graph is formally defined as a set of RDF triples. This class provides
/// functionality for working with such graphs, including:
/// - Creating graphs from sets of triples
/// - Adding or removing triples (creating new graph instances)
/// - Merging graphs
/// - Querying triples based on patterns
///
/// The class is designed to be immutable for thread safety and to prevent
/// accidental modification. All operations that would modify the graph
/// return a new instance.
///
/// Example:
/// ```dart
/// // Create a graph with some initial triples
/// final graph = RdfGraph(triples: [
///   Triple(john, name, johnSmith),
///   Triple(john, knows, jane)
/// ]);
///
/// // Create a new graph with an additional triple
/// final updatedGraph = graph.withTriple(Triple(jane, name, janeSmith));
/// ```
final class RdfGraph {
  /// All triples in this graph
  final List<Triple> _triples;

  /// Creates an immutable RDF graph from a list of triples
  ///
  /// The constructor makes a defensive copy of the provided triples list
  /// to ensure immutability. The graph can be initialized with an empty
  /// list to create an empty graph.
  ///
  /// Example:
  /// ```dart
  /// // Empty graph
  /// final emptyGraph = RdfGraph();
  ///
  /// // Graph with initial triples
  /// final graph = RdfGraph(triples: myTriples);
  /// ```
  RdfGraph({List<Triple> triples = const []})
    : _triples = List.unmodifiable(List.from(triples));

  /// Creates an RDF graph from a list of triples (factory constructor)
  ///
  /// This is a convenience factory method equivalent to the default constructor.
  ///
  /// Example:
  /// ```dart
  /// final graph = RdfGraph.fromTriples(myTriples);
  /// ```
  static RdfGraph fromTriples(List<Triple> triples) =>
      RdfGraph(triples: triples);

  /// Creates a new graph with the specified triple added
  ///
  /// Since RdfGraph is immutable, this returns a new instance with
  /// all the existing triples plus the new one. The original graph
  /// remains unchanged.
  ///
  /// Example:
  /// ```dart
  /// // Add a statement that John has email john@example.com
  /// final newGraph = graph.withTriple(
  ///   Triple(john, email, LiteralTerm.string('john@example.com'))
  /// );
  /// ```
  ///
  /// @param triple The triple to add to the graph
  /// @return A new graph instance with the added triple
  RdfGraph withTriple(Triple triple) {
    final newTriples = List<Triple>.from(_triples)..add(triple);
    return RdfGraph(triples: newTriples);
  }

  /// Creates a new graph with all the specified triples added
  ///
  /// Since RdfGraph is immutable, this returns a new instance with
  /// all existing and new triples. The original graph remains unchanged.
  ///
  /// Example:
  /// ```dart
  /// // Add multiple statements about Jane
  /// final newGraph = graph.withTriples([
  ///   Triple(jane, email, LiteralTerm.string('jane@example.com')),
  ///   Triple(jane, age, LiteralTerm.typed('28', 'integer'))
  /// ]);
  /// ```
  ///
  /// @param triples The triples to add to the graph
  /// @return A new graph instance with the added triples
  RdfGraph withTriples(List<Triple> triples) {
    final newTriples = List<Triple>.from(_triples)..addAll(triples);
    return RdfGraph(triples: newTriples);
  }

  /// Creates a new graph by filtering out triples that match a pattern
  ///
  /// This method removes triples that match the specified pattern components.
  /// If multiple pattern components are provided, they are treated as an OR condition
  /// (i.e., if any of them match, the triple is removed).
  ///
  /// Example:
  /// ```dart
  /// // Remove all triples about Jane
  /// final withoutJane = graph.withoutMatching(subject: jane);
  ///
  /// // Remove all name and email triples
  /// final withoutContactInfo = graph.withoutMatching(
  ///   predicate: name,
  ///   object: email
  /// );
  /// ```
  ///
  /// @param subject Optional subject to match
  /// @param predicate Optional predicate to match
  /// @param object Optional object to match
  /// @return A new graph with matching triples removed
  RdfGraph withoutMatching({
    RdfSubject? subject,
    RdfPredicate? predicate,
    RdfObject? object,
  }) {
    final filteredTriples =
        _triples.where((triple) {
          if (subject != null && triple.subject == subject) return false;
          if (predicate != null && triple.predicate == predicate) return false;
          if (object != null && triple.object == object) return false;
          return true;
        }).toList();

    return RdfGraph(triples: filteredTriples);
  }

  /// Find all triples matching the given pattern
  ///
  /// This method returns triples that match all the specified pattern components.
  /// Unlike withoutMatching, this method uses AND logic - all specified components
  /// must match. If a pattern component is null, it acts as a wildcard.
  ///
  /// Example:
  /// ```dart
  /// // Find all statements about John
  /// final johnsTriples = graph.findTriples(subject: john);
  ///
  /// // Find all name statements
  /// final nameTriples = graph.findTriples(predicate: name);
  ///
  /// // Find John's name specifically
  /// final johnsName = graph.findTriples(subject: john, predicate: name);
  /// ```
  ///
  /// @param subject Optional subject to match
  /// @param predicate Optional predicate to match
  /// @param object Optional object to match
  /// @return List of matching triples (unmodifiable)
  List<Triple> findTriples({
    RdfSubject? subject,
    RdfPredicate? predicate,
    RdfObject? object,
  }) {
    return List.unmodifiable(
      _triples.where((triple) {
        if (subject != null && triple.subject != subject) return false;
        if (predicate != null && triple.predicate != predicate) return false;
        if (object != null && triple.object != object) return false;
        return true;
      }),
    );
  }

  /// Get all objects for a given subject and predicate
  ///
  /// This is a convenience method when you're looking for the value(s)
  /// of a particular property for a resource.
  ///
  /// Example:
  /// ```dart
  /// // Get all John's email addresses
  /// final johnEmails = graph.getObjects(john, email);
  /// ```
  ///
  /// @param subject The subject of the triples to query
  /// @param predicate The predicate of the triples to query
  /// @return List of all object values (unmodifiable)
  List<RdfObject> getObjects(RdfSubject subject, RdfPredicate predicate) {
    return List.unmodifiable(
      findTriples(
        subject: subject,
        predicate: predicate,
      ).map((triple) => triple.object),
    );
  }

  /// Get all subjects with a given predicate and object
  ///
  /// This is a convenience method for "reverse lookups" - finding resources
  /// that have a particular property value.
  ///
  /// Example:
  /// ```dart
  /// // Find all people who know Jane
  /// final peopleWhoKnowJane = graph.getSubjects(knows, jane);
  /// ```
  ///
  /// @param predicate The predicate of the triples to query
  /// @param object The object value of the triples to query
  /// @return List of all matching subjects (unmodifiable)
  List<RdfSubject> getSubjects(RdfPredicate predicate, RdfObject object) {
    return List.unmodifiable(
      findTriples(
        predicate: predicate,
        object: object,
      ).map((triple) => triple.subject),
    );
  }

  /// Merges this graph with another, producing a new graph
  ///
  /// This creates a union of the two graphs, combining all their triples.
  /// If both graphs contain the same triple, it will appear only once in
  /// the result (since RDF graphs are sets).
  ///
  /// Example:
  /// ```dart
  /// // Merge two graphs to combine their information
  /// final combinedGraph = personGraph.merge(addressGraph);
  /// ```
  ///
  /// @param other The graph to merge with this one
  /// @return A new graph containing all triples from both graphs
  RdfGraph merge(RdfGraph other) {
    return withTriples(other._triples);
  }

  /// Get all triples in the graph
  ///
  /// Returns an unmodifiable view of all triples in the graph.
  List<Triple> get triples => _triples;

  /// Number of triples in this graph
  int get size => _triples.length;

  /// Whether this graph contains any triples
  bool get isEmpty => _triples.isEmpty;

  /// Whether this graph contains at least one triple
  bool get isNotEmpty => _triples.isNotEmpty;

  /// We are implementing equals ourselves instead of using equatable,
  /// because we want to compare the sets of triples, not the order
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RdfGraph) return false;

    // Compare triple sets (order doesn't matter in RDF graphs)
    final Set<Triple> thisTriples = _triples.toSet();
    final Set<Triple> otherTriples = other._triples.toSet();
    return thisTriples.length == otherTriples.length &&
        thisTriples.containsAll(otherTriples);
  }

  @override
  int get hashCode => Object.hashAllUnordered(_triples);
}
