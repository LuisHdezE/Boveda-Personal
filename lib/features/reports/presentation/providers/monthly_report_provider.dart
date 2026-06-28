import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentMonthStartNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }
  void setDate(DateTime date) => state = DateTime(date.year, date.month, 1);
}

final currentMonthStartProvider = NotifierProvider<CurrentMonthStartNotifier, DateTime>(CurrentMonthStartNotifier.new);

class MonthlyReportData {
  const MonthlyReportData({
    required this.totalIncome,
    required this.totalExpense,
    required this.netSavings,
    required this.displayCurrencyCode,
  });

  final double totalIncome;
  final double totalExpense;
  final double netSavings;
  final String displayCurrencyCode;
}

final monthlyReportProvider = FutureProvider<MonthlyReportData>((ref) async {
  final startOfMonth = ref.watch(currentMonthStartProvider);
  final endOfMonth = DateTime(startOfMonth.year, startOfMonth.month + 1, 1);

  final movements = await ref.watch(movementRepositoryProvider).list(
    MovementFilter(
      period: DateRange(start: startOfMonth, endExclusive: endOfMonth),
    ),
    PageRequest(limit: 5000, offset: 0),
  );

  final currencies = await ref.watch(calculatorCurrenciesProvider.future);
  final settings = await ref.watch(appSettingsProvider.future);
  
  final displayCurrencyCode = settings?.secondaryCurrencyCode ?? 'USD';
  final targetCurrInfo = currencies.firstWhere(
    (c) => c.currency.code == displayCurrencyCode,
    orElse: () => currencies.first,
  );
  final unitsPerUsd = targetCurrInfo.unitsPerUsd.toDouble();

  double totalIncome = 0.0;
  double totalExpense = 0.0;

  for (final movement in movements) {
    if (movement.type == MovementType.transferIn || movement.type == MovementType.transferOut || movement.type == MovementType.opening) {
      continue;
    }

    final currInfo = currencies.firstWhere(
      (c) => c.currency.code == movement.amount.currency.code,
      orElse: () => currencies.first,
    );
    final movementUnitsPerUsd = currInfo.unitsPerUsd.toDouble();
    if (movementUnitsPerUsd > 0) {
      final amountInUsd = (movement.amount.minorUnits / 100.0) / movementUnitsPerUsd;
      final amountInDisplayCurrency = amountInUsd * unitsPerUsd;

      if (movement.type == MovementType.income) {
        totalIncome += amountInDisplayCurrency;
      } else if (movement.type == MovementType.expense) {
        totalExpense += amountInDisplayCurrency;
      }
    }
  }

  return MonthlyReportData(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    netSavings: totalIncome - totalExpense,
    displayCurrencyCode: displayCurrencyCode,
  );
});
