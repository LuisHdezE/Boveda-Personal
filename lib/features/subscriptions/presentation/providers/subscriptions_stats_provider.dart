import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/subscriptions/domain/entities/subscription.dart';
import 'package:boveda_personal/features/subscriptions/presentation/providers/subscriptions_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionStats {
  const SubscriptionStats({
    required this.activeCount,
    required this.totalsMonthlyByCurrency,
    required this.totalsYearlyByCurrency,
    required this.cycleDistribution,
    this.mostExpensiveSubscription,
  });

  final int activeCount;
  final Map<String, Money> totalsMonthlyByCurrency;
  final Map<String, Money> totalsYearlyByCurrency;
  final Map<String, int> cycleDistribution;
  final Subscription? mostExpensiveSubscription;
}

final subscriptionStatsProvider = Provider<AsyncValue<SubscriptionStats>>((
  ref,
) {
  final subscriptionsAsync = ref.watch(subscriptionsProvider);

  return subscriptionsAsync.whenData((subscriptions) {
    final activeSubscriptions = subscriptions.where((s) => s.isActive).toList();

    final Map<String, Money> totalsMonthly = {};
    final Map<String, Money> totalsYearly = {};
    final Map<String, int> cycleDist = {};
    Subscription? mostExpensive;
    double maxMonthlyValue = 0.0; // En minor units sin importar moneda (aproximación para destacar una, o podríamos separar por moneda)

    for (final sub in activeSubscriptions) {
      final code = sub.amount.currency.code;
      
      cycleDist[sub.billingCycle] = (cycleDist[sub.billingCycle] ?? 0) + 1;

      // Approximate monthly cost
      double factor = 1.0;
      if (sub.billingCycle == 'yearly') factor = 1 / 12;
      if (sub.billingCycle == 'weekly') factor = 4.33;

      final monthlyAmountMinor = (sub.amount.minorUnits * factor).round();
      final yearlyAmountMinor = monthlyAmountMinor * 12;
      
      if (monthlyAmountMinor > maxMonthlyValue) {
        maxMonthlyValue = monthlyAmountMinor.toDouble();
        mostExpensive = sub;
      }

      if (totalsMonthly.containsKey(code)) {
        totalsMonthly[code] = totalsMonthly[code]! + Money(minorUnits: monthlyAmountMinor, currency: sub.amount.currency);
        totalsYearly[code] = totalsYearly[code]! + Money(minorUnits: yearlyAmountMinor, currency: sub.amount.currency);
      } else {
        totalsMonthly[code] = Money(minorUnits: monthlyAmountMinor, currency: sub.amount.currency);
        totalsYearly[code] = Money(minorUnits: yearlyAmountMinor, currency: sub.amount.currency);
      }
    }

    return SubscriptionStats(
      activeCount: activeSubscriptions.length,
      totalsMonthlyByCurrency: totalsMonthly,
      totalsYearlyByCurrency: totalsYearly,
      cycleDistribution: cycleDist,
      mostExpensiveSubscription: mostExpensive,
    );
  });
});
