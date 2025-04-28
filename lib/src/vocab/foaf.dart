/// Friend of a Friend (FOAF) Vocabulary
///
/// Provides constants for the [FOAF vocabulary](http://xmlns.com/foaf/0.1/),
/// which is used for describing people, their activities, and their relations to
/// other people and objects.
///
/// Example usage:
/// ```dart
/// import 'package:rdf_core/src/vocab/foaf.dart';
/// final person = FoafClasses.person;
/// ```
///
/// All constants are pre-constructed as IriTerm objects to enable direct use in
/// constructing RDF graphs without repeated string concatenation or term creation.
///
/// [Specification Reference](http://xmlns.com/foaf/spec/)
library foaf_vocab;

import 'package:rdf_core/src/graph/rdf_term.dart';

/// Base FOAF namespace and utility functions
class Foaf {
  // coverage:ignore-start
  const Foaf._();
  // coverage:ignore-end

  /// Base IRI for FOAF vocabulary
  /// [Spec](http://xmlns.com/foaf/0.1/)
  static const String namespace = 'http://xmlns.com/foaf/0.1/';
  static const String prefix = 'foaf';
}

/// FOAF class constants.
///
/// Contains IRIs that represent classes defined in the FOAF vocabulary.
class FoafClasses {
  // coverage:ignore-start
  const FoafClasses._();
  // coverage:ignore-end

  /// IRI for foaf:Agent
  /// [Spec](http://xmlns.com/foaf/spec/#term_Agent)
  ///
  /// The class of agents - things that do stuff. A well known sub-class is Person.
  static const agent = IriTerm.prevalidated('${Foaf.namespace}Agent');

  /// IRI for foaf:Person
  /// [Spec](http://xmlns.com/foaf/spec/#term_Person)
  ///
  /// The class of people. A person is a type of Agent.
  static const person = IriTerm.prevalidated('${Foaf.namespace}Person');

  /// IRI for foaf:Organization
  /// [Spec](http://xmlns.com/foaf/spec/#term_Organization)
  ///
  /// The class of organizations.
  static const organization = IriTerm.prevalidated(
    '${Foaf.namespace}Organization',
  );

  /// IRI for foaf:Group
  /// [Spec](http://xmlns.com/foaf/spec/#term_Group)
  ///
  /// The class of groups. A group is a collection of agents.
  static const group = IriTerm.prevalidated('${Foaf.namespace}Group');

  /// IRI for foaf:Document
  /// [Spec](http://xmlns.com/foaf/spec/#term_Document)
  ///
  /// The class of documents.
  static const document = IriTerm.prevalidated('${Foaf.namespace}Document');

  /// IRI for foaf:Project
  /// [Spec](http://xmlns.com/foaf/spec/#term_Project)
  ///
  /// The class of projects (collaborative endeavors).
  static const project = IriTerm.prevalidated('${Foaf.namespace}Project');

  /// IRI for foaf:Image
  /// [Spec](http://xmlns.com/foaf/spec/#term_Image)
  ///
  /// The class of images. A subclass of Document.
  static const image = IriTerm.prevalidated('${Foaf.namespace}Image');

  /// IRI for foaf:OnlineAccount
  /// [Spec](http://xmlns.com/foaf/spec/#term_OnlineAccount)
  ///
  /// The class of online accounts.
  static const onlineAccount = IriTerm.prevalidated(
    '${Foaf.namespace}OnlineAccount',
  );
}

/// FOAF predicate constants.
///
/// Contains IRIs for properties defined in the FOAF vocabulary.
class FoafPredicates {
  // coverage:ignore-start
  const FoafPredicates._();
  // coverage:ignore-end

  /// IRI for foaf:name
  /// [Spec](http://xmlns.com/foaf/spec/#term_name)
  ///
  /// A name for some thing.
  static const name = IriTerm.prevalidated('${Foaf.namespace}name');

  /// IRI for foaf:givenName
  /// [Spec](http://xmlns.com/foaf/spec/#term_givenName)
  ///
  /// The given name of a person.
  static const givenName = IriTerm.prevalidated('${Foaf.namespace}givenName');

  /// IRI for foaf:familyName
  /// [Spec](http://xmlns.com/foaf/spec/#term_familyName)
  ///
  /// The family name of a person.
  static const familyName = IriTerm.prevalidated('${Foaf.namespace}familyName');

  /// IRI for foaf:knows
  /// [Spec](http://xmlns.com/foaf/spec/#term_knows)
  ///
  /// Indicates that a person knows another person.
  static const knows = IriTerm.prevalidated('${Foaf.namespace}knows');

