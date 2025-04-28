import 'package:rdf_core/src/graph/rdf_graph.dart';
import 'package:rdf_core/src/plugin/format_plugin.dart';
import 'package:rdf_core/src/rdf_serializer.dart';
import 'package:rdf_core/src/turtle/turtle_format.dart';
import 'package:test/test.dart';

void main() {
  late RdfFormatRegistry registry;
  late RdfSerializerFactory factory;

  setUp(() {
    registry = RdfFormatRegistry();
    factory = RdfSerializerFactory(registry);

    // Register Turtle format for testing
    registry.registerFormat(const TurtleFormat());
  });

  group('RdfSerializerFactory', () {
    test('returns Turtle serializer for null content type', () {
      // Since we registered Turtle as the only format, it will be the default
      final serializer = factory.createSerializer();
      expect(serializer, isA<RdfSerializer>());
    });

    test('returns Turtle serializer for turtle content type', () {
      final serializer = factory.createSerializer(contentType: 'text/turtle');
      expect(serializer, isA<RdfSerializer>());
    });

    test('throws for unsupported content type', () {
      expect(
        () => factory.createSerializer(contentType: 'application/unsupported'),
        throwsA(isA<FormatNotSupportedException>()),
      );
    });

    test('convenience write method works', () {
      final graph = RdfGraph();
      final result = factory.write(graph, contentType: 'text/turtle');
      expect(result, isA<String>());
    });
  });
}
