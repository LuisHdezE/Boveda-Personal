import 'package:boveda_personal/core/infrastructure/uuid_id_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UuidIdGenerator generator;

  setUp(() {
    generator = const UuidIdGenerator();
  });

  test('INFRA-001 genera un ID no vacío', () {
    final id = generator.next();
    expect(id, isNotEmpty);
  });

  test('INFRA-002 genera IDs únicos en llamadas consecutivas', () {
    final ids = List.generate(100, (_) => generator.next()).toSet();
    expect(ids.length, 100);
  });

  test('INFRA-003 el ID tiene formato UUID v4', () {
    final id = generator.next();
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    );
    expect(uuidRegex.hasMatch(id), isTrue);
  });
}
