# Changelog

All notable changes to this project will be documented in this file.

## [0.5.1] - 2025-04-30

### Fixed
- Fixed release script to correctly parse the changelog format with square brackets
- Added missing development dependencies required for the release tooling

## [0.5.0] - 2025-04-30

- **BREAKING CHANGE**: Marked all vocabulary classes as deprecated
  - Added `@deprecated` annotation to all classes in vocabulary modules (acl, dc, dc_terms, foaf, ldp, etc.)
  - Classes will be removed in a future release due to API design concerns
  - Users should migrate to the upcoming new vocabulary API
- Improved code documentation
- Enhanced developer warnings for approaching breaking changes

## [0.4.0] - 2025-04-29

- **BREAKING CHANGE**: Reorganized API structure for better modularity and usability
- Added `RdfNamespaceMappings` for improved namespace handling
- Enhanced serializers to support custom namespace mappings
- Improved documentation across the codebase
- Updated API documentation to reflect new structure

## 0.3.1

- Extended Schema.org vocabulary with postal address support
  - Added `PostalAddress`, `ContactPoint`, and `Country` classes
  - Added `SchemaAddressProperties` for complete address modeling
  - Added properties for street address, locality, region, postal code, country, etc.
- Added comprehensive tests for new postal address components
- Added example demonstrating postal address usage with Schema.org vocabulary

## 0.3.0

- Enhanced blank node handling in RDF serialization and parsing
- Refactored IriTerm usage with prevalidated constructor and improved validation logic
- Refactored RDF Core Vocabulary: replaced constants with vocabulary modules
- Added RDF vocabularies for RDFS, Schema.org, SKOS, Solid, and vCard
- Improved documentation and consistency across RDF vocabularies
- Added comprehensive tests for RDF exception handling and parsing
- Enhanced test coverage for TurtleTokenizer and JsonLdFormat functionality
- Fixed edge cases in blank node handling
- Improved test assertions and documentation for various RDF vocabularies

## 0.2.0

- Numerous improvements and new features since 0.1.2.
- See commit history for details on all enhancements and fixes.

## 0.1.2

- Cleaned up all library names for consistency (removed rdf_vocab_builder. prefix, now use simple names like `exceptions.base`).
- Minor formatting and style improvements in core files.
- No breaking changes; all public APIs remain backward compatible.

## 0.1.1

- Example and documentation now consistently use canonical RDF vocabularies (e.g., http://xmlns.com/foaf/0.1/) with http://, not https://.
- Turtle and JSON-LD serializers automatically warn if non-canonical (https) namespaces are used when canonical (http) is available.
- Added documentation and comments on best practices for prefixes and vocabularies.
- Improved prefix handling and static analysis compliance.
- Added and refined tests for prefix usage and serialization correctness.

## 0.1.0

- Initial release of rdf_vocab_builder: type-safe, extensible Dart library for RDF data manipulation.
- Implements RDF graph, triple, term, and serialization/parsing for Turtle and JSON-LD.
- Plugin architecture for formats and adapters.
- Comprehensive test coverage.
