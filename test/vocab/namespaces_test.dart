// Tests for the RDF Namespace mappings
import 'package:rdf_core/vocab/vocab.dart';
import 'package:test/test.dart';

void main() {
  group('rdfNamespaceMappings', () {
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
        'acl', 'dc', 'dcterms', 'foaf', 'ldp', 'owl', 
        'rdf', 'rdfs', 'schema', 'skos', 'solid', 'vcard', 'xsd'
      ];
      
      for (final prefix in requiredPrefixes) {
        expect(rdfNamespaceMappings.containsKey(prefix), isTrue, 
          reason: "Missing namespace mapping for prefix: $prefix");
      }
      
      expect(rdfNamespaceMappings.length, equals(requiredPrefixes.length), 
        reason: "Different number of mappings than expected");
    });
  });
}