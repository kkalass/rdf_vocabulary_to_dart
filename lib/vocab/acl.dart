/// Web Access Control (ACL) Vocabulary
///
/// Provides constants for the [Web Access Control (ACL) vocabulary](http://www.w3.org/ns/auth/acl),
/// which is used for defining access control permissions in web resources.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/vocab/acl.dart';
/// final authorization = AclClasses.authorization;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](http://www.w3.org/ns/auth/acl)
library acl_vocab;

import 'package:rdf_core/graph/rdf_term.dart';

/// Base ACL namespace and utility functions
class Acl {
  // coverage:ignore-start
  const Acl._();
  // coverage:ignore-end

  /// Base IRI for ACL vocabulary
  /// [Spec](http://www.w3.org/ns/auth/acl)
  static const String namespace = 'http://www.w3.org/ns/auth/acl#';
  static const String prefix = 'acl';
}

/// ACL class constants.
///
/// Contains IRIs that represent classes defined in the ACL vocabulary.
class AclClasses {
  // coverage:ignore-start
  const AclClasses._();
  // coverage:ignore-end

  /// IRI for acl:Authorization
  /// [Spec](http://www.w3.org/ns/auth/acl#Authorization)
  ///
  /// An Authorization is a statement of access control for agents over resources.
  static const authorization = IriTerm.prevalidated(
    '${Acl.namespace}Authorization',
  );

  /// IRI for acl:accessControl
  /// [Spec](http://www.w3.org/ns/auth/acl#accessControl)
  ///
  /// The Access Control file for this resource.
  static const accessControl = IriTerm.prevalidated(
    '${Acl.namespace}accessControl',
  );
}

/// ACL mode constants.
///
/// Contains IRIs for access modes defined in the ACL vocabulary.
class AclModes {
  // coverage:ignore-start
  const AclModes._();
  // coverage:ignore-end

  /// IRI for acl:Read
  /// [Spec](http://www.w3.org/ns/auth/acl#Read)
  ///
  /// The class of read operations.
  static const read = IriTerm.prevalidated('${Acl.namespace}Read');

  /// IRI for acl:Write
  /// [Spec](http://www.w3.org/ns/auth/acl#Write)
  ///
  /// The class of write operations.
  static const write = IriTerm.prevalidated('${Acl.namespace}Write');

  /// IRI for acl:Control
  /// [Spec](http://www.w3.org/ns/auth/acl#Control)
  ///
  /// The class of control operations. Control is the permission to set
  /// the Access Control List for the resource.
  static const control = IriTerm.prevalidated('${Acl.namespace}Control');

  /// IRI for acl:Append
  /// [Spec](http://www.w3.org/ns/auth/acl#Append)
  ///
  /// The class of append operations. Append is the permission to add information to a resource
  /// but not to modify or remove information that is already there.
  static const append = IriTerm.prevalidated('${Acl.namespace}Append');
}

/// ACL predicate constants.
///
/// Contains IRIs for properties defined in the ACL vocabulary.
class AclPredicates {
  // coverage:ignore-start
  const AclPredicates._();
  // coverage:ignore-end

  /// IRI for acl:accessTo
  /// [Spec](http://www.w3.org/ns/auth/acl#accessTo)
  ///
  /// The resource to which access is being granted.
  static const accessTo = IriTerm.prevalidated('${Acl.namespace}accessTo');

  /// IRI for acl:accessToClass
  /// [Spec](http://www.w3.org/ns/auth/acl#accessToClass)
  ///
  /// A class of resources to which access is being granted.
  static const accessToClass = IriTerm.prevalidated(
    '${Acl.namespace}accessToClass',
  );

  /// IRI for acl:agent
  /// [Spec](http://www.w3.org/ns/auth/acl#agent)
  ///
  /// The person, group, or system that is being given the right.
  static const agent = IriTerm.prevalidated('${Acl.namespace}agent');

  /// IRI for acl:agentClass
  /// [Spec](http://www.w3.org/ns/auth/acl#agentClass)
  ///
  /// A class of agents being given the right.
  static const agentClass = IriTerm.prevalidated('${Acl.namespace}agentClass');

  /// IRI for acl:agentGroup
  /// [Spec](http://www.w3.org/ns/auth/acl#agentGroup)
  ///
  /// A group of agents being given the right.
  static const agentGroup = IriTerm.prevalidated('${Acl.namespace}agentGroup');

  /// IRI for acl:mode
  /// [Spec](http://www.w3.org/ns/auth/acl#mode)
  ///
  /// The access mode granted to the agent (e.g., Read, Write, Control).
  static const mode = IriTerm.prevalidated('${Acl.namespace}mode');

  /// IRI for acl:default
  /// [Spec](http://www.w3.org/ns/auth/acl#default)
  ///
  /// A resource for which this authorization is the default.
  static const default_ = IriTerm.prevalidated('${Acl.namespace}default');

  /// IRI for acl:defaultForNew
  /// [Spec](http://www.w3.org/ns/auth/acl#defaultForNew)
  ///
  /// A container for which this authorization applies to any new resource in the container.
  static const defaultForNew = IriTerm.prevalidated(
    '${Acl.namespace}defaultForNew',
  );

  /// IRI for acl:origin
  /// [Spec](http://www.w3.org/ns/auth/acl#origin)
  ///
  /// The Origin URL of a third-party application to which access has been granted.
  static const origin = IriTerm.prevalidated('${Acl.namespace}origin');
}
