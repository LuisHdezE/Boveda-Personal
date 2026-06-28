import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentQuarterStartNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    final currentQuarter = (now.month - 1) ~/ 3 + 1;
    final startMonth = (currentQuarter - 1) * 3 + 1;
    return DateTime(now.year, startMonth, 1);
  }
  
  void setQuarter(DateTime date) {
    final quarter = (date.month - 1) ~/ 3 + 1;
    final startMonth = (quarter - 1) * 3 + 1;
    state = DateTime(date.year, startMonth, 1);
  }
}

final currentQuarterStartProvider = NotifierProvider<CurrentQuarterStartNotifier, DateTime>(CurrentQuarterStartNotifier.new);

class QuarterlyReportData {
  const QuarterlyReportData({
    required this.totalIncome,
    required this.totalExpense,
    required this.netSavings,
    required this.averageExpense,
    required this.incomePerMonth,
    required this.expensePerMonth,
    required this.displayCurrencyCode,
  });

  final double totalIncome;
  final double totalExpense;
  final double netSavings;
  final double averageExpense;
  final List<double> incomePerMonth;
  final List<double> expensePerMonth;
  final String displayCurrencyCode;
}

final quarterlyReportProvider = FutureProvider<QuarterlyReportData>((ref) async {
  final startOfQuarter = ref.watch(currentQuarterStartProvider);
  final endOfQuarter = DateTime(startOfQuarter.year, startOfQuarter.month + 3, 1);

  final movements = await ref.watch(movementRepositoryProvider).list(
    MovementFilter(
      period: DateRange(start: startOfQuarter, endExclusive: endOfQuarter),
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
  final List<double> incomePerMonth = [0, 0, 0];
  final List<double> expensePerMonth = [0, 0, 0];

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

      final monthIndex = movement.occurredAt.month - startOfQuarter.month;
      if (monthIndex >= 0 && monthIndex <= 2) {
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

  return QuarterlyReportData(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    netSavings: totalIncome - totalExpense,
    averageExpense: totalExpense / 3.0,
    incomePerMonth: incomePerMonth,
    expensePerMonth: expensePerMonth,
    displayCurrencyCode: displayCurrencyCode,
  );
});
