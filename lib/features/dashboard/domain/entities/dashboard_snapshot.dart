import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account_balance.dart';
import 'package:collection/collection.dart';

class WealthPoint {
  const WealthPoint({required this.at, required this.value});

  final DateTime at;
  final Money value;

  @override
  bool operator ==(Object other) {
    return other is WealthPoint && other.at == at && other.value == value;
  }

  @override
  int get hashCode => Object.hash(at, value);
}

class DashboardSnapshot {
  DashboardSnapshot({
    required List<AccountBalance> balances,
    required this.totalInPrimaryCurrency,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required List<String> recentMovementIds,
    required List<WealthPoint> wealthEvolution,
    required this.calculatedAt,
  }) : balances = List.unmodifiable(balances),
       recentMovementIds = List.unmodifiable(recentMovementIds),
       wealthEvolution = List.unmodifiable(wealthEvolution) {
    final currency = totalInPrimaryCurrency.currency;
    if (monthlyIncome.currency != currency ||
        monthlyExpense.currency != currency ||
        this.wealthEvolution.any((point) => point.value.currency != currency)) {
      throw ArgumentError('Dashboard metrics must use the primary currency');
    }
    if (!_chronological(this.wealthEvolution.map((point) => point.at))) {
      throw ArgumentError('Wealth evolution must be chronological');
    }
  }

  final List<AccountBalance> balances;
  final Money totalInPrimaryCurrency;
  final Money monthlyIncome;
  final Money monthlyExpense;
  final List<String> recentMovementIds;
  final List<WealthPoint> wealthEvolution;
  final DateTime calculatedAt;

  Money get monthlySavings => monthlyIncome - monthlyExpense;

  @override
  bool operator ==(Object other) {
    return other is DashboardSnapshot &&
        const ListEquality<AccountBalance>().equals(other.balances, balances) &&
        other.totalInPrimaryCurrency == totalInPrimaryCurrency &&
        other.monthlyIncome == monthlyIncome &&
        other.monthlyExpense == monthlyExpense &&
        const ListEquality<String>().equals(
          other.recentMovementIds,
          recentMovementIds,
        ) &&
        const ListEquality<WealthPoint>().equals(
          other.wealthEvolution,
          wealthEvolution,
        ) &&
        other.calculatedAt == calculatedAt;
  }

  @override
  int get hashCode => Object.hash(
    const ListEquality<AccountBalance>().hash(balances),
    totalInPrimaryCurrency,
    monthlyIncome,
    monthlyExpense,
    const ListEquality<String>().hash(recentMovementIds),
    const ListEquality<WealthPoint>().hash(wealthEvolution),
    calculatedAt,
  );
}

bool _chronological(Iterable<DateTime> values) {
  DateTime? previous;
  for (final value in values) {
    if (previous != null && value.isBefore(previous)) {
      return false;
    }
    previous = value;
  }
  return true;
}
