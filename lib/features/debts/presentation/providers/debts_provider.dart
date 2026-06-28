import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/auth/presentation/providers.dart';
import 'package:boveda_personal/features/debts/domain/entities/debt.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/presentation/providers.dart';
import 'package:boveda_personal/features/dashboard/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class DebtsNotifier extends Notifier<AsyncValue<List<Debt>>> {
  @override
  AsyncValue<List<Debt>> build() {
    _loadDebts();
    return const AsyncValue.loading();
  }

  Future<void> _loadDebts() async {
    final session = ref.watch(sessionProvider);
    if (!session.isAuthenticated || session.userId == null) {
      state = const AsyncValue.data([]);
      return;
    }

    try {
      final repo = ref.read(debtRepositoryProvider);
      final debts = await repo.getAll(session.userId!);
      state = AsyncValue.data(debts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addDebt(Debt debt) async {
    final session = ref.read(sessionProvider);
    if (!session.isAuthenticated || session.userId == null) return;

    try {
      final repo = ref.read(debtRepositoryProvider);
      await repo.save(debt, session.userId!);
      _loadDebts();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDebt(Debt debt) async {
    final session = ref.read(sessionProvider);
    if (!session.isAuthenticated || session.userId == null) return;

    try {
      final repo = ref.read(debtRepositoryProvider);
      await repo.save(debt, session.userId!);
      _loadDebts();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDebt(String id) async {
    final session = ref.read(sessionProvider);
    if (!session.isAuthenticated || session.userId == null) return;

    try {
      final repo = ref.read(debtRepositoryProvider);
      await repo.delete(id, session.userId!);
      _loadDebts();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> payDebt(Debt debt, String accountId, Money paymentAmount) async {
    final session = ref.read(sessionProvider);
    if (!session.isAuthenticated || session.userId == null) return;

    try {
      // 1. Create the movement
      final movement = Movement(
        id: const Uuid().v4(),
        accountId: accountId,
        categoryId: 'expense-debts', // System category
        type: MovementType.expense,
        amount: paymentAmount,
        occurredAt: DateTime.now(),
        note: 'Abono a deuda: ${debt.name}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final success = await ref.read(createMovementProvider.notifier).create(movement);
      if (!success) {
        throw Exception('No se pudo registrar el pago. Verifica tu saldo.');
      }

      // 2. Update the debt remaining balance and installments
      final newRemainingMinor = debt.remainingAmount.minorUnits - paymentAmount.minorUnits;
      final newRemaining = Money(
        minorUnits: newRemainingMinor < 0 ? 0 : newRemainingMinor,
        currency: debt.amount.currency,
      );

      final updatedDebt = debt.copyWith(
        remainingAmount: newRemaining,
        paidInstallments: debt.paidInstallments + 1,
        isActive: newRemainingMinor > 0, // If paid in full, make it inactive optionally? Let's keep user's active/inactive choice, but if it reaches 0 we can auto close it
      );
      
      final repo = ref.read(debtRepositoryProvider);
      await repo.save(updatedDebt, session.userId!);
      
      ref.invalidate(accountBalancesProvider);
      ref.invalidate(recentMovementsProvider);
      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(wealthEvolutionProvider);
      
      _loadDebts();
    } catch (e) {
      rethrow;
    }
  }
}

final debtsProvider = NotifierProvider<DebtsNotifier, AsyncValue<List<Debt>>>(
  DebtsNotifier.new,
);
