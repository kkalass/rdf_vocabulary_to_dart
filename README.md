<div align="center">
  <img src="https://kkalass.github.io/rdf_vocabulary_builder/logo.svg" alt="rdf_vocabulary_builder logo" width="96" height="96"/>
</div>

# rdf_vocabulary_builder

[![pub package](https://img.shields.io/pub/v/rdf_vocabulary_builder.svg)](https://pub.dev/packages/rdf_vocabulary_builder)
[![build](https://github.com/kkalass/rdf_vocabulary_builder/actions/workflows/ci.yml/badge.svg)](https://github.com/kkalass/rdf_vocabulary_builder/actions)
[![codecov](https://codecov.io/gh/kkalass/rdf_vocabulary_builder/branch/main/graph/badge.svg)](https://codecov.io/gh/kkalass/rdf_vocabulary_builder)
[![license](https://img.shields.io/github/license/kkalass/rdf_vocabulary_builder.svg)](https://github.com/kkalass/rdf_vocabulary_builder/blob/main/LICENSE)

---

A build_runner for generating type-safe Dart classes from RDF vocabulary namespace IRIs to simplify working with RDF data in Dart.

[🌐 **Official Homepage**](https://kkalass.github.io/rdf_vocabulary_builder/)

---

## ✨ Features

- **Automatic RDF Vocabulary Generation:** Generates Dart classes from RDF vocabulary namespace IRIs
- **Type-safe Vocabulary Access:** Creates strongly-typed constants for all vocabulary terms
- **IDE Auto-completion:** Discoverable vocabulary terms with inline documentation
- **Minimal Dependencies:** Focused solely on the build generation process
- **Build Integration:** Seamlessly integrates with your build process via build_runner

## 🚀 Quick Start

### 1. Add Dependencies

```yaml
dependencies:
  rdf_core: ^0.5.1  # Core RDF library for using the generated classes

dev_dependencies:
  build_runner: ^2.4.0
  rdf_vocabulary_builder: ^0.1.0
```

### 2. Configure Build

Create a `build.yaml` file in your project root:

```yaml
targets:
  $default:
    builders:
      rdf_vocabulary_builder:vocabularyBuilder:
        options:
          vocabularies:
            # Example vocabularies
            - uri: http://www.w3.org/1999/02/22-rdf-syntax-ns#
              prefix: rdf
            - uri: http://www.w3.org/2000/01/rdf-schema#
              prefix: rdfs
            # Add your custom vocabularies
            - uri: http://example.org/my-vocabulary#
              prefix: myVocab
```

### 3. Generate Vocabulary Classes

Run the build_runner to generate vocabulary classes:

```bash
dart run build_runner build
```

### 4. Use Generated Classes

```dart
import 'package:your_package/generated/rdf.dart';
import 'package:your_package/generated/rdfs.dart';
import 'package:rdf_core/rdf_core.dart';

void main() {
  // Use generated vocabulary constants
  final typeTriple = Triple(
    IriTerm('http://example.org/resource'),
    RDF.type,  // Generated constant for rdf:type
    RDFS.Class // Generated constant for rdfs:Class
  );
  
  print(typeTriple);
}
```

## 🧑‍💻 Advanced Configuration

The `build.yaml` file offers flexible configuration options:

```yaml
targets:
  $default:
    builders:
      rdf_vocabulary_builder:vocabularyBuilder:
        options:
          # Base directory for generated files (optional, defaults to 'lib/generated')
          outputDir: lib/src/vocabularies
          # Whether to generate an index file (optional, defaults to true)
          generateIndex: true
          # Individual vocabulary configurations
          vocabularies:
            - uri: http://xmlns.com/foaf/0.1/
              prefix: foaf
              # Override default output path
              outputPath: lib/src/vocabularies/foaf.dart
              # Override class name (default would be FOAF)
              className: FoafVocabulary
              # Custom documentation for the vocabulary
              documentation: "Friend of a Friend vocabulary"
            
            - uri: http://example.org/custom#
              prefix: custom
              # You can provide a local file path instead of a URI
              filePath: path/to/local/vocabulary.ttl
              # Format of the local file (turtle, rdf/xml, json-ld)
              format: turtle
```

### Working with Generated Classes

Each generated vocabulary class contains:

- Constants for all terms defined in the vocabulary
- Type information (Class, Property, Datatype)
- Documentation from the original vocabulary

```dart
// Example of using a generated FOAF vocabulary
import 'package:your_package/src/vocabularies/foaf.dart';

// FOAF.name is an IriTerm for http://xmlns.com/foaf/0.1/name
final nameProperty = FOAF.name;
```

### Refreshing Vocabularies

To update your vocabulary classes with the latest definitions:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 🔧 Technical Details

### How It Works

1. The builder fetches RDF vocabularies from the provided URIs or local files
2. It parses the RDF data to extract terms, their types, and documentation
3. It generates Dart classes with constants for each term in the vocabulary
4. The generated code is optimized for IDE auto-completion and type safety

### Generated Code Structure

For each vocabulary, the builder generates:

```dart
/// Documentation for the vocabulary
class VocabularyName {
  /// Private constructor to prevent instantiation
  VocabularyName._();
  
  /// Documentation for term1
  static const term1 = IriTerm('http://example.org/vocabulary#term1');
  
  /// Documentation for term2
  static const term2 = IriTerm('http://example.org/vocabulary#term2');
  
  // ... more terms
}
```

## 🛣️ Roadmap

- Additional metadata extraction from vocabularies
- Support for vocabulary versioning
- Incremental builds for faster generation
- Custom template support for generated code

## 🤝 Contributing

Contributions, bug reports, and feature requests are welcome!

- Fork the repo and submit a PR
- See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines
- Join the discussion in [GitHub Issues](https://github.com/kkalass/rdf_vocabulary_builder/issues)

## 🔍 Related Projects

- [rdf_core](https://github.com/kkalass/rdf_core) - Core RDF library for Dart
- [rdf_vocabularies](https://github.com/kkalass/rdf_vocabularies) - Pre-generated standard RDF vocabularies

---

© 2025 Klas Kalaß. Licensed under the MIT License.
