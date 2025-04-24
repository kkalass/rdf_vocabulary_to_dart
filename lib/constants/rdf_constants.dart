/// RDF Core Vocabulary - Constants for the W3C RDF specification
///
/// This file provides constant definitions for core RDF vocabulary terms defined
/// in the W3C RDF 1.1 Concepts and Abstract Syntax specification. These constants
/// are used throughout the RDF library to ensure consistency and correctness when
/// referring to standard RDF terms.
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
library rdf_constants;

import 'package:rdf_core/graph/rdf_term.dart';

/// Centralized repository of common RDF constants and vocabulary terms.
///
/// This class contains pre-initialized IRI term constants for core RDF vocabulary
/// elements defined in the RDF 1.1 specification. These constants are essential
/// for creating well-formed RDF graphs that adhere to the standard.
///
/// The constants are implemented as static members on a non-instantiable class
/// to provide a convenient namespace without requiring instantiation.
class RdfConstants {
  // Private constructor prevents instantiation
  const RdfConstants._();

  /// Base IRI for RDF vocabulary
  ///
  /// This namespace is defined by the W3C for the core RDF terms.
  /// See: https://www.w3.org/1999/02/22-rdf-syntax-ns#
  static const String namespace = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';

  /// IRI for rdf:type predicate
  ///
  /// Represents the relationship between a resource and its type/class.
  /// This is one of the most commonly used properties in RDF.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/john> rdf:type foaf:Person .
  /// ```
  static const typeIri = IriTerm('${namespace}type');

  /// IRI for rdf:langString datatype
  ///
  /// Represents the datatype for language-tagged string literals.
  /// According to the RDF specification, all language-tagged strings
  /// must have this datatype.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/book> <http://example.org/title> "The Title"@en .
  /// ```
  static const langStringIri = IriTerm('${namespace}langString');

  /// IRI for rdf:Property
  ///
  /// Represents the class of RDF properties. Properties in RDF are
  /// resources that are used as predicates in RDF statements.
  ///
  /// Example in Turtle:
  /// ```turtle
  /// <http://example.org/name> rdf:type rdf:Property .
  /// ```
  static const propertyIri = IriTerm('${namespace}Property');

  /// IRI for rdf:Statement
  ///
  /// Represents the class of reified RDF statements. Reification is
  /// a mechanism in RDF to make statements about other statements.
  ///
  /// Example in Turtle (reifying a statement):
  /// ```turtle
  /// _:stmt rdf:type rdf:Statement ;
  ///        rdf:subject <http://example.org/john> ;
  ///        rdf:predicate <http://example.org/knows> ;
  ///        rdf:object <http://example.org/jane> .
  /// ```
  static const statementIri = IriTerm('${namespace}Statement');

  /// IRI for rdf:subject
  ///
  /// Used in reification to specify the subject of a statement.
  static const subjectIri = IriTerm('${namespace}subject');

  /// IRI for rdf:predicate
  ///
  /// Used in reification to specify the predicate of a statement.
  static const predicateIri = IriTerm('${namespace}predicate');

  /// IRI for rdf:object
  ///
  /// Used in reification to specify the object of a statement.
  static const objectIri = IriTerm('${namespace}object');

  /// IRI for rdf:List
  ///
  /// Represents the class of RDF Lists.
  static const listIri = IriTerm('${namespace}List');

  /// IRI for rdf:first
  ///
  /// Used to specify the first element in an RDF List.
  static const firstIri = IriTerm('${namespace}first');

  /// IRI for rdf:rest
  ///
  /// Used to specify the remainder of an RDF List after the first element.
  static const restIri = IriTerm('${namespace}rest');

  /// IRI for rdf:nil
  ///
  /// Represents an empty RDF List.
  static const nilIri = IriTerm('${namespace}nil');
}
