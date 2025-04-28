/// Linked Data Platform (LDP) Vocabulary
///
/// Provides constants for the [Linked Data Platform (LDP) vocabulary](http://www.w3.org/ns/ldp#),
/// which is used for describing web resources that comply with the LDP specification.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/vocab/ldp.dart';
/// final container = LdpClasses.container;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](https://www.w3.org/TR/ldp/)
library ldp_vocab;

import 'package:rdf_core/graph/rdf_term.dart';

/// Base LDP namespace and utility functions
class Ldp {
  // coverage:ignore-start
  const Ldp._();
  // coverage:ignore-end

  /// Base IRI for LDP vocabulary
  /// [Spec](http://www.w3.org/ns/ldp#)
  static const String namespace = 'http://www.w3.org/ns/ldp#';
  static const String prefix = 'ldp';
}

/// LDP class constants.
///
/// Contains IRIs that represent classes defined in the LDP vocabulary.
class LdpClasses {
  // coverage:ignore-start
  const LdpClasses._();
  // coverage:ignore-end

  /// IRI for ldp:Resource
  /// [Spec](https://www.w3.org/TR/ldp/#ldpr-resource)
  ///
  /// A HTTP-addressable resource whose state is represented in any way that conforms to the simple lifecycle patterns and conventions in LDP.
  static const resource = IriTerm.prevalidated('${Ldp.namespace}Resource');

  /// IRI for ldp:RDFSource
  /// [Spec](https://www.w3.org/TR/ldp/#ldprs)
  ///
  /// A Linked Data Platform Resource (LDPR) whose state is represented as RDF.
  static const rdfSource = IriTerm.prevalidated('${Ldp.namespace}RDFSource');

  /// IRI for ldp:NonRDFSource
  /// [Spec](https://www.w3.org/TR/ldp/#ldpnr)
  ///
  /// A Linked Data Platform Resource (LDPR) whose state is not represented as RDF.
  static const nonRDFSource = IriTerm.prevalidated(
    '${Ldp.namespace}NonRDFSource',
  );

  /// IRI for ldp:Container
  /// [Spec](https://www.w3.org/TR/ldp/#ldpc)
  ///
  /// A Linked Data Platform RDF Source (LDP-RS) that contains Linked Data Platform Resources.
  static const container = IriTerm.prevalidated('${Ldp.namespace}Container');

  /// IRI for ldp:BasicContainer
  /// [Spec](https://www.w3.org/TR/ldp/#ldpbc)
  ///
  /// A Linked Data Platform Container (LDPC) that defines a simple link to its contained documents (LDP-RSs).
  static const basicContainer = IriTerm.prevalidated(
    '${Ldp.namespace}BasicContainer',
  );

  /// IRI for ldp:DirectContainer
  /// [Spec](https://www.w3.org/TR/ldp/#ldpdc)
  ///
  /// A Linked Data Platform Container that allows the client to create the relationship between the resource and the container's membership triples.
  static const directContainer = IriTerm.prevalidated(
    '${Ldp.namespace}DirectContainer',
  );

  /// IRI for ldp:IndirectContainer
  /// [Spec](https://www.w3.org/TR/ldp/#ldpic)
  ///
  /// A Linked Data Platform Container that allows the client to create the membership triple using a client-specified predicate and object.
  static const indirectContainer = IriTerm.prevalidated(
    '${Ldp.namespace}IndirectContainer',
  );
}

/// LDP predicate constants.
///
/// Contains IRIs for properties defined in the LDP vocabulary.
class LdpPredicates {
  // coverage:ignore-start
  const LdpPredicates._();
  // coverage:ignore-end

  /// IRI for ldp:contains
  /// [Spec](https://www.w3.org/TR/ldp/#ldpc-containsrel)
  ///
  /// Links a container to resources created through the container.
  static const contains = IriTerm.prevalidated('${Ldp.namespace}contains');

  /// IRI for ldp:member
  /// [Spec](https://www.w3.org/TR/ldp/#dfn-ldp-member)
  ///
  /// LDP servers use this predicate to express membership of a resource in a container.
  static const member = IriTerm.prevalidated('${Ldp.namespace}member');

  /// IRI for ldp:membershipResource
  /// [Spec](https://www.w3.org/TR/ldp/#dfn-membership-resource)
  ///
  /// The resource whose membership is being specified with a membership triple.
  static const membershipResource = IriTerm.prevalidated(
    '${Ldp.namespace}membershipResource',
  );

  /// IRI for ldp:hasMemberRelation
  /// [Spec](https://www.w3.org/TR/ldp/#dfn-membership-predicate)
  ///
  /// The predicate used in membership triples where the object is the member resource.
  static const hasMemberRelation = IriTerm.prevalidated(
    '${Ldp.namespace}hasMemberRelation',
  );

  /// IRI for ldp:isMemberOfRelation
  /// [Spec](https://www.w3.org/TR/ldp/#dfn-membership-predicate)
  ///
  /// The predicate used in membership triples where the subject is the member resource.
  static const isMemberOfRelation = IriTerm.prevalidated(
    '${Ldp.namespace}isMemberOfRelation',
  );

  /// IRI for ldp:insertedContentRelation
  /// [Spec](https://www.w3.org/TR/ldp/#dfn-membership-constant)
  ///
  /// Specifies how the member resource is identified for indirect containers: either the URI value in the member resource's ldp:membershipResource triple, or the resource itself.
  static const insertedContentRelation = IriTerm.prevalidated(
    '${Ldp.namespace}insertedContentRelation',
  );

  /// IRI for ldp:constrain
  /// [Spec](https://www.w3.org/TR/ldp/#constraints)
  ///
  /// Links to a constraint document for the resource.
  static const constrainedBy = IriTerm.prevalidated(
    '${Ldp.namespace}constrainedBy',
  );
}

/// LDP preference constants.
///
/// Contains IRIs for LDP preferences that can be used in the Prefer header.
class LdpPreferences {
  const LdpPreferences._();

  /// IRI for ldp:PreferContainment
  /// [Spec](https://www.w3.org/TR/ldp/#prefer-parameters)
  ///
  /// Preference to include containment triples.
  static const preferContainment = IriTerm.prevalidated(
    '${Ldp.namespace}PreferContainment',
  );

  /// IRI for ldp:PreferMembership
  /// [Spec](https://www.w3.org/TR/ldp/#prefer-parameters)
  ///
  /// Preference to include membership triples.
  static const preferMembership = IriTerm.prevalidated(
    '${Ldp.namespace}PreferMembership',
  );

  /// IRI for ldp:PreferMinimalContainer
  /// [Spec](https://www.w3.org/TR/ldp/#prefer-parameters)
  ///
  /// Preference to exclude containment and membership triples.
  static const preferMinimalContainer = IriTerm.prevalidated(
    '${Ldp.namespace}PreferMinimalContainer',
  );
}
