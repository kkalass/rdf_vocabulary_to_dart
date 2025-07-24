# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.9.1] - 2025-07-24

### Changed
- Updated rdf_core dependency to ^0.9.11
- Updated other dependencies as well

## [0.9.0] - 2025-05-14

### Changed
- Updated rdf_core dependency to ^0.9.0, which contains breaking changes (only a few small ones though)

## [0.8.0] - 2025-05-13

### Added
- Documentation clarification about platform compatibility: The package shows "no support for web" on pub.dev only because it's a build_runner tool, but the generated code is 100% compatible with all platforms including web, Flutter, and native Dart

### Changed
- Updated rdf_core dependency to ^0.8.1
- Updated other dependencies to latest versions
- Improved documentation clarity and formatting

### Fixed
- Documentation issue regarding "unresolved doc reference" in the generated documentation

## [0.7.2] - 2025-05-08

### Added
- New vocabulary support: VCard (vCard ontology for contact information)
- New vocabulary support: VS (Vocabulary Status ontology)
- New vocabulary support: XSD (XML Schema Definition)
- Universal properties classes for all vocabularies to simplify access to common properties

### Fixed
- Vocabularies which use https (like https://schema.org) sometimes are referenced via http://. We are now consistently only including those references to the scheme we first saw - e.g. foaf will have http://schema.org references, while schema (which is connected to foaf) will have only https://schema.org.

## [0.7.1] - 2025-05-06

### Added
- Missing dev dependencies

## [0.7.0] - 2025-05-06

### Added
- Initial release of RDF Vocabulary Builder
- Dynamic code generation from RDF vocabulary sources
- Automatic loading of vocabulary files from local filesystem or URLs
- Cross-vocabulary reference resolution and intelligent linking
- Support for configurable input manifest path and output directory
- Automatic generation of vocabulary index file for easy imports
- Custom builder for integration with Dart build_runner system
- Comprehensive documentation and examples
