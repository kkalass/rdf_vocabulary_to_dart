// Example usage of the rdf_core package
// Demonstrates manual graph handling, Turtle, and JSON-LD parsing/serialization

import 'package:rdf_core/constants/xsd_constants.dart';
import 'package:rdf_core/rdf_core.dart';

void main() {
  // --- Manual Graph Construction ---
  final alice = IriTerm('https://example.org/alice');
  final bob = IriTerm('https://example.org/bob');
  final knows = IriTerm('https://xmlns.com/foaf/0.1/knows');
  final name = IriTerm('https://xmlns.com/foaf/0.1/name');

  final graph = RdfGraph(
    triples: [
      Triple(alice, knows, bob),
      Triple(
        alice,
        name,
        LiteralTerm('Alice', datatype: XsdConstants.stringIri),
      ),
      Triple(bob, name, LiteralTerm('Bob', datatype: XsdConstants.stringIri)),
    ],
  );

  print('Manual RDF Graph:');
  for (final triple in graph.triples) {
    print('  ${triple.subject} ${triple.predicate} ${triple.object}');
  }

  // --- Serialize to Turtle ---
  var rdfCore = RdfCore.withStandardFormats();
  final turtleSerializer = rdfCore.getSerializer(contentType: 'text/turtle');
  final turtle = turtleSerializer.write(graph);
  print('\nTurtle serialization:\n$turtle');

  // --- Parse from Turtle ---
  final parsedGraph = rdfCore
      .getParser(contentType: 'text/turtle')
      .parse(turtle);
  print('\nParsed from Turtle:');
  for (final triple in parsedGraph.triples) {
    print('  ${triple.subject} ${triple.predicate} ${triple.object}');
  }

  // --- Serialize to JSON-LD ---
  final jsonldSerializer = rdfCore.getSerializer(
    contentType: 'application/ld+json',
  );
  final jsonld = jsonldSerializer.write(graph);
  print('\nJSON-LD serialization:\n$jsonld');

  // --- Parse from JSON-LD ---
  final parsedFromJsonLd = rdfCore
      .getParser(contentType: 'application/ld+json')
      .parse(jsonld);
  print('\nParsed from JSON-LD:');
  for (final triple in parsedFromJsonLd.triples) {
    print('  ${triple.subject} ${triple.predicate} ${triple.object}');
  }
}
