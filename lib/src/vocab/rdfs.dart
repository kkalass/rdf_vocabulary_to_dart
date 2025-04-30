/// RDF Schema (RDFS) Vocabulary
///
/// Provides constants for the [RDF Schema 1.1](https://www.w3.org/TR/rdf-schema/).
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/src/vocab/rdfs.dart';
/// final label = RdfsPredicates.label;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](https://www.w3.org/TR/rdf-schema/)
library rdfs_vocab;

import 'package:rdf_core/src/graph/rdf_term.dart';

/// Base RDFS namespace and utility functions
@deprecated
class Rdfs {
  // coverage:ignore-start
  const Rdfs._();
  // coverage:ignore-end

  /// Base IRI for RDFS vocabulary
  /// [Spec](https://www.w3.org/TR/rdf-schema/)
  static const String namespace = 'http://www.w3.org/2000/01/rdf-schema#';
  static const String prefix = 'rdfs';
}

/// RDFS class constants.
///
/// Contains IRIs that represent classes defined in the RDFS vocabulary.
@deprecated
class RdfsClasses {
  // coverage:ignore-start
  const RdfsClasses._();
  // coverage:ignore-end

  /// IRI for rdfs:Resource
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_resource)
  ///
  /// The class of everything. All other classes are subclasses of this class.
  static const resource = IriTerm.prevalidated('${Rdfs.namespace}Resource');

  /// IRI for rdfs:Class
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_class)
  ///
  /// The class of all classes.
  static const class_ = IriTerm.prevalidated('${Rdfs.namespace}Class');

  /// IRI for rdfs:Literal
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_literal)
  ///
  /// The class of all literal values such as strings and integers.
  static const literal = IriTerm.prevalidated('${Rdfs.namespace}Literal');

  /// IRI for rdfs:Datatype
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_datatype)
  ///
  /// The class of RDF datatypes.
  static const datatype = IriTerm.prevalidated('${Rdfs.namespace}Datatype');

  /// IRI for rdfs:Container
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_container)
  ///
  /// The class of RDF containers.
  static const container = IriTerm.prevalidated('${Rdfs.namespace}Container');

  /// IRI for rdfs:ContainerMembershipProperty
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_containermembershipproperty)
  ///
  /// The class of container membership properties, rdf:_1, rdf:_2, ...,
  /// all of which are sub-properties of rdfs:member.
  static const containerMembershipProperty = IriTerm.prevalidated(
    '${Rdfs.namespace}ContainerMembershipProperty',
  );
}

/// RDFS predicate constants.
///
/// Contains IRIs for properties defined in the RDFS vocabulary.
@deprecated
class RdfsPredicates {
  // coverage:ignore-start
  const RdfsPredicates._();
  // coverage:ignore-end

  /// IRI for rdfs:domain
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_domain)
  ///
  /// A domain of a property. Indicates that resources with the given property
  /// are instances of the specified class.
  static const domain = IriTerm.prevalidated('${Rdfs.namespace}domain');

  /// IRI for rdfs:range
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_range)
  ///
  /// A range of a property. Indicates that the values of the given property
  /// are instances of the specified class.
  static const range = IriTerm.prevalidated('${Rdfs.namespace}range');

  /// IRI for rdfs:subPropertyOf
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_subpropertyof)
  ///
  /// Indicates that a property is a subproperty of another property.
  static const subPropertyOf = IriTerm.prevalidated(
    '${Rdfs.namespace}subPropertyOf',
  );

  /// IRI for rdfs:subClassOf
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_subclassof)
  ///
  /// Indicates that a class is a subclass of another class.
  static const subClassOf = IriTerm.prevalidated('${Rdfs.namespace}subClassOf');

  /// IRI for rdfs:label
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_label)
  ///
  /// A human-readable name for a resource.
  static const label = IriTerm.prevalidated('${Rdfs.namespace}label');

  /// IRI for rdfs:comment
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_comment)
  ///
  /// A description of a resource.
  static const comment = IriTerm.prevalidated('${Rdfs.namespace}comment');

  /// IRI for rdfs:member
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_member)
  ///
  /// A member of a container.
  static const member = IriTerm.prevalidated('${Rdfs.namespace}member');

  /// IRI for rdfs:seeAlso
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_seealso)
  ///
  /// Further information about a resource.
  static const seeAlso = IriTerm.prevalidated('${Rdfs.namespace}seeAlso');

  /// IRI for rdfs:isDefinedBy
  /// [Spec](https://www.w3.org/TR/rdf-schema/#ch_isdefinedby)
  ///
  /// The definition of a resource. It's a subproperty of rdfs:seeAlso.
  static const isDefinedBy = IriTerm.prevalidated(
    '${Rdfs.namespace}isDefinedBy',
  );
}
