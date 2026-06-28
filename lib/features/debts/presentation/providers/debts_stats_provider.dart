import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/debts/presentation/providers/debts_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebtStats {
  const DebtStats({
    required this.activeCount,
    required this.totalsOriginalByCurrency,
    required this.totalsRemainingByCurrency,
  });

  final int activeCount;
  final Map<String, Money> totalsOriginalByCurrency;
  final Map<String, Money> totalsRemainingByCurrency;
}

final debtStatsProvider = Provider<AsyncValue<DebtStats>>((ref) {
  final debtsAsync = ref.watch(debtsProvider);

  return debtsAsync.whenData((debts) {
    final activeDebts = debts.where((d) => d.isActive).toList();

    final Map<String, Money> original = {};
    final Map<String, Money> remaining = {};

    for (final debt in activeDebts) {
      final code = debt.amount.currency.code;

      if (original.containsKey(code)) {
        original[code] = original[code]! + debt.amount;
        remaining[code] = remaining[code]! + debt.remainingAmount;
      } else {
        original[code] = debt.amount;
        remaining[code] = debt.remainingAmount;
      }
    }

    return DebtStats(
      activeCount: activeDebts.length,
      totalsOriginalByCurrency: original,
      totalsRemainingByCurrency: remaining,
    );
  });
});
