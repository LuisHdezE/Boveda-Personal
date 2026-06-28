import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentWeekStartNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    // Lunes es 1, Domingo es 7
    final daysSinceMonday = now.weekday - 1;
    final startOfWeek = now.subtract(Duration(days: daysSinceMonday));
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }
  void setDate(DateTime date) => state = date;
}

final currentWeekStartProvider = NotifierProvider<CurrentWeekStartNotifier, DateTime>(CurrentWeekStartNotifier.new);

class WeeklyReportData {
  const WeeklyReportData({
    required this.totalIncome,
    required this.totalExpense,
    required this.netSavings,
    required this.dailyNetSavings,
    required this.displayCurrencyCode,
  });

  final double totalIncome;
  final double totalExpense;
  final double netSavings;
  final List<double> dailyNetSavings; // 0: Lunes, 6: Domingo
  final String displayCurrencyCode;
}

final weeklyReportProvider = FutureProvider<WeeklyReportData>((ref) async {
  final startOfWeek = ref.watch(currentWeekStartProvider);
  final endOfWeek = startOfWeek.add(const Duration(days: 7));

  final movements = await ref.watch(movementRepositoryProvider).list(
    MovementFilter(
      period: DateRange(start: startOfWeek, endExclusive: endOfWeek),
    ),
    PageRequest(limit: 1000, offset: 0),
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
  final List<double> dailyNetSavings = List.filled(7, 0.0);

  for (final movement in movements) {
    if (movement.type == MovementType.transferIn || movement.type == MovementType.transferOut) {
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

      final dayIndex = movement.occurredAt.weekday - 1; // 0 to 6

      if (movement.type == MovementType.income) {
        totalIncome += amountInDisplayCurrency;
        dailyNetSavings[dayIndex] += amountInDisplayCurrency;
      } else {
        totalExpense += amountInDisplayCurrency;
        dailyNetSavings[dayIndex] -= amountInDisplayCurrency;
      }
    }
  }

  return WeeklyReportData(
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    netSavings: totalIncome - totalExpense,
    dailyNetSavings: dailyNetSavings,
    displayCurrencyCode: displayCurrencyCode,
  );
});
