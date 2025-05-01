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
- **Cross-vocabulary References:** Automatically resolves references between vocabularies
- **Smart Format Detection:** Supports multiple RDF formats (Turtle, RDF/XML, JSON-LD, N-Triples)
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

### 2. Create a Manifest File

Create a JSON manifest file (e.g., `lib/src/vocab/manifest.json`) to define your vocabularies:

```json
{
  "vocabularies": {
    "rdf": {
      "type": "url",
      "namespace": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "source": "https://www.w3.org/1999/02/22-rdf-syntax-ns.ttl"
    },
    "rdfs": {
      "type": "url",
      "namespace": "http://www.w3.org/2000/01/rdf-schema#"
    },
    "foaf": {
      "type": "url",
      "namespace": "http://xmlns.com/foaf/0.1/"
    },
    "customVocab": {
      "type": "file",
      "namespace": "http://example.org/custom#",
      "filePath": "lib/src/vocab/custom_vocab.ttl"
    }
  }
}
```

### 3. Configure Build

Create or update your `build.yaml` file in your project root:

```yaml
targets:
  $default:
    builders:
      rdf_vocabulary_builder|vocabulary_builder:
        enabled: true
        options:
          manifest_asset_path: "lib/src/vocab/manifest.json"
          output_dir: "lib/src/vocab/generated"
```

### 4. Generate Vocabulary Classes

Run the build_runner to generate vocabulary classes:

```bash
dart run build_runner build
```

### 5. Use Generated Classes

```dart
import 'package:your_package/src/vocab/generated/_index.dart';
// Alternatively, import individual vocabularies:
// import 'package:your_package/src/vocab/generated/rdf.dart';
// import 'package:your_package/src/vocab/generated/rdfs.dart';
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

## 🧑‍💻 Configuration Details

### Manifest File Format

The manifest file is a JSON document that defines the vocabularies to generate:

```json
{
  "vocabularies": {
    "rdf": {
      "type": "url",
      "namespace": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "source": "https://www.w3.org/1999/02/22-rdf-syntax-ns.ttl"
    },
    "ldp": {
      "type": "url",
      "namespace": "http://www.w3.org/ns/ldp#"
    }
  }
}
```

Each vocabulary entry in the manifest consists of:

- **Key**: The name of the vocabulary to generate (also used as the class name in PascalCase)
- **type**: Either "url" (remote vocabulary) or "file" (local vocabulary file)
- **namespace**: The base IRI namespace of the vocabulary
- **source** (optional): For "url" type, a specific source URL to fetch the vocabulary from (defaults to namespace)
- **filePath** (required for "file" type): For local files, the path to the vocabulary file

### Builder Configuration

In your `build.yaml`, you can configure the builder with these options:

```yaml
targets:
  $default:
    builders:
      rdf_vocabulary_builder|vocabulary_builder:
        enabled: true
        options:
          # Path to the manifest file (default: "lib/src/vocab/manifest.json")
          manifest_asset_path: "path/to/your/manifest.json"
          # Output directory for generated files (default: "lib/src/vocab/generated")
          output_dir: "path/to/output/dir"
```

### Understanding the Build Configuration

The `build.yaml` file defines two main sections:

1. **targets**: Configures how the builder is applied to your package
   - The builder is enabled with specific options for manifest path and output directory
   - These options control where the builder looks for input files and where it generates output

2. **builders**: Defines the builder itself
   - Specifies the location and factory method for creating the builder
   - Defines the build extensions and build behavior
   - The `auto_apply: dependents` setting means this builder will automatically run in any package that depends on yours

The combination of these settings ensures that:
1. In your own package, the builder runs with the configured paths to generate vocabularies
2. In dependent packages, the builder can be configured with their own paths to generate custom vocabularies

This setup follows the dependency inversion principle, allowing consumers of your package to control their vocabulary definitions while reusing your builder's implementation.

## 🔧 How It Works

The RDF Vocabulary Builder operates in several stages:

1. **Loading**: Parses the manifest file to determine which vocabularies to generate
2. **Fetching**: Retrieves vocabulary content from either URLs or local files
3. **Parsing**: Processes vocabularies in their native format (Turtle, RDF/XML, etc.)
4. **Resolution**: Identifies and resolves cross-vocabulary references
5. **Generation**: Creates Dart classes with constants for each term in the vocabulary
6. **Indexing**: Produces an index file for easy importing of all vocabularies

For remote vocabularies, the builder intelligently attempts to locate the vocabulary content if the exact URL isn't provided, trying several common patterns for vocabulary publication.

### Generated Code Structure

For each vocabulary, the builder generates a Dart class with the following structure:

```dart
/// Documentation for the vocabulary
class VocabularyName {
  /// Private constructor to prevent instantiation
  VocabularyName._();
  
  /// Base namespace for this vocabulary
  static const namespace = 'http://example.org/vocabulary#';
  
  /// Documentation for term1
  static const term1 = IriTerm('http://example.org/vocabulary#term1');
  
  /// Documentation for term2
  static const term2 = IriTerm('http://example.org/vocabulary#term2');
  
  // ... more terms
}
```

An index file is also generated to provide easy access to all vocabularies:

```dart
// _index.dart
export 'rdf.dart';
export 'rdfs.dart';
// ... more exports
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
