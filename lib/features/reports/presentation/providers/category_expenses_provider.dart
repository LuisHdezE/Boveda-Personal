import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/categories/domain/entities/category.dart';
import 'package:boveda_personal/features/categories/presentation/providers.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryExpenseData {
  const CategoryExpenseData({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  final Category category;
  final double amount;
  final double percentage;
}

class CategoryExpensesReport {
  const CategoryExpensesReport({
    required this.totalExpense,
    required this.displayCurrencyCode,
    required this.categories,
  });

  final double totalExpense;
  final String displayCurrencyCode;
  final List<CategoryExpenseData> categories;
}

class ExpenseMonthStartNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  void setDate(DateTime date) => state = DateTime(date.year, date.month, 1);
}

final expenseMonthStartProvider = NotifierProvider<ExpenseMonthStartNotifier, DateTime>(ExpenseMonthStartNotifier.new);

final categoryExpensesProvider = FutureProvider<CategoryExpensesReport>((ref) async {
  final startOfMonth = ref.watch(expenseMonthStartProvider);
  final endOfMonth = DateTime(startOfMonth.year, startOfMonth.month + 1, 1);

  final movements = await ref.watch(movementRepositoryProvider).list(
    MovementFilter(
      period: DateRange(start: startOfMonth, endExclusive: endOfMonth),
      types: {MovementType.expense},
    ),
    PageRequest(limit: 5000, offset: 0),
  );

  final currencies = await ref.watch(calculatorCurrenciesProvider.future);
  final settings = await ref.watch(appSettingsProvider.future);
  final allCategories = await ref.watch(categoryRepositoryProvider).list();

  final displayCurrencyCode = settings?.secondaryCurrencyCode ?? 'USD';
  final targetCurrInfo = currencies.firstWhere(
    (c) => c.currency.code == displayCurrencyCode,
    orElse: () => currencies.first,
  );
  final unitsPerUsd = targetCurrInfo.unitsPerUsd.toDouble();

  double totalExpense = 0.0;
  final amountByCategory = <String, double>{};

  for (final movement in movements) {
    if (movement.categoryId == null) continue;

    final currInfo = currencies.firstWhere(
      (c) => c.currency.code == movement.amount.currency.code,
      orElse: () => currencies.first,
    );
    final movementUnitsPerUsd = currInfo.unitsPerUsd.toDouble();
    if (movementUnitsPerUsd > 0) {
      final amountInUsd = (movement.amount.minorUnits / 100.0) / movementUnitsPerUsd;
      final amountInDisplayCurrency = amountInUsd * unitsPerUsd;

      totalExpense += amountInDisplayCurrency;
      amountByCategory[movement.categoryId!] = (amountByCategory[movement.categoryId!] ?? 0) + amountInDisplayCurrency;
    }
  }

  final categoriesList = <CategoryExpenseData>[];
  for (final entry in amountByCategory.entries) {
    final category = allCategories.firstWhere((c) => c.id == entry.key, orElse: () => allCategories.first);
    final percentage = totalExpense > 0 ? (entry.value / totalExpense) : 0.0;
    categoriesList.add(CategoryExpenseData(category: category, amount: entry.value, percentage: percentage));
  }

  categoriesList.sort((a, b) => b.amount.compareTo(a.amount));

  return CategoryExpensesReport(
    totalExpense: totalExpense,
    displayCurrencyCode: displayCurrencyCode,
    categories: categoriesList,
  );
});
