/// RDF Terms - Fundamental building blocks of the RDF data model
///
/// This file defines the core RDF term types as specified by the W3C RDF 1.1 Concepts
/// specification. These types form the foundation of the RDF data model and are used
/// to represent subjects, predicates, and objects in RDF triples.
///
/// In RDF, information is expressed as triples of subject-predicate-object, where:
/// - Subjects are IRIs or blank nodes
/// - Predicates are always IRIs
/// - Objects can be IRIs, blank nodes, or literals
///
/// This hierarchy of classes uses Dart's sealed classes to enforce the constraints
/// of the RDF specification regarding which terms can appear in which positions.
library rdf_terms;

import 'package:rdf_core/constants/rdf_constants.dart';
import 'package:rdf_core/constants/xsd_constants.dart';

/// Base type for all RDF terms
///
/// RDF terms are the atomic components used to build RDF triples.
/// This is the root of the RDF term type hierarchy.
sealed class RdfTerm {
  const RdfTerm();
}

/// Base type for values that can appear in the object position of a triple
///
/// In RDF, objects can be IRIs, blank nodes, or literals.
sealed class RdfObject extends RdfTerm {
  const RdfObject();
}

/// Base type for values that can appear in the subject position of a triple
///
/// In RDF, subjects can only be IRIs or blank nodes (not literals).
sealed class RdfSubject extends RdfObject {
  const RdfSubject();
}

/// Base type for values that can appear in the predicate position of a triple
///
/// In RDF, predicates can only be IRIs.
sealed class RdfPredicate extends RdfTerm {
  const RdfPredicate();
}

/// IRI (Internationalized Resource Identifier) in RDF
///
/// IRIs are used to identify resources in the RDF data model. They are
/// global identifiers that can refer to documents, concepts, or physical entities.
///
/// IRIs can be used in any position in a triple: subject, predicate, or object.
///
/// Example: `http://example.org/person/john` or `http://xmlns.com/foaf/0.1/name`
class IriTerm extends RdfTerm implements RdfPredicate, RdfSubject {
  /// The string representation of the IRI
  final String iri;

  /// Creates an IRI term with the specified IRI string
  ///
  /// The IRI should be a valid IRI according to RFC 3987, though
  /// this constructor doesn't validate the IRI format.
  const IriTerm(this.iri);

  @override
  bool operator ==(Object other) {
    return other is IriTerm && iri.toLowerCase() == other.iri.toLowerCase();
  }

  @override
  int get hashCode => iri.hashCode;

  @override
  String toString() => 'IriTerm($iri)';
}

/// BlankNode (anonymous resource) in RDF
///
/// Blank nodes represent resources that don't need global identification.
/// They are used when we need to represent a resource but don't have or need
/// an IRI for it. Blank nodes are scoped to the document they appear in.
///
/// Blank nodes can appear in subject or object positions, but not as predicates.
///
/// In Turtle syntax, blank nodes are written as `_:label` or as `[]`.
class BlankNodeTerm extends RdfTerm implements RdfSubject {
  /// The label identifying this blank node within its document scope
  final String label;

  /// Creates a blank node term with the specified label
  const BlankNodeTerm(this.label);

  @override
  bool operator ==(Object other) {
    return other is BlankNodeTerm && label == other.label;
  }

  @override
  int get hashCode => label.hashCode;

  @override
  String toString() => 'BlankNodeTerm($label)';
}

/// Literal value in RDF
///
/// Literals represent values like strings, numbers, dates, etc. Each literal
/// has a lexical value (string) and a datatype IRI that defines how to interpret
/// the string. Additionally, string literals can have language tags.
///
/// Literals can only appear in the object position of a triple, never as subjects
/// or predicates.
///
/// Examples in Turtle syntax:
/// - Simple string: `"Hello World"`
/// - Typed number: `"42"^^xsd:integer`
/// - Language-tagged string: `"Hello"@en`
class LiteralTerm extends RdfTerm implements RdfObject {
  /// The lexical value of the literal as a string
  final String value;

  /// The datatype IRI defining the literal's type
  final IriTerm datatype;

  /// Optional language tag for language-tagged string literals
  final String? language;

  /// Create a literal with optional datatype or language tag
  ///
  /// According to the RDF 1.1 specification:
  /// - A literal with a language tag must use rdf:langString datatype
  /// - A literal with rdf:langString datatype must have a language tag
  ///
  /// This constructor enforces those constraints with an assertion.
  const LiteralTerm(this.value, {required this.datatype, this.language})
    : assert(
        (language == null) != (datatype == RdfConstants.langStringIri),
        'Language-tagged literals must use rdf:langString datatype, and rdf:langString must have a language tag',
      );

  /// Create a typed literal with XSD datatype
  ///
  /// This is a convenience factory for creating literals with common XSD types.
  ///
  /// Example:
  /// ```dart
  /// // Create an integer literal
  /// final intLiteral = LiteralTerm.typed("42", "integer");
  ///
  /// // Create a date literal
  /// final dateLiteral = LiteralTerm.typed("2023-04-01", "date");
  /// ```
  factory LiteralTerm.typed(String value, String xsdType) {
    return LiteralTerm(value, datatype: XsdConstants.makeIri(xsdType));
  }

  /// Create a plain string literal
  ///
  /// This is a convenience factory for creating literals with xsd:string datatype.
  ///
  /// Example:
  /// ```dart
  /// // Create a string literal
  /// final stringLiteral = LiteralTerm.string("Hello, World!");
  /// ```
  factory LiteralTerm.string(String value) {
    return LiteralTerm(value, datatype: XsdConstants.stringIri);
  }

  /// Create a language-tagged literal
  ///
  /// This is a convenience factory for creating literals with language tags.
  /// These literals use the rdf:langString datatype.
  ///
  /// Example:
  /// ```dart
  /// // Create an English language literal
  /// final enLiteral = LiteralTerm.withLanguage("Hello", "en");
  ///
  /// // Create a German language literal
  /// final deLiteral = LiteralTerm.withLanguage("Hallo", "de");
  /// ```
  factory LiteralTerm.withLanguage(String value, String langTag) {
    return LiteralTerm(
      value,
      datatype: RdfConstants.langStringIri,
      language: langTag,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LiteralTerm &&
        value == other.value &&
        datatype == other.datatype &&
        language == other.language;
  }

  @override
  int get hashCode => Object.hash(value, datatype, language);

  @override
  String toString() => 'LiteralTerm($value, $datatype, $language)';
}
