// Copyright (c) 2025, Klas Kalaß <habbatical@gmail.com>
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// This library exposes the builder factory for generating RDF vocabulary classes
/// from a JSON vocabulary manifest.
library rdf_vocabulary_builder.vocab_builder;

import 'package:build/build.dart';
export 'src/vocab/builder/vocabulary_source.dart';
import 'src/vocab/builder/vocabulary_builder.dart';

/// Creates a vocabulary builder with the given options.
///
/// Configuration options:
/// - manifest_asset_path: Path to the JSON manifest file (default: 'lib/src/vocab/manifest.json')
/// - output_dir: Output directory for generated files (default: 'lib/src/vocab/generated')
Builder vocabularyBuilder(BuilderOptions options) {
  // Read configuration from BuilderOptions
  final manifestPath =
      options.config['manifest_asset_path'] as String? ??
      'lib/src/vocab/manifest.json';
  final outputDir =
      options.config['output_dir'] as String? ?? 'lib/src/vocab/generated';

  return VocabularyBuilder(
    manifestAssetPath: manifestPath,
    outputDir: outputDir,
  );
}

/// Returns the build extensions for the vocabulary builder based on the given options.
/// This is used for dynamic configuration in the builder's build.yaml.
Map<String, List<String>> getBuildExtensions(Map<String, dynamic> config) {
  final manifestPath =
      config['manifest_asset_path'] as String? ?? 'lib/src/vocab/manifest.json';
  final outputDir =
      config['output_dir'] as String? ?? 'lib/src/vocab/generated';

  // Create a temporary builder instance just to get the build extensions
  // This ensures that the build extensions in build.yaml match those in the actual builder
  final builder = VocabularyBuilder(
    manifestAssetPath: manifestPath,
    outputDir: outputDir,
  );

  return builder.buildExtensions;
}
