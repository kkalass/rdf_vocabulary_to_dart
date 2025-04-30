<div align="center">
  <img src="https://kkalass.github.io/rdf_core/logo.svg" alt="rdf_core logo" width="96" height="96"/>
</div>

# rdf_core

[![pub package](https://img.shields.io/pub/v/rdf_core.svg)](https://pub.dev/packages/rdf_core)
[![build](https://github.com/kkalass/rdf_core/actions/workflows/ci.yml/badge.svg)](https://github.com/kkalass/rdf_core/actions)
[![codecov](https://codecov.io/gh/kkalass/rdf_core/branch/main/graph/badge.svg)](https://codecov.io/gh/kkalass/rdf_core)
[![license](https://img.shields.io/github/license/kkalass/rdf_core.svg)](https://github.com/kkalass/rdf_core/blob/main/LICENSE)

---

# RDF Core

[🌐 **Official Homepage**](https://kkalass.github.io/rdf_core/)

A type-safe, and extensible Dart library for representing and manipulating RDF data without any further dependencies.

---
### Looking for mapping Dart Objects ↔️ RDF?

=> Discover our companion project [rdf_mapper](https://github.com/kkalass/rdf_mapper) now on GitHub!

---

## ✨ Features

- **Type-safe RDF model:** IRIs, Literals, Triples, Graphs, and more
- **Serialization-agnostic:** Clean separation from Turtle/JSON-LD
- **Extensible & modular:** Build your own adapters, plugins, and integrations
- **Spec-compliant:** Follows [W3C RDF 1.1](https://www.w3.org/TR/rdf11-concepts/) and related standards
- **Built-in vocabularies:** FOAF, Dublin Core (DC), SKOS, Schema.org, and more for easy discovery and usage, fully linked to the respective ontologies



## 🚀 Quick Start

### Manual Graph Creation

```dart
import 'package:rdf_core/rdf_core.dart';

void main() {
  final subject = IriTerm('http://example.org/alice');
  final predicate = IriTerm('http://xmlns.com/foaf/0.1/name');
  final object = LiteralTerm.withLanguage('Alice', 'en');
  final triple = Triple(subject, predicate, object);
  final graph = RdfGraph(triples: [triple]);

  print(graph);
}
```

### Parsing and Serializing Turtle

```dart
import 'package:rdf_core/rdf_core.dart';

void main() {
  // Example: Parse a simple Turtle document
  final turtle = '''
    @prefix foaf: <http://xmlns.com/foaf/0.1/> .
    <http://example.org/alice> foaf:name "Alice"@en .
  ''';

  final rdf = RdfCore.withStandardFormats();
  final graph = rdf.parse(turtle, contentType: 'text/turtle');

  // Print parsed triples
  for (final triple in graph.triples) {
    print('${triple.subject} ${triple.predicate} ${triple.object}');
  }

  // Serialize the graph back to Turtle
  final serialized = rdf.serialize(graph, contentType: 'text/turtle');
  print('\nSerialized Turtle:\n$serialized');
}
```

### Use Built-in RDF Vocabularies

The `vocab/` directory provides ready-to-use, type-safe access to many well-known RDF vocabularies and ontologies, including FOAF, Dublin Core (DC), SKOS, Schema.org, and more. This makes it easy to build interoperable RDF graphs without having to look up or type out long IRIs by hand.

**Why does this matter?**

- **Less boilerplate:** Use `FoafClasses.person` or `DcPredicates.title` instead of raw strings.
- **Fewer mistakes:** Avoid typos in IRIs and get autocompletion in your IDE.
- **Interoperability:** Build RDF graphs that follow standards, making your data more portable and reusable.

#### Example: Using Vocabularies

```dart
import 'package:rdf_core/rdf_core.dart';
import 'package:rdf_core/vocab.dart';

final alice = IriTerm('http://example.org/alice');

final graph = RdfGraph(
  triples: [
    Triple(alice, RdfPredicates.type, FoafClasses.person),
    Triple(alice, FoafPredicates.knows, IriTerm('http://example.org/bob')),
    Triple(alice, FoafPredicates.name, LiteralTerm.string('Alice')),
  ],
);
```

See the `vocab/` directory for all available vocabularies and their terms.

---

## 🧑‍💻 Advanced Usage

### Graph Merging

```dart
final merged = graph1.merge(graph2);
```

### Pattern Queries

```dart
final results = graph.findTriples(subject: subject);
```

### Blank Node Handling

```dart
final bnode = BlankNodeTerm();
final newGraph = graph.withTriple(Triple(bnode, predicate, object));
```

### Serialization/Parsing

```dart
final turtleSerializer = TurtleSerializer();
final turtle = turtleSerializer.write(graph);

final jsonLdParser = JsonLdParser(jsonLdSource);
final parsedGraph = jsonLdParser.parse();
```

---

## ⚠️ Error Handling

- All core methods throw Dart exceptions (e.g., `ArgumentError`, `RdfValidationException`) for invalid input or constraint violations.
- Catch and handle exceptions for robust RDF processing.

---

## 🚦 Performance

- Triple, Term, and IRI equality/hashCode are O(1)
- Graph queries (`findTriples`) are O(n) in the number of triples
- Designed for large-scale, high-performance RDF workloads

---

## 🗺️ API Overview

| Type           | Description                                   |
|----------------|-----------------------------------------------|
| `IriTerm`      | Represents an IRI (Internationalized Resource Identifier) |
| `LiteralTerm`  | Represents an RDF literal value               |
| `BlankNodeTerm`| Represents a blank node                       |
| `Triple`       | Atomic RDF statement (subject, predicate, object) |
| `RdfGraph`     | Collection of RDF triples                     |
| `RdfParser`    | Interface for parsing RDF from various formats |
| `RdfSerializer`| Interface for serializing RDF                 |

---

## 📚 Standards & References

- [RDF 1.1 Concepts](https://www.w3.org/TR/rdf11-concepts/)
- [Turtle: Terse RDF Triple Language](https://www.w3.org/TR/turtle/)
- [JSON-LD 1.1](https://www.w3.org/TR/json-ld11/)
- [SHACL: Shapes Constraint Language](https://www.w3.org/TR/shacl/)

---

## 🛣️ Roadmap / Next Steps

- Support base uri in jsonld and turtle serialization
- More serialization formats (N-Triples, RDF/XML)
- SHACL and schema validation
- Performance optimizations for large graphs

---

## 🤝 Contributing

Contributions, bug reports, and feature requests are welcome!

- Fork the repo and submit a PR
- See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines
- Join the discussion in [GitHub Issues](https://github.com/kkalass/rdf_core/issues)

---

## 🤖 AI Policy

This project is proudly human-led and human-controlled, with all key decisions, design, and code reviews made by people. At the same time, it stands on the shoulders of LLM giants: generative AI tools are used throughout the development process to accelerate iteration, inspire new ideas, and improve documentation quality. We believe that combining human expertise with the best of AI leads to higher-quality, more innovative open source software.

---

© 2025 Klas Kalaß. Licensed under the MIT License.
