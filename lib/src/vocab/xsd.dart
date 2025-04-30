///
/// XML Schema Definition (XSD) Vocabulary
///
/// Provides constants for the [XML Schema Definition vocabulary](http://www.w3.org/2001/XMLSchema#),
/// which defines data types used in RDF literals.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/src/vocab/xsd.dart';
/// final integerType = Xsd.integer;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](https://www.w3.org/TR/xmlschema11-2/)
library xsd_vocab;

import 'package:rdf_core/src/graph/rdf_term.dart';

/// XSD namespace and datatype constants
///
/// Contains IRIs for XML Schema datatypes commonly used in RDF.
@deprecated
class Xsd {
  // coverage:ignore-start
  const Xsd._();
  // coverage:ignore-end

  /// Base IRI for XMLSchema datatypes
  /// [Spec](https://www.w3.org/TR/xmlschema-2/)
  static const String namespace = 'http://www.w3.org/2001/XMLSchema#';

  static const String prefix = 'xsd';
}

/// XML Schema Definition (XSD) datatype constants
///
/// This class provides access to the standard XML Schema datatypes that are used
/// in RDF for typing literal values. The RDF specification adopts XSD datatypes
/// as its primary type system for literal values.
///
/// These constants are particularly important when creating typed literals in RDF graphs.
@deprecated
class XsdTypes {
  // coverage:ignore-start
  // Private constructor prevents instantiation
  const XsdTypes._();
  // coverage:ignore-end

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
  static const string = IriTerm.prevalidated('${Xsd.namespace}string');

  /// IRI for xsd:boolean datatype
  ///
  /// Represents boolean values: true or false.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/isActive> "true"^^xsd:boolean .
  /// ```
  static const boolean = IriTerm.prevalidated('${Xsd.namespace}boolean');

  /// IRI for xsd:integer datatype
  ///
  /// Represents integer numbers (without a fractional part).
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/age> "42"^^xsd:integer .
  /// ```
  static const integer = IriTerm.prevalidated('${Xsd.namespace}integer');

  /// IRI for xsd:decimal datatype
  ///
  /// Represents decimal numbers with arbitrary precision.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/price> "19.99"^^xsd:decimal .
  /// ```
  static const decimal = IriTerm.prevalidated('${Xsd.namespace}decimal');

  /// IRI for xsd:double datatype
  ///
  /// Represents double-precision 64-bit floating point numbers.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/coefficient> "3.14159265359"^^xsd:double .
  /// ```
  static const double = IriTerm.prevalidated('${Xsd.namespace}double');

  /// IRI for xsd:float datatype
  ///
  /// Represents single-precision 32-bit floating point numbers.
  static const float = IriTerm.prevalidated('${Xsd.namespace}float');

  /// IRI for xsd:dateTime datatype
  ///
  /// Represents dates and times in ISO 8601 format.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/birthDate> "1990-01-01T00:00:00Z"^^xsd:dateTime .
  /// ```
  static const dateTime = IriTerm.prevalidated('${Xsd.namespace}dateTime');

  /// IRI for xsd:date datatype
  ///
  /// Represents calendar dates in ISO 8601 format (YYYY-MM-DD).
  static const date = IriTerm.prevalidated('${Xsd.namespace}date');

  /// IRI for xsd:time datatype
  ///
  /// Represents time of day in ISO 8601 format.
  static const time = IriTerm.prevalidated('${Xsd.namespace}time');

  /// IRI for xsd:anyURI datatype
  ///
  /// Represents URI references.
  static const anyUri = IriTerm.prevalidated('${Xsd.namespace}anyURI');

  /// IRI for xsd:long datatype
  ///
  /// Represents 64-bit integers.
  static const long = IriTerm.prevalidated('${Xsd.namespace}long');

  /// IRI for xsd:int datatype
  ///
  /// Represents 32-bit integers.
  static const int = IriTerm.prevalidated('${Xsd.namespace}int');

  /// IRI for xsd:short datatype
  ///
  /// Represents 16-bit integers.
  static const short = IriTerm.prevalidated('${Xsd.namespace}short');

  /// IRI for xsd:byte datatype
  ///
  /// Represents 8-bit integers.
  static const byte = IriTerm.prevalidated('${Xsd.namespace}byte');

