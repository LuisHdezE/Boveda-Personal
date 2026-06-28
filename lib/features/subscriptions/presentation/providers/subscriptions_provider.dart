import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/dashboard/presentation/providers.dart';
import 'package:boveda_personal/features/auth/presentation/providers.dart';
import 'package:boveda_personal/features/subscriptions/domain/entities/subscription.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';

final subscriptionsProvider =
    AsyncNotifierProvider<SubscriptionsNotifier, List<Subscription>>(
      SubscriptionsNotifier.new,
    );

class SubscriptionsNotifier extends AsyncNotifier<List<Subscription>> {
  @override
  Future<List<Subscription>> build() async {
    return _fetchSubscriptions();
  }

  Future<List<Subscription>> _fetchSubscriptions() async {
    final session = ref.read(sessionProvider);
    if (!session.isAuthenticated || session.userId == null) {
      return [];
    }
    final repository = ref.read(subscriptionRepositoryProvider);
    return repository.getAll(session.userId!);
  }

  Future<void> addSubscription(Subscription subscription) async {
    final session = ref.read(sessionProvider);
    if (!session.isAuthenticated || session.userId == null) return;

    final repository = ref.read(subscriptionRepositoryProvider);
    await repository.save(subscription, session.userId!);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchSubscriptions());
  }

  Future<void> updateSubscription(Subscription subscription) async {
    await addSubscription(subscription);
  }

  Future<void> deleteSubscription(String id) async {
    final session = ref.read(sessionProvider);
    if (!session.isAuthenticated || session.userId == null) return;

    final repository = ref.read(subscriptionRepositoryProvider);
    await repository.delete(id, session.userId!);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchSubscriptions());
  }

  Future<void> paySubscription(
    Subscription subscription,
    String accountId,
  ) async {
    final session = ref.read(sessionProvider);
    if (!session.isAuthenticated || session.userId == null) return;

    final now = DateTime.now();
    // Validate again just in case
    if (subscription.lastPaymentDate != null &&
        subscription.lastPaymentDate!.year == now.year &&
        subscription.lastPaymentDate!.month == now.month) {
      throw Exception('Esta suscripción ya ha sido pagada este mes.');
    }

    // 1. Balance Validation
    final accountRepo = ref.read(accountRepositoryProvider);
    final balances = await accountRepo.balances();
    final accountBalance = balances.firstWhere(
      (b) => b.accountId == accountId,
      orElse: () => throw Exception('Cuenta no encontrada.'),
    );

    if (accountBalance.currency.code != subscription.amount.currency.code) {
      throw Exception('La moneda de la cuenta no coincide con la suscripción.');
    }

    if (accountBalance.balance.minorUnits < subscription.amount.minorUnits) {
      throw Exception('Saldo insuficiente en la cuenta para realizar el pago.');
    }

    // 2. Create Expense Movement
    final movementRepository = ref.read(movementRepositoryProvider);
    final idGenerator = ref.read(idGeneratorProvider);

    final movement = Movement(
      id: idGenerator.next(),
      accountId: accountId,
      categoryId: 'expense-subscriptions',
      type: MovementType.expense,
      amount: subscription.amount,
      occurredAt: now,
      note: 'Pago de suscripción: ${subscription.name}',
      createdAt: now,
      updatedAt: now,
    );
    await movementRepository.create(movement);

    // 2. Update Subscription
    DateTime nextBilling = subscription.nextBillingDate;
    if (subscription.billingCycle == 'monthly') {
      nextBilling = DateTime(
        nextBilling.year,
        nextBilling.month + 1,
        nextBilling.day,
      );
    } else if (subscription.billingCycle == 'yearly') {
      nextBilling = DateTime(
        nextBilling.year + 1,
        nextBilling.month,
        nextBilling.day,
      );
    } else if (subscription.billingCycle == 'weekly') {
      nextBilling = nextBilling.add(const Duration(days: 7));
    }

    final updatedSubscription = subscription.copyWith(
      lastPaymentDate: now,
      nextBillingDate: nextBilling,
    );

    final repository = ref.read(subscriptionRepositoryProvider);
    await repository.save(updatedSubscription, session.userId!);

    // Refresh state
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchSubscriptions());

    // Also invalidate dashboard providers
    ref.invalidate(accountBalancesProvider);
    ref.invalidate(recentMovementsProvider);
    ref.invalidate(dashboardSummaryProvider);
    ref.invalidate(wealthEvolutionProvider);
  }
}
