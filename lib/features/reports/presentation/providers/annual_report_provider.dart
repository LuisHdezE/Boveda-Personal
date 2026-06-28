import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentYearStartNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, 1, 1);
  }
  
  void setYear(DateTime date) {
    state = DateTime(date.year, 1, 1);
  }
}

final currentYearStartProvider = NotifierProvider<CurrentYearStartNotifier, DateTime>(CurrentYearStartNotifier.new);

class AnnualReportData {
  const AnnualReportData({
    required this.totalIncome,
    required this.totalExpense,
    required this.netSavings,
    required this.incomePerMonth,
    required this.expensePerMonth,
    required this.displayCurrencyCode,
  });

  final double totalIncome;
  final double totalExpense;
  final double netSavings;
  final List<double> incomePerMonth;
  final List<double> expensePerMonth;
  final String displayCurrencyCode;
}

final annualReportProvider = FutureProvider<AnnualReportData>((ref) async {
  final startOfYear = ref.watch(currentYearStartProvider);
  final endOfYear = DateTime(startOfYear.year + 1, 1, 1);

  final movements = await ref.watch(movementRepositoryProvider).list(
    MovementFilter(
      period: DateRange(start: startOfYear, endExclusive: endOfYear),
    ),
    PageRequest(limit: 10000, offset: 0),
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
  final List<double> incomePerMonth = List.generate(12, (_) => 0.0);
  final List<double> expensePerMonth = List.generate(12, (_) => 0.0);

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

      final monthIndex = movement.occurredAt.month - 1;
      if (monthIndex >= 0 && monthIndex <= 11) {
        if (movement.type == MovementType.income) {
          totalIncome += amountInDisplayCurrency;
          incomePerMonth[monthIndex] += amountInDisplayCurrency;
        } else if (movement.type == MovementType.expense) {
          totalExpense += amountInDisplayCurrency;
          expensePerMonth[monthIndex] += amountInDisplayCurrency;
        }
      }
    }
  }

  return AnnualReportData(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    netSavings: totalIncome - totalExpense,
    incomePerMonth: incomePerMonth,
    expensePerMonth: expensePerMonth,
    displayCurrencyCode: displayCurrencyCode,
  );
});
