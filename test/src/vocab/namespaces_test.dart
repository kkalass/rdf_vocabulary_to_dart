// Tests for the RDF Namespace mappings
import 'package:rdf_core/src/vocab/namespaces.dart';
import 'package:rdf_core/vocab.dart';
import 'package:test/test.dart';

void main() {
  group('RdfNamespaceMappings', () {
    final rdfNamespaceMappings = RdfNamespaceMappings();

    test('contains correct mappings for all supported vocabularies', () {
      expect(rdfNamespaceMappings['acl'], equals(Acl.namespace));
      expect(rdfNamespaceMappings['dc'], equals(Dc.namespace));
      expect(rdfNamespaceMappings['dcterms'], equals(DcTerms.namespace));
      expect(rdfNamespaceMappings['foaf'], equals(Foaf.namespace));
      expect(rdfNamespaceMappings['ldp'], equals(Ldp.namespace));
      expect(rdfNamespaceMappings['owl'], equals(Owl.namespace));
      expect(rdfNamespaceMappings['rdf'], equals(Rdf.namespace));
      expect(rdfNamespaceMappings['rdfs'], equals(Rdfs.namespace));
      expect(rdfNamespaceMappings['schema'], equals(Schema.namespace));
      expect(rdfNamespaceMappings['skos'], equals(Skos.namespace));
      expect(rdfNamespaceMappings['solid'], equals(Solid.namespace));
      expect(rdfNamespaceMappings['vcard'], equals(Vcard.namespace));
      expect(rdfNamespaceMappings['xsd'], equals(Xsd.namespace));
    });

    test('prefixes match their respective class prefix constants', () {
      expect(rdfNamespaceMappings[Acl.prefix], equals(Acl.namespace));
      expect(rdfNamespaceMappings[Dc.prefix], equals(Dc.namespace));
      expect(rdfNamespaceMappings[DcTerms.prefix], equals(DcTerms.namespace));
      expect(rdfNamespaceMappings[Foaf.prefix], equals(Foaf.namespace));
      expect(rdfNamespaceMappings[Ldp.prefix], equals(Ldp.namespace));
      expect(rdfNamespaceMappings[Owl.prefix], equals(Owl.namespace));
      expect(rdfNamespaceMappings[Rdf.prefix], equals(Rdf.namespace));
      expect(rdfNamespaceMappings[Rdfs.prefix], equals(Rdfs.namespace));
      expect(rdfNamespaceMappings[Schema.prefix], equals(Schema.namespace));
      expect(rdfNamespaceMappings[Skos.prefix], equals(Skos.namespace));
      expect(rdfNamespaceMappings[Solid.prefix], equals(Solid.namespace));
      expect(rdfNamespaceMappings[Vcard.prefix], equals(Vcard.namespace));
      expect(rdfNamespaceMappings[Xsd.prefix], equals(Xsd.namespace));
    });

    test('contains all required vocabularies', () {
      final requiredPrefixes = [
        'acl',
        'dc',
        'dcterms',
        'foaf',
        'ldp',
        'owl',
        'rdf',
        'rdfs',
        'schema',
        'skos',
        'solid',
        'vcard',
        'xsd',
      ];

      for (final prefix in requiredPrefixes) {
        expect(
          rdfNamespaceMappings.containsKey(prefix),
          isTrue,
          reason: "Missing namespace mapping for prefix: $prefix",
        );
      }

      expect(
        rdfNamespaceMappings.length,
        equals(requiredPrefixes.length),
        reason: "Different number of mappings than expected",
      );
    });

    group('custom mappings', () {
      test('custom mappings override standard mappings', () {
        final customMappings = {
          'rdf': 'http://custom.org/rdf#',
          'custom': 'http://example.org/custom#',
        };

        final mappings = RdfNamespaceMappings.custom(customMappings);

        // Custom mapping should override standard mapping
        expect(mappings['rdf'], equals('http://custom.org/rdf#'));
        expect(mappings['rdf'], isNot(equals(Rdf.namespace)));

        // Custom mapping should be present
        expect(mappings['custom'], equals('http://example.org/custom#'));

        // Standard mappings should still be available
        expect(mappings['owl'], equals(Owl.namespace));
      });

      test('constructor creates immutable instance', () {
        final customMappings = {'custom': 'http://example.org/custom#'};

        final mappings = RdfNamespaceMappings.custom(customMappings);

        // Modifying the original map should not affect the instance
        customMappings['custom'] = 'http://changed.org/';

        expect(mappings['custom'], equals('http://example.org/custom#'));
      });
    });

    group('spread operator support', () {
      test('supports spread operator via asMap() in map literals', () {
        final mappings = RdfNamespaceMappings();

        // Create a new map using spread operator
        final extended = {
          ...mappings.asMap(),
          'custom': 'http://example.org/custom#',
        };

        // Should contain both standard and custom mappings
        expect(extended['rdf'], equals(Rdf.namespace));
        expect(extended['custom'], equals('http://example.org/custom#'));
      });

      test('spread operator with customized mappings', () {
        final customMappings = {'ex': 'http://example.org/'};

        final mappings = RdfNamespaceMappings.custom(customMappings);

        // Create a new map using spread operator
        final extended = {
          ...mappings.asMap(),
          'another': 'http://another.org/',
        };

        // Should contain standard, custom and extended mappings
        expect(extended['rdf'], equals(Rdf.namespace));
        expect(extended['ex'], equals('http://example.org/'));
        expect(extended['another'], equals('http://another.org/'));
      });

      test('spread operator retains all original entries', () {
        final mappings = RdfNamespaceMappings();
        final map = {...mappings.asMap()};

        expect(map.length, equals(mappings.length));

        // Check that map contains expected keys/values
        expect(map['rdf'], equals(Rdf.namespace));
        expect(map['xsd'], equals(Xsd.namespace));
      });
    });

    group('utility methods', () {
      test('asMap returns unmodifiable map view', () {
        final mappings = RdfNamespaceMappings();
        final map = mappings.asMap();

        expect(map['rdf'], equals(Rdf.namespace));

        // Verify it's an unmodifiable map
        expect(() => map['test'] = 'value', throwsUnsupportedError);
      });

      test('containsKey checks for existence of prefix', () {
        final mappings = RdfNamespaceMappings();

        expect(mappings.containsKey('rdf'), isTrue);
        expect(mappings.containsKey('nonexistent'), isFalse);
      });

      test('length returns correct number of mappings', () {
        final mappings = RdfNamespaceMappings();

        expect(
          mappings.length,
          equals(13),
        ); // Match with number of standard namespaces
      });
    });

    test('const constructor produces identical instances', () {
      const mappings1 = RdfNamespaceMappings();
      const mappings2 = RdfNamespaceMappings();

      // Should be identical (same instance) due to const constructor
      expect(identical(mappings1, mappings2), isTrue);
    });
  });
}
