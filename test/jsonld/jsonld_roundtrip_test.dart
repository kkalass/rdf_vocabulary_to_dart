import 'package:test/test.dart';
import 'package:rdf_core/constants/dc_terms_constants.dart';
import 'package:rdf_core/constants/rdf_constants.dart';
import 'package:rdf_core/graph/rdf_graph.dart';
import 'package:rdf_core/graph/rdf_term.dart';
import 'package:rdf_core/graph/triple.dart';
import 'package:rdf_core/jsonld/jsonld_parser.dart';
import 'package:rdf_core/jsonld/jsonld_serializer.dart';

void main() {
  group('JsonLd Serializer-Parser Roundtrip', () {
    test(
      'should preserve triples in roundtrip conversion with simple graph',
      () {
        // Create a simple RDF graph
        var graph = RdfGraph(
          triples: [
            Triple(
              IriTerm('http://example.org/person/alice'),
              RdfConstants.typeIri,
              IriTerm('http://xmlns.com/foaf/0.1/Person'),
            ),
            Triple(
              IriTerm('http://example.org/person/alice'),
              IriTerm('http://xmlns.com/foaf/0.1/name'),
              LiteralTerm.string('Alice'),
            ),
          ],
        );

        // Perform roundtrip
        final serializer = JsonLdSerializer();
        final jsonLdOutput = serializer.write(graph);

        final parser = JsonLdParser(jsonLdOutput);
        final roundtripTriples = parser.parse();

        // Create a new graph from the parsed triples
        final roundtripGraph = RdfGraph(triples: roundtripTriples);

        // Verify the graphs are equivalent
        expect(roundtripGraph.triples.length, equals(graph.triples.length));

        // Check each triple from original graph exists in roundtrip graph
        for (final triple in graph.triples) {
          final matches = roundtripGraph.findTriples(
            subject: triple.subject,
            predicate: triple.predicate,
            object: triple.object,
          );
          expect(
            matches.isNotEmpty,
            isTrue,
            reason: 'Roundtrip graph is missing triple: $triple',
          );
        }
      },
    );

    test('should preserve triples in roundtrip conversion with complex graph', () {
      // Create a more complex RDF graph with various RDF term types
      var graph = RdfGraph(
        triples: [
          // Add person with various property types
          Triple(
            IriTerm('http://example.org/person/john'),
            RdfConstants.typeIri,
            IriTerm('http://xmlns.com/foaf/0.1/Person'),
          ),
          Triple(
            IriTerm('http://example.org/person/john'),
            IriTerm('http://xmlns.com/foaf/0.1/name'),
            LiteralTerm.string('John Smith'),
          ),
          Triple(
            IriTerm('http://example.org/person/john'),
            IriTerm('http://xmlns.com/foaf/0.1/age'),
            LiteralTerm.typed('42', 'integer'),
          ),
          Triple(
            IriTerm('http://example.org/person/john'),
            DcTermsConstants.createdIri,
            LiteralTerm.typed('2025-04-23T12:00:00Z', 'dateTime'),
          ),
          // Add language-tagged literals
          Triple(
            IriTerm('http://example.org/person/john'),
            IriTerm('http://xmlns.com/foaf/0.1/title'),
            LiteralTerm.withLanguage('Dr.', 'en'),
          ),
          Triple(
            IriTerm('http://example.org/person/john'),
            IriTerm('http://xmlns.com/foaf/0.1/title'),
            LiteralTerm.withLanguage('Doktor', 'de'),
          ),
          // Add boolean value
          Triple(
            IriTerm('http://example.org/person/john'),
            IriTerm('http://schema.org/active'),
            LiteralTerm.typed('true', 'boolean'),
          ),
          // Add relationship to another IRI
          Triple(
            IriTerm('http://example.org/person/john'),
            IriTerm('http://xmlns.com/foaf/0.1/knows'),
            IriTerm('http://example.org/person/jane'),
          ),
        ],
      );

      // Add blank node relationship
      final addressNode = BlankNodeTerm('address1');

      graph = graph.withTriples([
        Triple(
          IriTerm('http://example.org/person/john'),
          IriTerm('http://schema.org/address'),
          addressNode,
        ),
        Triple(
          addressNode,
          RdfConstants.typeIri,
          IriTerm('http://schema.org/PostalAddress'),
        ),
        Triple(
          addressNode,
          IriTerm('http://schema.org/streetAddress'),
          LiteralTerm.string('123 Main St'),
        ),
        Triple(
          addressNode,
          IriTerm('http://schema.org/postalCode'),
          LiteralTerm.string('12345'),
        ),
      ]);

      // Perform roundtrip conversion
      final serializer = JsonLdSerializer();
      final jsonLdOutput = serializer.write(
        graph,
        customPrefixes: {
          'foaf': 'http://xmlns.com/foaf/0.1/',
          'schema': 'http://schema.org/',
          'dcterms': 'http://purl.org/dc/terms/',
        },
      );

      // Print the JSON-LD for debugging if needed
      // print(jsonLdOutput);

      final parser = JsonLdParser(jsonLdOutput);
      final roundtripTriples = parser.parse();

      // Create a new graph from the parsed triples
      final roundtripGraph = RdfGraph(triples: roundtripTriples);

      // Verify the graphs have the same number of triples
      expect(roundtripGraph.triples.length, equals(graph.triples.length));

      // Check each original triple exists in the roundtrip graph
      // Note: We don't compare graphs directly as blank node labels may differ
      for (final originalTriple in graph.triples) {
        final matches = roundtripGraph.findTriples(
          subject:
              originalTriple.subject is BlankNodeTerm
                  ? null
                  : originalTriple.subject,
          predicate: originalTriple.predicate,
          object:
              originalTriple.object is BlankNodeTerm
                  ? null
                  : originalTriple.object,
        );

        expect(
          matches.isNotEmpty,
          isTrue,
          reason: 'No matching triple found for: $originalTriple',
        );

        // For blank node subjects or objects, ensure the structure is preserved
        if (originalTriple.subject is BlankNodeTerm ||
            originalTriple.object is BlankNodeTerm) {
          _verifyBlankNodeStructure(originalTriple, roundtripGraph);
        }
      }

      // Verify blank node relationships are preserved
      _verifyBlankNodeRelationships(graph, roundtripGraph);
    });
  });
}

