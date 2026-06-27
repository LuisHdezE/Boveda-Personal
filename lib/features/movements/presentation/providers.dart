import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovementFilterNotifier extends Notifier<MovementFilter> {
  @override
  MovementFilter build() => MovementFilter();

  void updateFilter(MovementFilter filter) {
    state = filter;
  }
}

/// Estado actual del filtro aplicado en el historial.
final movementFilterProvider = NotifierProvider<MovementFilterNotifier, MovementFilter>(
  MovementFilterNotifier.new,
);

/// Lista paginada de movimientos filtrados.
final movementsProvider = FutureProvider<List<Movement>>((ref) async {
  final filter = ref.watch(movementFilterProvider);
  return ref.watch(movementRepositoryProvider).list(
    filter,
    PageRequest(limit: 50, offset: 0),
  );
});

/// Notifier para crear un movimiento.
class CreateMovementNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> create(Movement movement) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(movementRepositoryProvider).create(movement);
      // Invalidar para refrescar listas
      ref.invalidate(movementsProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final createMovementProvider =
    NotifierProvider<CreateMovementNotifier, AsyncValue<void>>(
  CreateMovementNotifier.new,
);
