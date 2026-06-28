import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/dashboard/presentation/providers.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatrimonyMonthPoint {
  const PatrimonyMonthPoint({
    required this.month,
    required this.balance,
  });
  final int month;
  final double balance;
}

class PatrimonyEvolutionReport {
  const PatrimonyEvolutionReport({
    required this.points,
    required this.currentPatrimony,
    required this.growthPercentage,
    required this.displayCurrencyCode,
  });

  final List<PatrimonyMonthPoint> points;
  final double currentPatrimony;
  final double growthPercentage;
  final String displayCurrencyCode;
}

class PatrimonyYearNotifier extends Notifier<int> {
  @override
  int build() {
    return DateTime.now().year;
  }

  void setYear(int year) => state = year;
}

final patrimonyYearProvider = NotifierProvider<PatrimonyYearNotifier, int>(PatrimonyYearNotifier.new);

final patrimonyEvolutionHistoryProvider = FutureProvider<PatrimonyEvolutionReport>((ref) async {
  final targetYear = ref.watch(patrimonyYearProvider);
  
  final balances = await ref.watch(accountBalancesProvider.future);
  final movements = await ref.watch(movementRepositoryProvider).list(
    MovementFilter(),
    PageRequest(limit: 10000, offset: 0),
  );
  final currencies = await ref.watch(calculatorCurrenciesProvider.future);
  final settings = await ref.watch(appSettingsProvider.future);

  final displayCurrencyCode = settings?.primaryCurrencyCode ?? 'USD';
  final targetCurrInfo = currencies.firstWhere(
    (c) => c.currency.code == displayCurrencyCode,
    orElse: () => currencies.first,
  );
  final targetUnitsPerUsd = targetCurrInfo.unitsPerUsd.toDouble();

  double currentTotal = 0.0;
  for (final b in balances) {
    final currInfo = currencies.firstWhere(
      (c) => c.currency.code == b.currency.code,
      orElse: () => currencies.first,
    );
    final unitsPerUsd = currInfo.unitsPerUsd.toDouble();
    if (unitsPerUsd > 0) {
      currentTotal += ((b.balance.minorUnits / 100.0) / unitsPerUsd) * targetUnitsPerUsd;
    }
  }

  final sortedMovements = List<Movement>.from(movements)..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
  
  double runningBalance = currentTotal;
  final now = DateTime.now();

  for (final m in sortedMovements) {
      if (m.occurredAt.isAfter(now)) {
          final currInfo = currencies.firstWhere((c) => c.currency.code == m.amount.currency.code, orElse: () => currencies.first);
          final units = currInfo.unitsPerUsd.toDouble();
          if (units > 0) {
              final amountInTarget = ((m.amount.minorUnits / 100.0) / units) * targetUnitsPerUsd;
              runningBalance += (m.type == MovementType.income) ? -amountInTarget : amountInTarget;
          }
      }
  }

  Map<String, double> endOfMonthBalances = {};
  
  DateTime currentCursor = now;
  for (final m in sortedMovements) {
      if (m.occurredAt.isAfter(now)) continue;

      while (currentCursor.year > m.occurredAt.year || (currentCursor.year == m.occurredAt.year && currentCursor.month > m.occurredAt.month)) {
         endOfMonthBalances['${currentCursor.year}-${currentCursor.month}'] = runningBalance;
         currentCursor = DateTime(currentCursor.year, currentCursor.month - 1, 28);
      }
      
      final currInfo = currencies.firstWhere((c) => c.currency.code == m.amount.currency.code, orElse: () => currencies.first);
      final units = currInfo.unitsPerUsd.toDouble();
      if (units > 0) {
          final amountInTarget = ((m.amount.minorUnits / 100.0) / units) * targetUnitsPerUsd;
          runningBalance += (m.type == MovementType.income) ? -amountInTarget : amountInTarget;
      }
  }
  
  while (currentCursor.year >= targetYear - 1) {
      endOfMonthBalances['${currentCursor.year}-${currentCursor.month}'] = runningBalance;
      currentCursor = DateTime(currentCursor.year, currentCursor.month - 1, 28);
  }

  List<PatrimonyMonthPoint> points = [];
  int maxMonth = (targetYear == now.year) ? now.month : 12;
  
  for (int month = 1; month <= maxMonth; month++) {
      double bal = endOfMonthBalances['$targetYear-$month'] ?? 0.0;
      points.add(PatrimonyMonthPoint(month: month, balance: bal));
  }
  
  double startOfYearBalance = endOfMonthBalances['${targetYear - 1}-12'] ?? 0.0;
  double endBalance = points.isNotEmpty ? points.last.balance : 0.0;
  
  double growthPercentage = 0.0;
  if (startOfYearBalance > 0) {
      growthPercentage = ((endBalance - startOfYearBalance) / startOfYearBalance) * 100.0;
  } else if (endBalance > 0) {
      growthPercentage = 100.0;
  }

  return PatrimonyEvolutionReport(
    points: points,
    currentPatrimony: currentTotal,
    growthPercentage: growthPercentage,
    displayCurrencyCode: displayCurrencyCode,
  );
});
