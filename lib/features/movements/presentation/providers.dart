import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/auth/presentation/providers.dart';
import 'package:boveda_personal/features/dashboard/presentation/providers.dart';
import 'package:boveda_personal/features/subscriptions/domain/entities/subscription.dart';
import 'package:boveda_personal/features/subscriptions/presentation/providers/subscriptions_provider.dart';
import 'package:boveda_personal/features/debts/presentation/providers/debts_provider.dart';
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

class DeleteMovementNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<bool> delete(Movement movement) async {
    state = const AsyncValue.loading();
    try {
      // Validate balance for income movements before deleting
      // Validate balance for movements that increased the account balance
      if (movement.type == MovementType.income || movement.type == MovementType.transferIn || movement.type == MovementType.opening) {
        final balances = ref.read(accountBalancesProvider).value;
        if (balances != null) {
          final accountBalance = balances.where((b) => b.accountId == movement.accountId).firstOrNull;
          if (accountBalance != null) {
            final newBalanceMinor = accountBalance.balance.minorUnits - movement.amount.minorUnits;
            if (newBalanceMinor < 0) {
              throw Exception('No se puede eliminar porque dejaría la cuenta con saldo negativo.');
            }
          }
        }
      }

      // Si es un pago de suscripción, revertimos la suscripción
      if (movement.categoryId == 'expense-subscriptions' && movement.note != null && movement.note!.startsWith('Pago de suscripción: ')) {
        final subName = movement.note!.replaceFirst('Pago de suscripción: ', '').trim();
        final session = ref.read(sessionProvider);
        if (session.isAuthenticated && session.userId != null) {
          final subRepo = ref.read(subscriptionRepositoryProvider);
          final subscriptions = await subRepo.getAll(session.userId!);
          final sub = subscriptions.where((s) => s.name == subName).firstOrNull;
          
          if (sub != null) {
            DateTime nextBilling = sub.nextBillingDate;
            if (sub.billingCycle == 'monthly') {
              nextBilling = DateTime(nextBilling.year, nextBilling.month - 1, nextBilling.day);
            } else if (sub.billingCycle == 'yearly') {
              nextBilling = DateTime(nextBilling.year - 1, nextBilling.month, nextBilling.day);
            } else if (sub.billingCycle == 'weekly') {
              nextBilling = nextBilling.subtract(const Duration(days: 7));
            }
            
            final updatedSub = Subscription(
              id: sub.id,
              name: sub.name,
              amount: sub.amount,
              billingCycle: sub.billingCycle,
              nextBillingDate: nextBilling,
              isActive: sub.isActive,
              createdAt: sub.createdAt,
              updatedAt: DateTime.now(),
              lastPaymentDate: null,
            );
            await subRepo.save(updatedSub, session.userId!);
            
            // Invalidar el provider de suscripciones
            ref.invalidate(subscriptionsProvider);
          }
        }
      }

      // Si es un abono a deuda, revertimos la deuda
      if (movement.categoryId == 'expense-debts' && movement.note != null && movement.note!.startsWith('Abono a deuda: ')) {
        final debtName = movement.note!.replaceFirst('Abono a deuda: ', '').trim();
        final session = ref.read(sessionProvider);
        if (session.isAuthenticated && session.userId != null) {
          final debtRepo = ref.read(debtRepositoryProvider);
          final debts = await debtRepo.getAll(session.userId!);
          final debt = debts.where((d) => d.name == debtName).firstOrNull;
          
          if (debt != null) {
            // Restore balance and decrement paidInstallments
            final newRemainingMinor = debt.remainingAmount.minorUnits + movement.amount.minorUnits;
            final updatedDebt = debt.copyWith(
              remainingAmount: Money(minorUnits: newRemainingMinor, currency: debt.amount.currency),
              paidInstallments: debt.paidInstallments > 0 ? debt.paidInstallments - 1 : 0,
              isActive: true, // Always re-activate if a payment is undone and it was closed
            );
            await debtRepo.save(updatedDebt, session.userId!);
          }
        }
      }

      await ref.read(movementRepositoryProvider).delete(movement.id);
      
      // Invalidar todos los estados relevantes del dashboard y movimientos
      ref.invalidate(movementsProvider);
      ref.invalidate(recentMovementsProvider);
      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(accountBalancesProvider);
      ref.invalidate(wealthEvolutionProvider);
      ref.invalidate(debtsProvider);
      
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final deleteMovementProvider =
    NotifierProvider<DeleteMovementNotifier, AsyncValue<void>>(
  DeleteMovementNotifier.new,
);
