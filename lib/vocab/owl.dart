/// Web Ontology Language (OWL) Vocabulary
///
/// Provides constants for the [OWL 2 Web Ontology Language](https://www.w3.org/TR/owl2-overview/).
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/vocab/owl.dart';
/// final sameAs = OwlPredicates.sameAs;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](https://www.w3.org/TR/owl2-overview/)
library owl_vocab;

import 'package:rdf_core/graph/rdf_term.dart';

/// Base OWL namespace and utility functions
class Owl {
  // coverage:ignore-start
  const Owl._();
  // coverage:ignore-end

  /// Base IRI for OWL vocabulary
  /// [Spec](https://www.w3.org/TR/owl2-overview/)
  static const String namespace = 'http://www.w3.org/2002/07/owl#';
  static const String prefix = 'owl';
}

/// OWL class constants.
///
/// Contains IRIs that represent classes defined in the OWL vocabulary.
class OwlClasses {
  // coverage:ignore-start
  const OwlClasses._();
  // coverage:ignore-end

  /// IRI for owl:Class
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Classes)
  ///
  /// The class of all OWL classes.
  static const class_ = IriTerm.prevalidated('${Owl.namespace}Class');

  /// IRI for owl:Thing
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Classes)
  ///
  /// The class of all individuals. Every OWL individual is a member of this class.
  static const thing = IriTerm.prevalidated('${Owl.namespace}Thing');

  /// IRI for owl:Nothing
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Classes)
  ///
  /// The empty class. No individual can be a member of this class.
  static const nothing = IriTerm.prevalidated('${Owl.namespace}Nothing');

  /// IRI for owl:Restriction
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Class_Expressions)
  ///
  /// The class of all property restrictions in OWL.
  static const restriction = IriTerm.prevalidated(
    '${Owl.namespace}Restriction',
  );

  /// IRI for owl:ObjectProperty
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Object_Properties)
  ///
  /// The class of all object properties, which relate individuals to individuals.
  static const objectProperty = IriTerm.prevalidated(
    '${Owl.namespace}ObjectProperty',
  );

  /// IRI for owl:DatatypeProperty
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Datatype_Properties)
  ///
  /// The class of all datatype properties, which relate individuals to data values.
  static const datatypeProperty = IriTerm.prevalidated(
    '${Owl.namespace}DatatypeProperty',
  );

  /// IRI for owl:AnnotationProperty
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Annotation_Properties)
  ///
  /// The class of all annotation properties, which can be used to provide metadata.
  static const annotationProperty = IriTerm.prevalidated(
    '${Owl.namespace}AnnotationProperty',
  );

  /// IRI for owl:Ontology
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Ontologies)
  ///
  /// The class of all OWL ontologies.
  static const ontology = IriTerm.prevalidated('${Owl.namespace}Ontology');

  /// IRI for owl:NamedIndividual
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Named_Individuals)
  ///
  /// The class of named individuals in OWL.
  static const namedIndividual = IriTerm.prevalidated(
    '${Owl.namespace}NamedIndividual',
  );
}

/// OWL predicate constants.
///
/// Contains IRIs for properties defined in the OWL vocabulary.
class OwlPredicates {
  // coverage:ignore-start
  const OwlPredicates._();
  // coverage:ignore-end

  /// IRI for owl:sameAs
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Individual_Equality)
  ///
  /// Indicates that two URI references refer to the same individual.
  static const sameAs = IriTerm.prevalidated('${Owl.namespace}sameAs');

  /// IRI for owl:differentFrom
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Individual_Inequality)
  ///
  /// Indicates that two URI references refer to different individuals.
  static const differentFrom = IriTerm.prevalidated(
    '${Owl.namespace}differentFrom',
  );

  /// IRI for owl:equivalentClass
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Equivalent_Classes)
  ///
  /// Indicates that two classes contain exactly the same individuals.
  static const equivalentClass = IriTerm.prevalidated(
    '${Owl.namespace}equivalentClass',
  );

  /// IRI for owl:equivalentProperty
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Equivalent_Object_Properties)
  ///
  /// Indicates that two properties have the same property extension.
  static const equivalentProperty = IriTerm.prevalidated(
    '${Owl.namespace}equivalentProperty',
  );

  /// IRI for owl:disjointWith
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Disjoint_Classes)
  ///
  /// Indicates that two classes have no individuals in common.
  static const disjointWith = IriTerm.prevalidated(
    '${Owl.namespace}disjointWith',
  );

  /// IRI for owl:inverseOf
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Inverse_Object_Properties)
  ///
  /// Indicates that one property is the inverse of another.
  static const inverseOf = IriTerm.prevalidated('${Owl.namespace}inverseOf');

  /// IRI for owl:onProperty
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Object_Property_Restrictions)
  ///
  /// Used in property restrictions to specify the property that is being restricted.
  static const onProperty = IriTerm.prevalidated('${Owl.namespace}onProperty');

  /// IRI for owl:imports
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Imports)
  ///
  /// Imports another ontology into the current ontology.
  static const imports = IriTerm.prevalidated('${Owl.namespace}imports');

  /// IRI for owl:versionInfo
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Annotation_Properties)
  ///
  /// Provides version information for an ontology.
  static const versionInfo = IriTerm.prevalidated(
    '${Owl.namespace}versionInfo',
  );
}

/// OWL constraint and value constants.
///
/// Contains IRIs for constraint and value types defined in the OWL vocabulary.
class OwlConstraints {
  // coverage:ignore-start
  const OwlConstraints._();
  // coverage:ignore-end

  /// IRI for owl:someValuesFrom
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Existential_Quantification)
  ///
  /// Used in existential restrictions to specify the class that at least
  /// one value of the property must belong to.
  static const someValuesFrom = IriTerm.prevalidated(
    '${Owl.namespace}someValuesFrom',
  );

  /// IRI for owl:allValuesFrom
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Universal_Quantification)
  ///
  /// Used in universal restrictions to specify the class that all values
  /// of the property must belong to.
  static const allValuesFrom = IriTerm.prevalidated(
    '${Owl.namespace}allValuesFrom',
  );

  /// IRI for owl:minCardinality
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Minimum_Cardinality)
  ///
  /// Specifies the minimum number of values a property must have.
  static const minCardinality = IriTerm.prevalidated(
    '${Owl.namespace}minCardinality',
  );

  /// IRI for owl:maxCardinality
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Maximum_Cardinality)
  ///
  /// Specifies the maximum number of values a property can have.
  static const maxCardinality = IriTerm.prevalidated(
    '${Owl.namespace}maxCardinality',
  );

  /// IRI for owl:cardinality
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Exact_Cardinality)
  ///
  /// Specifies the exact number of values a property must have.
  static const cardinality = IriTerm.prevalidated(
    '${Owl.namespace}cardinality',
  );

  /// IRI for owl:hasValue
  /// [Spec](https://www.w3.org/TR/owl2-syntax/#Value_Restriction)
  ///
  /// Specifies a specific value that a property must have.
  static const hasValue = IriTerm.prevalidated('${Owl.namespace}hasValue');
}
