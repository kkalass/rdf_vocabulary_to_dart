/// Solid Terms Vocabulary
///
/// Provides constants for the [Solid Terms vocabulary](http://www.w3.org/ns/solid/terms)
/// used in the Solid specification.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/vocab/solid.dart';
/// final publicTypeIndex = SolidPredicates.publicTypeIndex;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](http://www.w3.org/ns/solid/terms)
library solid_vocab;

import 'package:rdf_core/graph/rdf_term.dart';

/// Base Solid namespace and utility functions
class Solid {
  const Solid._();

  /// Base IRI for Solid vocabulary
  /// [Spec](http://www.w3.org/ns/solid/terms)
  static const String namespace = 'http://www.w3.org/ns/solid/terms#';
  static const String prefix = 'solid';
}

/// Solid class constants.
///
/// Contains IRIs for classes defined in the Solid vocabulary.
class SolidClasses {
  const SolidClasses._();

  /// IRI for solid:TypeRegistration
  /// [Spec](http://www.w3.org/ns/solid/terms#TypeRegistration)
  ///
  /// A registration that links a type of resource with an application that can be used to interact with resources of that type.
  static const typeRegistration = IriTerm.prevalidated(
    '${Solid.namespace}TypeRegistration',
  );

  /// IRI for solid:TypeIndex
  /// [Spec](http://www.w3.org/ns/solid/terms#TypeIndex)
  ///
  /// A registry of resources that record where to find resources of a particular type in a Solid storage.
  static const typeIndex = IriTerm.prevalidated('${Solid.namespace}TypeIndex');

  /// IRI for solid:InsertDeletePatch
  /// [Spec](http://www.w3.org/ns/solid/terms#InsertDeletePatch)
  ///
  /// A patch to insert or delete triples from a resource.
  static const insertDeletePatch = IriTerm.prevalidated(
    '${Solid.namespace}InsertDeletePatch',
  );

  /// IRI for solid:Notification
  /// [Spec](http://www.w3.org/ns/solid/terms#Notification)
  ///
  /// A notification about an event that occurred.
  static const notification = IriTerm.prevalidated(
    '${Solid.namespace}Notification',
  );

  /// IRI for solid:Workspace
  /// [Spec](http://www.w3.org/ns/solid/terms#Workspace)
  ///
  /// A collection of related containers and resources that are used together.
  static const workspace = IriTerm.prevalidated('${Solid.namespace}Workspace');
}

/// Solid predicates constants.
///
/// Contains IRIs for properties defined in the Solid vocabulary.
class SolidPredicates {
  const SolidPredicates._();

  /// IRI for solid:oidcIssuer
  /// [Spec](http://www.w3.org/ns/solid/terms#oidcIssuer)
  ///
  /// Links to an OpenID Connect issuer that identifies or authenticates the user of a WebID.
  static const oidcIssuer = IriTerm.prevalidated(
    '${Solid.namespace}oidcIssuer',
  );

  /// IRI for solid:publicTypeIndex
  /// [Spec](http://www.w3.org/ns/solid/terms#publicTypeIndex)
  ///
  /// Links to a TypeIndex listing type registrations that are publicly accessible.
  static const publicTypeIndex = IriTerm.prevalidated(
    '${Solid.namespace}publicTypeIndex',
  );

  /// IRI for solid:privateTypeIndex
  /// [Spec](http://www.w3.org/ns/solid/terms#privateTypeIndex)
  ///
  /// Links to a TypeIndex listing type registrations that are private to the user.
  static const privateTypeIndex = IriTerm.prevalidated(
    '${Solid.namespace}privateTypeIndex',
  );

  /// IRI for solid:forClass
  /// [Spec](http://www.w3.org/ns/solid/terms#forClass)
  ///
  /// Links a TypeRegistration to the RDF type it contains instances of.
  static const forClass = IriTerm.prevalidated('${Solid.namespace}forClass');

  /// IRI for solid:instance
  /// [Spec](http://www.w3.org/ns/solid/terms#instance)
  ///
  /// Links a registration in a type index to a resource that is an instance of the registered type.
  static const instance = IriTerm.prevalidated('${Solid.namespace}instance');

  /// IRI for solid:instanceContainer
  /// [Spec](http://www.w3.org/ns/solid/terms#instanceContainer)
  ///
  /// Links a registration in a type index to a container that has resources of the registered type as its members.
  static const instanceContainer = IriTerm.prevalidated(
    '${Solid.namespace}instanceContainer',
  );

  /// IRI for solid:read
  /// [Spec](http://www.w3.org/ns/solid/terms#read)
  ///
  /// Links a resource with a list of agents who have read access to that resource.
  static const read = IriTerm.prevalidated('${Solid.namespace}read');

  /// IRI for solid:write
  /// [Spec](http://www.w3.org/ns/solid/terms#write)
  ///
  /// Links a resource with a list of agents who have write access to that resource.
  static const write = IriTerm.prevalidated('${Solid.namespace}write');

  /// IRI for solid:storageType
  /// [Spec](http://www.w3.org/ns/solid/terms#storageType)
  ///
  /// Links to the type of this storage.
  static const storageType = IriTerm.prevalidated(
    '${Solid.namespace}storageType',
  );

  /// IRI for solid:deletes
  /// [Spec](http://www.w3.org/ns/solid/terms#deletes)
  ///
  /// A resource containing triples to be deleted.
  static const deletes = IriTerm.prevalidated('${Solid.namespace}deletes');

  /// IRI for solid:inserts
  /// [Spec](http://www.w3.org/ns/solid/terms#inserts)
  ///
  /// A resource containing triples to be inserted.
  static const inserts = IriTerm.prevalidated('${Solid.namespace}inserts');

  /// IRI for solid:timeline
  /// [Spec](http://www.w3.org/ns/solid/terms#timeline)
  ///
  /// Links to a resource with notifications about events related to a particular object.
  static const timeline = IriTerm.prevalidated('${Solid.namespace}timeline');

  /// IRI for solid:notification
  /// [Spec](http://www.w3.org/ns/solid/terms#notification)
  ///
  /// Links to a notification about a resource.
  static const notification = IriTerm.prevalidated(
    '${Solid.namespace}notification',
  );

  /// IRI for solid:source
  /// [Spec](http://www.w3.org/ns/solid/terms#source)
  ///
  /// Links an activity to the resource that was the source or target.
  static const source = IriTerm.prevalidated('${Solid.namespace}source');

  /// IRI for solid:workspace
  /// [Spec](http://www.w3.org/ns/solid/terms#workspace)
  ///
  /// Links a service to a workspace.
  static const workspace = IriTerm.prevalidated('${Solid.namespace}workspace');
}
