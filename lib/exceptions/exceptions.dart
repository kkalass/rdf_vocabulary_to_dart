/// RDF Core Exceptions Library
///
/// Barrel file exporting all RDF exception types for easy import.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/exceptions/exceptions.dart';
/// try {
///   // some RDF operation
/// } catch (e) {
///   if (e is RdfException) print(e);
/// }
/// ```
library ext.rdf.core.exceptions;

export 'rdf_exception.dart';
export 'rdf_parser_exception.dart';
export 'rdf_serializer_exception.dart';
export 'rdf_validation_exception.dart';
