// Example demonstrating the use of Schema.org PostalAddress in RDF
//
// This example shows how to create and query postal address data
// using the Schema.org vocabulary in RDF Core.

import 'package:rdf_core/rdf_core.dart';
import 'package:rdf_core/vocab.dart';

void main() {
  // Create a graph with an organization that has a postal address
  final graph = createOrganizationWithAddress();

  // Print the graph as triples
  print('Organization with Postal Address:');
  printGraph(graph);

  // Serialize to Turtle format for a nicer view
  final rdfCore = RdfCore.withStandardFormats();
  final turtle = rdfCore
      .getSerializer(contentType: 'text/turtle')
      .write(graph, customPrefixes: {'ex': 'http://example.org/'});

  print('\nTurtle serialization:\n$turtle');

  // Extract and print the address information
  final organization = IriTerm('http://example.org/acme');
  printAddressInfo(graph, organization);

  // Add a second address (branch office)
  final updatedGraph = addBranchOffice(graph);

  // Print the updated graph
  print('\nUpdated Graph with Branch Office:');
  final updatedTurtle = rdfCore
      .getSerializer(contentType: 'text/turtle')
      .write(updatedGraph, customPrefixes: {'ex': 'http://example.org/'});

  print('\n$updatedTurtle');
}

/// Creates a graph with an organization and its postal address
RdfGraph createOrganizationWithAddress() {
  // Define the subject for our organization
  final organization = IriTerm('http://example.org/acme');

  // Create a blank node for the postal address
  final address = BlankNodeTerm();

  // Create triples for the organization and its address
  final triples = [
    // Define the organization
    Triple(organization, RdfPredicates.type, SchemaClasses.organization),
    Triple(
      organization,
      SchemaProperties.name,
      LiteralTerm.string('ACME Corporation'),
    ),
    Triple(organization, SchemaProperties.url, IriTerm('https://example.org')),
    Triple(
      organization,
      SchemaOrganizationProperties.legalName,
      LiteralTerm.string('ACME Corporation GmbH'),
    ),

    // Link to address
    Triple(organization, SchemaPersonProperties.address, address),

    // Define the address details
    Triple(address, RdfPredicates.type, SchemaClasses.postalAddress),
    Triple(
      address,
      SchemaAddressProperties.streetAddress,
      LiteralTerm.string('123 Main Street'),
    ),
    Triple(
      address,
      SchemaAddressProperties.addressLocality,
      LiteralTerm.string('Berlin'),
    ),
    Triple(
      address,
      SchemaAddressProperties.postalCode,
      LiteralTerm.string('10115'),
    ),
    Triple(
      address,
      SchemaAddressProperties.addressRegion,
      LiteralTerm.string('Berlin'),
    ),
    Triple(
      address,
      SchemaAddressProperties.addressCountry,
      LiteralTerm.string('DE'),
    ),
  ];

  return RdfGraph(triples: triples);
}

/// Prints all triples in the given graph
void printGraph(RdfGraph graph) {
  for (final triple in graph.triples) {
    print('  $triple');
  }
}

/// Extracts and prints the address information for an entity
void printAddressInfo(RdfGraph graph, IriTerm entity) {
  print('\nAddress Information for ${entity.iri}:');

  // Find address nodes linked to this entity
  final addressTriples = graph.triples.where(
    (triple) =>
        triple.subject == entity &&
        triple.predicate == SchemaPersonProperties.address,
  );

  for (final addressTriple in addressTriples) {
    final addressNode = addressTriple.object;
    print('  Address:');

    // Find address properties
    final addressProperties = [
      SchemaAddressProperties.streetAddress,
      SchemaAddressProperties.addressLocality,
      SchemaAddressProperties.addressRegion,
      SchemaAddressProperties.postalCode,
      SchemaAddressProperties.addressCountry,
    ];

    for (final property in addressProperties) {
      final values =
          graph.triples
              .where((t) => t.subject == addressNode && t.predicate == property)
              .map((t) => t.object)
              .toList();

      if (values.isNotEmpty) {
        final propertyName = property.iri.split('/').last;
        print('    $propertyName: ${values.first}');
      }
    }
  }
}

/// Adds a branch office to the organization and returns a new graph
RdfGraph addBranchOffice(RdfGraph graph) {
  // Define the organization and new address
  final organization = IriTerm('http://example.org/acme');
  final branchAddress = BlankNodeTerm();

  // Create triples for the branch office
  final branchTriples = [
    Triple(organization, SchemaPersonProperties.address, branchAddress),
    Triple(branchAddress, RdfPredicates.type, SchemaClasses.postalAddress),
    Triple(
      branchAddress,
      SchemaAddressProperties.streetAddress,
      LiteralTerm.string('456 Innovation Blvd'),
    ),
    Triple(
      branchAddress,
      SchemaAddressProperties.addressLocality,
      LiteralTerm.string('Munich'),
    ),
    Triple(
      branchAddress,
      SchemaAddressProperties.postalCode,
      LiteralTerm.string('80331'),
    ),
    Triple(
      branchAddress,
      SchemaAddressProperties.addressRegion,
      LiteralTerm.string('Bavaria'),
    ),
    Triple(
      branchAddress,
      SchemaAddressProperties.addressCountry,
      LiteralTerm.string('DE'),
    ),
    Triple(
      branchAddress,
      SchemaProperties.name,
      LiteralTerm.string('Branch Office'),
    ),
  ];

  // Add all branch office triples to the graph
  return RdfGraph(triples: [...graph.triples, ...branchTriples]);
}
