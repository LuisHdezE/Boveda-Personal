import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';

abstract interface class MovementRepository {
  Future<Movement?> findById(String id);
  Future<List<Movement>> list(
    MovementFilter filter,
    PageRequest page,
  );
  Future<void> create(Movement movement);
  Future<void> update(Movement movement);
  Future<void> delete(String id);
}
