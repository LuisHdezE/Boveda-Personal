import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account_balance.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lista cuentas activas con sus saldos actuales.
final accountBalancesProvider = FutureProvider<List<AccountBalance>>((ref) async {
  return ref.watch(accountRepositoryProvider).balances();
});

class ShowInSecondaryNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void toggle() => state = !state;
}

final showInSecondaryProvider = NotifierProvider<ShowInSecondaryNotifier, bool>(ShowInSecondaryNotifier.new);

/// Últimos 5 movimientos (sin filtro, página 1).
final recentMovementsProvider = FutureProvider<List<Movement>>((ref) async {
  return ref.watch(movementRepositoryProvider).list(
    MovementFilter(),
    PageRequest(limit: 5, offset: 0),
  );
});

class DashboardSummary {
  const DashboardSummary({
    required this.income,
    required this.expense,
  });
  final int income; // minorUnits
  final int expense; // minorUnits
}

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 1);
  
  final movements = await ref.watch(movementRepositoryProvider).list(
    MovementFilter(
      period: DateRange(start: startOfMonth, endExclusive: endOfMonth),
    ),
    PageRequest(limit: 1000, offset: 0),
  );
  
  final currencies = await ref.watch(calculatorCurrenciesProvider.future);
  final settings = await ref.watch(appSettingsProvider.future);
  final showInSecondary = ref.watch(showInSecondaryProvider);

  double incomeUsd = 0.0;
  double expenseUsd = 0.0;

  for (final movement in movements) {
    final currInfo = currencies.firstWhere(
      (c) => c.currency.code == movement.amount.currency.code,
      orElse: () => currencies.first,
    );
    final unitsPerUsd = currInfo.unitsPerUsd.toDouble();
    if (unitsPerUsd > 0) {
      final amountInUsd = (movement.amount.minorUnits / 100.0) / unitsPerUsd;
      if (movement.type == MovementType.income) {
        incomeUsd += amountInUsd;
      } else if (movement.type == MovementType.expense) {
        expenseUsd += amountInUsd;
      }
    }
  }

  double displayIncome = incomeUsd;
  double displayExpense = expenseUsd;

  if (showInSecondary && settings != null) {
    final secCode = settings.secondaryCurrencyCode ?? 'CUP';
    final targetCurrInfo = currencies.firstWhere(
      (c) => c.currency.code == secCode,
      orElse: () => currencies.first,
    );
    final unitsPerUsd = targetCurrInfo.unitsPerUsd.toDouble();
    displayIncome = incomeUsd * unitsPerUsd;
    displayExpense = expenseUsd * unitsPerUsd;
  }
  
  return DashboardSummary(
    income: (displayIncome * 100).toInt(),
    expense: (displayExpense * 100).toInt(),
  );
});

class WealthPoint {
  final DateTime date;
  final double balance;
  WealthPoint(this.date, this.balance);
}

final wealthEvolutionProvider = FutureProvider<List<WealthPoint>>((ref) async {
  final balances = await ref.watch(accountBalancesProvider.future);
  final movements = await ref.watch(movementRepositoryProvider).list(
    MovementFilter(),
    PageRequest(limit: 10000, offset: 0),
  );
  final currencies = await ref.watch(calculatorCurrenciesProvider.future);
  final settings = await ref.watch(appSettingsProvider.future);
  final showInSecondary = ref.watch(showInSecondaryProvider);

  double currentTotal = 0.0;
  for (final b in balances) {
    final currInfo = currencies.firstWhere(
      (c) => c.currency.code == b.currency.code,
      orElse: () => currencies.first,
    );
    final unitsPerUsd = currInfo.unitsPerUsd.toDouble();
    if (unitsPerUsd > 0) {
      currentTotal += (b.balance.minorUnits / 100.0) / unitsPerUsd;
    }
  }

  double targetUnitsPerUsd = 1.0;
  if (showInSecondary && settings != null) {
    final displayCode = settings.secondaryCurrencyCode ?? 'CUP';
    final targetCurrInfo = currencies.firstWhere(
      (c) => c.currency.code == displayCode,
      orElse: () => currencies.first,
    );
    targetUnitsPerUsd = targetCurrInfo.unitsPerUsd.toDouble();
    currentTotal = currentTotal * targetUnitsPerUsd;
  }

  List<WealthPoint> points = [];
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  
  double runningBalance = currentTotal;
  final sortedMovements = List<Movement>.from(movements)..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
  
  // Reverse future movements so runningBalance is exactly at the end of `today`
  for (final m in sortedMovements) {
      final mDate = DateTime(m.occurredAt.year, m.occurredAt.month, m.occurredAt.day);
      if (mDate.isAfter(today)) {
          final currInfo = currencies.firstWhere((c) => c.currency.code == m.amount.currency.code, orElse: () => currencies.first);
          final units = currInfo.unitsPerUsd.toDouble();
          if (units > 0) {
              final amountInTarget = ((m.amount.minorUnits / 100.0) / units) * targetUnitsPerUsd;
              runningBalance += (m.type == MovementType.income) ? -amountInTarget : amountInTarget;
          }
      }
  }

  points.insert(0, WealthPoint(today, runningBalance));

  for (int i = 1; i < 30; i++) {
    final targetDate = today.subtract(Duration(days: i));
    final dayToReverse = today.subtract(Duration(days: i - 1));
    
    for (final m in sortedMovements) {
      final mDate = DateTime(m.occurredAt.year, m.occurredAt.month, m.occurredAt.day);
      if (mDate.isAtSameMomentAs(dayToReverse)) {
          final currInfo = currencies.firstWhere((c) => c.currency.code == m.amount.currency.code, orElse: () => currencies.first);
          final units = currInfo.unitsPerUsd.toDouble();
          if (units > 0) {
              final amountInTarget = ((m.amount.minorUnits / 100.0) / units) * targetUnitsPerUsd;
              runningBalance += (m.type == MovementType.income) ? -amountInTarget : amountInTarget;
          }
      }
    }
    points.insert(0, WealthPoint(targetDate, runningBalance));
  }
  
  return points;
});
