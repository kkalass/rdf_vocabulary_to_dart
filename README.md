# rdf_core

A type-safe, modular Dart library for representing and manipulating RDF data.

## Features

- Clean, type-safe RDF model (IRIs, Literals, Triples, etc.)
- Serialization-agnostic: does not mix RDF with Turtle/JSON-LD
- Foundation for building higher-level libraries (ORM, Solid sync, etc.)
- Designed for extensibility and clarity

## Example

```dart
import 'package:rdf_core/rdf_core.dart';

void main() {
  final subject = Iri('http://example.org/alice');
  final predicate = Iri('http://xmlns.com/foaf/0.1/name');
  final object = Literal('Alice', language: 'en');

  final triple = Triple(subject, predicate, object);

  print('${triple.subject} ${triple.predicate} ${triple.object}');
}
```

## Philosophy

- **Separation of Concerns:** RDF model is kept clean and distinct from serialization formats.
- **Type Safety:** Dart types for all RDF concepts.
- **Extensible:** Designed to be the foundation for more advanced libraries, including ORM and Solid integrations.

## Getting Started

1. Add `rdf_core` to your `pubspec.yaml`.
2. Import and use the RDF model classes.

## Roadmap

- Collections (Graph, Dataset)
- Blank nodes
- Parsing/serialization adapters (in other packages)
- Integration with ORM and Solid libraries

---

Contributions welcome!
