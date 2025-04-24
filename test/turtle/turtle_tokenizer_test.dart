import 'package:test/test.dart';
import 'package:rdf_core/turtle/turtle_tokenizer.dart';

void main() {
  group('TurtleTokenizer', () {
    test('should tokenize prefixes', () {
      final tokenizer = TurtleTokenizer(
        '@prefix solid: <http://www.w3.org/ns/solid/terms#> .',
      );
      expect(tokenizer.nextToken().type, equals(TokenType.prefix));
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should tokenize IRIs', () {
      final tokenizer = TurtleTokenizer('<http://example.com/foo>');
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should tokenize blank nodes', () {
      final tokenizer = TurtleTokenizer('_:b1');
      expect(tokenizer.nextToken().type, equals(TokenType.blankNode));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should tokenize literals', () {
      final tokenizer = TurtleTokenizer('"Hello, World!"');
      expect(tokenizer.nextToken().type, equals(TokenType.literal));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should tokenize typed literals', () {
      final tokenizer = TurtleTokenizer(
        '"42"^^<http://www.w3.org/2001/XMLSchema#integer>',
      );
      final literalToken = tokenizer.nextToken();
      expect(literalToken.type, equals(TokenType.literal));
      expect(
        literalToken.value,
        equals('"42"^^<http://www.w3.org/2001/XMLSchema#integer>'),
      );
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should tokenize typed literals with prefixed name as type', () {
      final tokenizer = TurtleTokenizer('"42"^^xsd:integer');
      final literalToken = tokenizer.nextToken();
      expect(literalToken.type, equals(TokenType.literal));
      expect(literalToken.value, equals('"42"^^xsd:integer'));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should tokenize language-tagged literals', () {
      final tokenizer = TurtleTokenizer('"Hello"@en');
      expect(tokenizer.nextToken().type, equals(TokenType.literal));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should tokenize triples', () {
      final tokenizer = TurtleTokenizer(
        '<http://example.com/foo> <http://example.com/bar> "baz" .',
      );
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.literal));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should tokenize blank node triples', () {
      final tokenizer = TurtleTokenizer('[ <http://example.com/bar> "baz" ] .');
      expect(tokenizer.nextToken().type, equals(TokenType.openBracket));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.literal));
      expect(tokenizer.nextToken().type, equals(TokenType.closeBracket));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should tokenize semicolon-separated triples', () {
      final tokenizer = TurtleTokenizer(
        '<http://example.com/foo> <http://example.com/bar> "baz" ; <http://example.com/qux> "quux" .',
      );
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.literal));
      expect(tokenizer.nextToken().type, equals(TokenType.semicolon));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.literal));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should tokenize a type declaration', () {
      final tokenizer = TurtleTokenizer(
        '<http://example.com/foo> a <http://example.com/Bar> .',
      );
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.a));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should not include dots in prefixed names', () {
      final tokenizer = TurtleTokenizer(
        'pro:card a foaf:PersonalProfileDocument; foaf:maker :me; foaf:primaryTopic :me.',
      );
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.a));
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.semicolon));
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.semicolon));
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should skip comments', () {
      final tokenizer = TurtleTokenizer(
        '<http://example.com/foo> # This is a comment\n <http://example.com/bar> "baz" .',
      );
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.literal));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should handle inline comments', () {
      final tokenizer = TurtleTokenizer('''
        <http://example.com/foo> # Comment after IRI
        <http://example.com/bar> # Another comment
        "baz" . # Comment after statement
      ''');
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.literal));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should handle escaped characters in literals', () {
      final tokenizer = TurtleTokenizer('"Hello\\nWorld"');
      final token = tokenizer.nextToken();
      expect(token.type, equals(TokenType.literal));
      expect(token.value, equals('"Hello\\nWorld"'));
    });

    test('should handle Unicode escape sequences in literals', () {
      final tokenizer = TurtleTokenizer('"Copyright \\u00A9"');
      final token = tokenizer.nextToken();
      expect(token.type, equals(TokenType.literal));
      expect(token.value, equals('"Copyright \\u00A9"'));
    });

    test('should track line numbers correctly', () {
      final tokenizer = TurtleTokenizer('''
        <http://example.com/foo>
        <http://example.com/bar>
        "baz" .
      ''');

      final token1 = tokenizer.nextToken(); // First IRI
      final token2 = tokenizer.nextToken(); // Second IRI
      final token3 = tokenizer.nextToken(); // Literal

      expect(token1.line, equals(1));
      expect(token2.line, equals(2));
      expect(token3.line, equals(3));
    });

    test('should throw FormatException for unclosed IRI', () {
      final tokenizer = TurtleTokenizer('<http://example.com/foo');
      expect(() => tokenizer.nextToken(), throwsFormatException);
    });

    test('should throw FormatException for unclosed literal', () {
      final tokenizer = TurtleTokenizer('"unclosed literal');
      expect(() => tokenizer.nextToken(), throwsFormatException);
    });

    test('should tokenize multiple prefixes', () {
      final tokenizer = TurtleTokenizer('''
        @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
        @prefix foaf: <http://xmlns.com/foaf/0.1/> .
      ''');

      // First prefix declaration
      expect(tokenizer.nextToken().type, equals(TokenType.prefix));
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));

      // Second prefix declaration
      expect(tokenizer.nextToken().type, equals(TokenType.prefix));
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));

      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should recognize @prefix directive', () {
      final tokenizer = TurtleTokenizer(
        '@prefix foaf: <http://xmlns.com/foaf/0.1/> .',
      );

      final token1 = tokenizer.nextToken();
      expect(token1.type, equals(TokenType.prefix));
      expect(token1.value, equals('@prefix'));

      final token2 = tokenizer.nextToken();
      expect(token2.type, equals(TokenType.prefixedName));
      expect(token2.value, equals('foaf:'));

      final token3 = tokenizer.nextToken();
      expect(token3.type, equals(TokenType.iri));
      expect(token3.value, equals('<http://xmlns.com/foaf/0.1/>'));

      final token4 = tokenizer.nextToken();
      expect(token4.type, equals(TokenType.dot));
    });

    test('should recognize @base directive', () {
      final tokenizer = TurtleTokenizer('@base <http://example.org/> .');

      final token1 = tokenizer.nextToken();
      expect(token1.type, equals(TokenType.base));
      expect(token1.value, equals('@base'));

      final token2 = tokenizer.nextToken();
      expect(token2.type, equals(TokenType.iri));
      expect(token2.value, equals('<http://example.org/>'));

      final token3 = tokenizer.nextToken();
      expect(token3.type, equals(TokenType.dot));
    });

    test('should recognize IRIs', () {
      final tokenizer = TurtleTokenizer(
        '<http://example.org/subject> <http://example.org/predicate> <http://example.org/object> .',
      );

      final token1 = tokenizer.nextToken();
      expect(token1.type, equals(TokenType.iri));
      expect(token1.value, equals('<http://example.org/subject>'));

      final token2 = tokenizer.nextToken();
      expect(token2.type, equals(TokenType.iri));
      expect(token2.value, equals('<http://example.org/predicate>'));

      final token3 = tokenizer.nextToken();
      expect(token3.type, equals(TokenType.iri));
      expect(token3.value, equals('<http://example.org/object>'));

      final token4 = tokenizer.nextToken();
      expect(token4.type, equals(TokenType.dot));
    });

    test('should recognize relative IRIs', () {
      final tokenizer = TurtleTokenizer('<subject> <predicate> <object> .');

      final token1 = tokenizer.nextToken();
      expect(token1.type, equals(TokenType.iri));
      expect(token1.value, equals('<subject>'));

      final token2 = tokenizer.nextToken();
      expect(token2.type, equals(TokenType.iri));
      expect(token2.value, equals('<predicate>'));

      final token3 = tokenizer.nextToken();
      expect(token3.type, equals(TokenType.iri));
      expect(token3.value, equals('<object>'));

      final token4 = tokenizer.nextToken();
      expect(token4.type, equals(TokenType.dot));
    });

    test('should recognize mixed prefix, base and triple statements', () {
      final input = '''
        @prefix ex: <http://example.org/> .
        @base <http://example.org/base/> .
        
        <relative> a ex:Type .
      ''';
      final tokenizer = TurtleTokenizer(input);

      // @prefix statement
      expect(tokenizer.nextToken().type, equals(TokenType.prefix));
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));

      // @base statement
      expect(tokenizer.nextToken().type, equals(TokenType.base));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));

      // triple statement
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.a));
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));

      // End of input
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });

    test('should handle comments and whitespace', () {
      final input = '''
        # This is a comment
        @prefix ex: <http://example.org/> . # Comment after statement
        
        # Comment before @base
        @base <http://example.org/base/> .
        
        # Comment before triple
        <subject> a ex:Type . # Comment after triple
      ''';
      final tokenizer = TurtleTokenizer(input);

      // @prefix statement
      expect(tokenizer.nextToken().type, equals(TokenType.prefix));
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));

      // @base statement
      expect(tokenizer.nextToken().type, equals(TokenType.base));
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));

      // triple statement
      expect(tokenizer.nextToken().type, equals(TokenType.iri));
      expect(tokenizer.nextToken().type, equals(TokenType.a));
      expect(tokenizer.nextToken().type, equals(TokenType.prefixedName));
      expect(tokenizer.nextToken().type, equals(TokenType.dot));

      // End of input
      expect(tokenizer.nextToken().type, equals(TokenType.eof));
    });
  });
}