  /// IRI for foaf:mbox
  /// [Spec](http://xmlns.com/foaf/spec/#term_mbox)
  ///
  /// The personal mailbox of an agent. A URI for a mailbox.
  static const mbox = IriTerm.prevalidated('${Foaf.namespace}mbox');

  /// IRI for foaf:mbox_sha1sum
  /// [Spec](http://xmlns.com/foaf/spec/#term_mbox_sha1sum)
  ///
  /// The sha1sum of the URI of a personal mailbox.
  static const mboxSha1sum = IriTerm.prevalidated(
    '${Foaf.namespace}mbox_sha1sum',
  );

  /// IRI for foaf:homepage
  /// [Spec](http://xmlns.com/foaf/spec/#term_homepage)
  ///
  /// A homepage for some thing.
  static const homepage = IriTerm.prevalidated('${Foaf.namespace}homepage');

  /// IRI for foaf:weblog
  /// [Spec](http://xmlns.com/foaf/spec/#term_weblog)
  ///
  /// A weblog of some thing (person, group, etc.).
  static const weblog = IriTerm.prevalidated('${Foaf.namespace}weblog');

  /// IRI for foaf:img
  /// [Spec](http://xmlns.com/foaf/spec/#term_img)
  ///
  /// An image that depicts some thing.
  static const img = IriTerm.prevalidated('${Foaf.namespace}img');

  /// IRI for foaf:depiction
  /// [Spec](http://xmlns.com/foaf/spec/#term_depiction)
  ///
  /// A depiction of some thing.
  static const depiction = IriTerm.prevalidated('${Foaf.namespace}depiction');

  /// IRI for foaf:depicts
  /// [Spec](http://xmlns.com/foaf/spec/#term_depicts)
  ///
  /// A thing depicted in an image.
  static const depicts = IriTerm.prevalidated('${Foaf.namespace}depicts');

  /// IRI for foaf:member
  /// [Spec](http://xmlns.com/foaf/spec/#term_member)
  ///
  /// Indicates a member of a group.
  static const member = IriTerm.prevalidated('${Foaf.namespace}member');

  /// IRI for foaf:maker
  /// [Spec](http://xmlns.com/foaf/spec/#term_maker)
  ///
  /// The maker/creator of a thing.
  static const maker = IriTerm.prevalidated('${Foaf.namespace}maker');

  /// IRI for foaf:made
  /// [Spec](http://xmlns.com/foaf/spec/#term_made)
  ///
  /// Something that was made/created by an agent.
  static const made = IriTerm.prevalidated('${Foaf.namespace}made');

  /// IRI for foaf:primaryTopic
  /// [Spec](http://xmlns.com/foaf/spec/#term_primaryTopic)
  ///
  /// The primary topic of a document.
  static const primaryTopic = IriTerm.prevalidated(
    '${Foaf.namespace}primaryTopic',
  );

  /// IRI for foaf:isPrimaryTopicOf
  /// [Spec](http://xmlns.com/foaf/spec/#term_isPrimaryTopicOf)
  ///
  /// A document that has this thing as its primary topic.
  static const isPrimaryTopicOf = IriTerm.prevalidated(
    '${Foaf.namespace}isPrimaryTopicOf',
  );

  /// IRI for foaf:topic
  /// [Spec](http://xmlns.com/foaf/spec/#term_topic)
  ///
  /// A topic of a document.
  static const topic = IriTerm.prevalidated('${Foaf.namespace}topic');

  /// IRI for foaf:interest
  /// [Spec](http://xmlns.com/foaf/spec/#term_interest)
  ///
  /// A thing of interest to a person.
  static const interest = IriTerm.prevalidated('${Foaf.namespace}interest');

  /// IRI for foaf:publications
  /// [Spec](http://xmlns.com/foaf/spec/#term_publications)
  ///
  /// A link to a publication list.
  static const publications = IriTerm.prevalidated(
    '${Foaf.namespace}publications',
  );

  /// IRI for foaf:accountName
  /// [Spec](http://xmlns.com/foaf/spec/#term_accountName)
  ///
  /// The name (identifier) associated with an online account.
  static const accountName = IriTerm.prevalidated(
    '${Foaf.namespace}accountName',
  );

  /// IRI for foaf:accountServiceHomepage
  /// [Spec](http://xmlns.com/foaf/spec/#term_accountServiceHomepage)
  ///
  /// The homepage of the service provider for an online account.
  static const accountServiceHomepage = IriTerm.prevalidated(
    '${Foaf.namespace}accountServiceHomepage',
  );
}