  /// IRI for xsd:nonNegativeInteger datatype
  ///
  /// Represents integers that are greater than or equal to zero.
  static const nonNegativeInteger = IriTerm.prevalidated(
    '${Xsd.namespace}nonNegativeInteger',
  );

  /// IRI for xsd:positiveInteger datatype
  ///
  /// Represents integers that are greater than zero.
  static const positiveInteger = IriTerm.prevalidated(
    '${Xsd.namespace}positiveInteger',
  );

  /// IRI for xsd:nonPositiveInteger datatype
  ///
  /// Represents integers that are less than or equal to zero.
  static const nonPositiveInteger = IriTerm.prevalidated(
    '${Xsd.namespace}nonPositiveInteger',
  );

  /// IRI for xsd:negativeInteger datatype
  ///
  /// Represents integers that are less than zero.
  static const negativeInteger = IriTerm.prevalidated(
    '${Xsd.namespace}negativeInteger',
  );

  /// IRI for xsd:unsignedLong datatype
  ///
  /// Represents unsigned 64-bit integers.
  static const unsignedLong = IriTerm.prevalidated(
    '${Xsd.namespace}unsignedLong',
  );

  /// IRI for xsd:unsignedInt datatype
  ///
  /// Represents unsigned 32-bit integers.
  static const unsignedInt = IriTerm.prevalidated(
    '${Xsd.namespace}unsignedInt',
  );

  /// IRI for xsd:unsignedShort datatype
  ///
  /// Represents unsigned 16-bit integers.
  static const unsignedShort = IriTerm.prevalidated(
    '${Xsd.namespace}unsignedShort',
  );

  /// IRI for xsd:unsignedByte datatype
  ///
  /// Represents unsigned 8-bit integers.
  static const unsignedByte = IriTerm.prevalidated(
    '${Xsd.namespace}unsignedByte',
  );

  /// IRI for xsd:gYear datatype
  ///
  /// Represents a Gregorian calendar year.
  static const gYear = IriTerm.prevalidated('${Xsd.namespace}gYear');

  /// IRI for xsd:gMonth datatype
  ///
  /// Represents a Gregorian calendar month.
  static const gMonth = IriTerm.prevalidated('${Xsd.namespace}gMonth');

  /// IRI for xsd:gDay datatype
  ///
  /// Represents a Gregorian calendar day of the month.
  static const gDay = IriTerm.prevalidated('${Xsd.namespace}gDay');

  /// IRI for xsd:gYearMonth datatype
  ///
  /// Represents a Gregorian calendar year and month.
  static const gYearMonth = IriTerm.prevalidated('${Xsd.namespace}gYearMonth');

  /// IRI for xsd:gMonthDay datatype
  ///
  /// Represents a Gregorian calendar month and day.
  static const gMonthDay = IriTerm.prevalidated('${Xsd.namespace}gMonthDay');

  /// IRI for xsd:hexBinary datatype
  ///
  /// Represents arbitrary hex-encoded binary data.
  static const hexBinary = IriTerm.prevalidated('${Xsd.namespace}hexBinary');

  /// IRI for xsd:base64Binary datatype
  ///
  /// Represents arbitrary base64-encoded binary data.
  static const base64Binary = IriTerm.prevalidated(
    '${Xsd.namespace}base64Binary',
  );

  /// IRI for xsd:normalizedString datatype
  ///
  /// Represents whitespace-normalized strings.
  static const normalizedString = IriTerm.prevalidated(
    '${Xsd.namespace}normalizedString',
  );

  /// IRI for xsd:token datatype
  ///
  /// Represents tokenized strings.
  static const token = IriTerm.prevalidated('${Xsd.namespace}token');

  /// IRI for xsd:language datatype
  ///
  /// Represents language tags as defined by RFC 3066.
  static const language = IriTerm.prevalidated('${Xsd.namespace}language');

  /// IRI for xsd:duration datatype
  ///
  /// Represents a duration of time.
  static const duration = IriTerm.prevalidated('${Xsd.namespace}duration');

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
  /// final gMonthType = XsdTypes.makeIri("gMonth");
  /// ```
  static IriTerm makeIri(String xsdType) => IriTerm('${Xsd.namespace}$xsdType');
}
