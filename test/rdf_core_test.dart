import 'package:test/test.dart';
import 'package:rdf_core/rdf_core.dart';

void main() {
  test('IRI node creation', () {
    final iri = Iri('http://example.org/foo');
    expect(iri.value, 'http://example.org/foo');
  });

  test('Literal node creation', () {
    final literal = Literal('Hello', language: 'en');
    expect(literal.value, 'Hello');
    expect(literal.language, 'en');
  });

  test('Triple creation', () {
    final s = Iri('http://example.org/s');
    final p = Iri('http://example.org/p');
    final o = Literal('object');
    final triple = Triple(s, p, o);
    expect(triple.subject, s);
    expect(triple.predicate, p);
    expect(triple.object, o);
  });
}
