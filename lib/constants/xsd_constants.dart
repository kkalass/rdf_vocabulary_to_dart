/// XML Schema Datatype Constants
///
/// Provides constants for [XML Schema Definition (XSD) datatypes](https://www.w3.org/TR/xmlschema-2/) as used in RDF.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/constants/xsd_constants.dart';
/// final intType = XsdConstants.intIri;
/// ```
///
/// All constants are pre-constructed as IriTerm objects for direct use in the library.
///
/// [Specification Reference](https://www.w3.org/TR/xmlschema-2/)
library xsd_constants;

import 'package:rdf_core/graph/rdf_term.dart';

/// XML Schema Definition (XSD) datatype constants
///
/// This class provides access to the standard XML Schema datatypes that are used
/// in RDF for typing literal values. The RDF specification adopts XSD datatypes
/// as its primary type system for literal values.
///
/// These constants are particularly important when creating typed literals in RDF graphs.
/// The class provides both common pre-defined constants and a utility method to create
/// IRIs for other XSD types not explicitly defined as constants.
class XsdConstants {
  // Private constructor prevents instantiation
  const XsdConstants._();

  /// Base IRI for XMLSchema datatypes
  /// [Spec](https://www.w3.org/TR/xmlschema-2/)
  static const String namespace = 'http://www.w3.org/2001/XMLSchema#';

  /// IRI for xsd:string datatype
  /// [Spec](https://www.w3.org/TR/xmlschema-2/#string)
  ///
  /// Represents character strings in XML Schema and RDF.
  /// This is the default datatype for string literals in RDF when no type is specified.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/name> "John Smith"^^xsd:string .
  /// ```
  static const stringIri = IriTerm('${namespace}string');

  /// IRI for xsd:boolean datatype
  ///
  /// Represents boolean values: true or false.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/isActive> "true"^^xsd:boolean .
  /// ```
  static const booleanIri = IriTerm('${namespace}boolean');

  /// IRI for xsd:integer datatype
  ///
  /// Represents integer numbers (without a fractional part).
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/age> "42"^^xsd:integer .
  /// ```
  static const integerIri = IriTerm('${namespace}integer');

  /// IRI for xsd:decimal datatype
  ///
  /// Represents decimal numbers with arbitrary precision.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/price> "19.99"^^xsd:decimal .
  /// ```
  static const decimalIri = IriTerm('${namespace}decimal');

  /// IRI for xsd:double datatype
  ///
  /// Represents double-precision 64-bit floating point numbers.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/coefficient> "3.14159265359"^^xsd:double .
  /// ```
  static const doubleIri = IriTerm('${namespace}double');

  /// IRI for xsd:float datatype
  ///
  /// Represents single-precision 32-bit floating point numbers.
  static const floatIri = IriTerm('${namespace}float');

  /// IRI for xsd:dateTime datatype
  ///
  /// Represents dates and times in ISO 8601 format.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/birthDate> "1990-01-01T00:00:00Z"^^xsd:dateTime .
  /// ```
  static const dateTimeIri = IriTerm('${namespace}dateTime');

  /// IRI for xsd:date datatype
  ///
  /// Represents calendar dates in ISO 8601 format (YYYY-MM-DD).
  static const dateIri = IriTerm('${namespace}date');

  /// IRI for xsd:time datatype
  ///
  /// Represents time of day in ISO 8601 format.
  static const timeIri = IriTerm('${namespace}time');

  /// IRI for xsd:anyURI datatype
  ///
  /// Represents URI references.
  static const anyUriIri = IriTerm('${namespace}anyURI');

  /// IRI for xsd:long datatype
  ///
  /// Represents 64-bit integers.
  static const longIri = IriTerm('${namespace}long');

  /// IRI for xsd:int datatype
  ///
  /// Represents 32-bit integers.
  static const intIri = IriTerm('${namespace}int');

  /// Creates an XSD datatype IRI from a local name
  ///
  /// This utility method allows creating IRI terms for XSD datatypes that
  /// aren't explicitly defined as constants in this class.
  ///
  /// Parameters:
  /// - [xsdType]: The local name of the XSD datatype (e.g., "string", "integer", "gYear")
  ///
  /// Returns:
  /// - An IriTerm representing the full XSD datatype IRI
  ///
  /// Example:
  /// ```dart
  /// // Create an IRI for xsd:gMonth datatype
  /// final gMonthType = XsdConstants.makeIri("gMonth");
  /// ```
  static IriTerm makeIri(String xsdType) => IriTerm('$namespace$xsdType');
}
