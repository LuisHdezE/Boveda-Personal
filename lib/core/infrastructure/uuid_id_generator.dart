import 'package:boveda_personal/core/ports/id_generator.dart';
import 'package:uuid/uuid.dart';

/// Implementación de [IdGenerator] usando UUID v4 del paquete `uuid`.
class UuidIdGenerator implements IdGenerator {
  const UuidIdGenerator();

  static const _uuid = Uuid();

  @override
  String next() => _uuid.v4();
}