/// Verifies that the structure of the graph involving blank nodes is preserved.
void _verifyBlankNodeStructure(Triple originalTriple, RdfGraph roundtripGraph) {
  if (originalTriple.subject is BlankNodeTerm) {
    final subjectTriples = roundtripGraph.findTriples(
      predicate: originalTriple.predicate,
      object:
          originalTriple.object is BlankNodeTerm ? null : originalTriple.object,
    );
    expect(subjectTriples.isNotEmpty, isTrue);

    // Verify that the subject has the same predicates and objects
    final originalSubjectTriples = roundtripGraph.findTriples(
      subject: originalTriple.subject,
    );

    for (final triple in originalSubjectTriples) {
      final matches = roundtripGraph.findTriples(
        subject: subjectTriples.first.subject,
        predicate: triple.predicate,
        object: triple.object is BlankNodeTerm ? null : triple.object,
      );
      expect(matches.isNotEmpty, isTrue);
    }
  }

  if (originalTriple.object is BlankNodeTerm) {
    final objectTriples = roundtripGraph.findTriples(
      subject:
          originalTriple.subject is BlankNodeTerm
              ? null
              : originalTriple.subject,
      predicate: originalTriple.predicate,
    );
    expect(objectTriples.isNotEmpty, isTrue);

    // Verify that the object has the same predicates and objects as the original
    final originalObjectTriples = roundtripGraph.findTriples(
      subject:
          originalTriple.object as RdfSubject, // Explicit cast to RdfSubject
    );

    for (final triple in originalObjectTriples) {
      final objectNode = objectTriples.first.object;
      if (objectNode is RdfSubject) {
        final matches = roundtripGraph.findTriples(
          subject: objectNode,
          predicate: triple.predicate,
          object: triple.object is BlankNodeTerm ? null : triple.object,
        );
        expect(matches.isNotEmpty, isTrue);
      }
    }
  }
}

/// Verifies that blank node relationships are preserved in the roundtrip graph.
void _verifyBlankNodeRelationships(
  RdfGraph originalGraph,
  RdfGraph roundtripGraph,
) {
  // Find all triples with blank nodes as subjects in both graphs
  final originalBlankNodeSubjects =
      originalGraph.triples
          .where((t) => t.subject is BlankNodeTerm)
          .map((t) => t.subject)
          .toSet();

  final roundtripBlankNodeSubjects =
      roundtripGraph.triples
          .where((t) => t.subject is BlankNodeTerm)
          .map((t) => t.subject)
          .toSet();

  // Make sure both graphs have the same number of blank node subjects
  expect(
    roundtripBlankNodeSubjects.length,
    equals(originalBlankNodeSubjects.length),
  );

  // For each original blank node, verify its structure is preserved in roundtrip
  for (final originalBlankNode in originalBlankNodeSubjects) {
    final originalPredicates =
        originalGraph
            .findTriples(subject: originalBlankNode)
            .map((t) => t.predicate)
            .toSet();

    // Find a matching blank node in the roundtrip graph with the same predicates
    bool foundMatch = false;
    for (final roundtripBlankNode in roundtripBlankNodeSubjects) {
      final roundtripPredicates =
          roundtripGraph
              .findTriples(subject: roundtripBlankNode)
              .map((t) => t.predicate)
              .toSet();

      if (originalPredicates.length == roundtripPredicates.length &&
          originalPredicates.every((p) => roundtripPredicates.contains(p))) {
        foundMatch = true;
        break;
      }
    }

    expect(
      foundMatch,
      isTrue,
      reason: 'No matching blank node found in roundtrip',
    );
  }
}
