/// RDF Core Vocabulary Library
///
/// This library provides type-safe access to common RDF vocabularies and ontologies.
/// It includes standardized terms from widely used vocabularies like FOAF, Dublin Core,
/// Schema.org, and more.
///
/// By using these predefined terms, applications can build interoperable RDF data
/// without needing to manually construct IRIs, reducing errors and improving code readability.
///
/// The vocabulary classes are generated during the build process from their original
/// RDF definitions. To regenerate the vocabulary classes, run:
///
/// ```bash
/// dart run build_runner build --delete-conflicting-outputs
/// ```
library vocab;

// Manually defined vocabularies (legacy)
// TODO: Transition to generated versions and remove these exports
export 'src/vocab/acl.dart';
export 'src/vocab/dc.dart';
export 'src/vocab/dc_terms.dart';
export 'src/vocab/foaf.dart';
export 'src/vocab/ldp.dart';
export 'src/vocab/owl.dart';
export 'src/vocab/rdf.dart';
export 'src/vocab/rdfs.dart';
export 'src/vocab/schema.dart';
export 'src/vocab/skos.dart';
export 'src/vocab/solid.dart';
export 'src/vocab/vcard.dart';
export 'src/vocab/xsd.dart';

// Generated vocabularies (new)
// Uncomment when vocabularies have been generated
// export 'src/vocab/generated/_index.dart';
