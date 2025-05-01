<div align="center">
  <img src="https://kkalass.github.io/rdf_vocab_builder/logo.svg" alt="rdf_vocab_builder logo" width="96" height="96"/>
</div>

# rdf_vocab_builder

[![pub package](https://img.shields.io/pub/v/rdf_vocab_builder.svg)](https://pub.dev/packages/rdf_vocab_builder)
[![build](https://github.com/kkalass/rdf_vocab_builder/actions/workflows/ci.yml/badge.svg)](https://github.com/kkalass/rdf_vocab_builder/actions)
[![codecov](https://codecov.io/gh/kkalass/rdf_vocab_builder/branch/main/graph/badge.svg)](https://codecov.io/gh/kkalass/rdf_vocab_builder)
[![license](https://img.shields.io/github/license/kkalass/rdf_vocab_builder.svg)](https://github.com/kkalass/rdf_vocab_builder/blob/main/LICENSE)

---

# RDF Core

[🌐 **Official Homepage**](https://kkalass.github.io/rdf_vocab_builder/)

A type-safe, and extensible Dart library for representing and manipulating RDF data without any further dependencies.

---

## Looking for mapping Dart Objects ↔️ RDF?

=> Discover our companion project [rdf_mapper](https://github.com/kkalass/rdf_mapper) now on GitHub!

---

## ✨ Features

- **Type-safe RDF model:** IRIs, Literals, Triples, Graphs, and more
- **Serialization-agnostic:** Clean separation from Turtle/JSON-LD
- **Extensible & modular:** Build your own adapters, plugins, and integrations
- **Spec-compliant:** Follows [W3C RDF 1.1](https://www.w3.org/TR/rdf11-concepts/) and related standards



## 🚀 Quick Start

### Manual Graph Creation

```dart
import 'package:rdf_vocab_builder/rdf_vocab_builder.dart';

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
import 'package:rdf_vocab_builder/rdf_vocab_builder.dart';

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

- Remove vocab directory and replace it with a much cleaner and more discoverable generated alternative, maybe in a separate project. This should also support generating discoverable vocab classes for arbitrary Vocabularies.
- Support base uri in jsonld and turtle serialization
- More serialization formats (N-Triples, RDF/XML)
- SHACL and schema validation
- Performance optimizations for large graphs

---

## 🤝 Contributing

Contributions, bug reports, and feature requests are welcome!

- Fork the repo and submit a PR
- See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines
- Join the discussion in [GitHub Issues](https://github.com/kkalass/rdf_vocab_builder/issues)

---

## 🤖 AI Policy

This project is proudly human-led and human-controlled, with all key decisions, design, and code reviews made by people. At the same time, it stands on the shoulders of LLM giants: generative AI tools are used throughout the development process to accelerate iteration, inspire new ideas, and improve documentation quality. We believe that combining human expertise with the best of AI leads to higher-quality, more innovative open source software.

---

© 2025 Klas Kalaß. Licensed under the MIT License.
