import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/ports/money_converter.dart';
import 'package:boveda_personal/features/categories/domain/repositories/category_repository.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/movements/domain/repositories/movement_repository.dart';
import 'package:boveda_personal/features/reports/domain/entities/report.dart';
import 'package:decimal/decimal.dart';

class GenerateFinancialReport {
  const GenerateFinancialReport({
    required this.movements,
    required this.categories,
    required this.converter,
  });

  final MovementRepository movements;
  final CategoryRepository categories;
  final MoneyConverter converter;

  Future<FinancialReport> call({
    required DateRange period,
    required Currency currency,
  }) async {
    final rows = await movements.list(
      MovementFilter(
        period: period,
        types: const {MovementType.income, MovementType.expense},
      ),
      PageRequest(limit: 1000000),
    );
    final categoryNames = {
      for (final category in await categories.list(activeOnly: false))
        category.id: category.name,
    };
    var income = Money.zero(currency);
    var expense = Money.zero(currency);
    final expensesByCategory = <String, Money>{};
    for (final movement in rows) {
      final converted = await converter.convert(
        movement.amount,
        target: currency,
        at: movement.occurredAt,
      );
      if (movement.type == MovementType.income) {
        income = income + converted;
      } else {
        expense = expense + converted;
        final categoryId = movement.categoryId ?? 'unknown';
        expensesByCategory[categoryId] =
            (expensesByCategory[categoryId] ?? Money.zero(currency)) +
            converted;
      }
    }
    final breakdown =
        expensesByCategory.entries.map((entry) {
          final percentage = expense.isZero
              ? Decimal.zero
              : _percentage(entry.value.minorUnits, expense.minorUnits);
          return CategoryBreakdown(
            categoryId: entry.key,
            categoryName: categoryNames[entry.key] ?? 'Sin categoría',
            amount: entry.value,
            percentage: percentage,
          );
        }).toList()..sort((a, b) {
          final amountOrder = b.amount.minorUnits.compareTo(
            a.amount.minorUnits,
          );
          return amountOrder != 0
              ? amountOrder
              : a.categoryName.compareTo(b.categoryName);
        });
    final savingsRate = income.isZero
        ? Decimal.zero
        : _percentage(
            income.minorUnits - expense.minorUnits,
            income.minorUnits,
          );
    return FinancialReport(
      period: period,
      currency: currency,
      income: income,
      expense: expense,
      savingsRate: savingsRate,
      categoryBreakdown: breakdown,
      cashFlow: [
        CashFlowPoint(period: period, income: income, expense: expense),
      ],
      netWorth: const [],
    );
  }
}

Decimal _percentage(int numerator, int denominator) {
  final scaled =
      (BigInt.from(numerator) * BigInt.from(1000000)) ~/
      BigInt.from(denominator);
  final negative = scaled.isNegative;
  final digits = scaled.abs().toString().padLeft(5, '0');
  final split = digits.length - 4;
  final value = '${digits.substring(0, split)}.${digits.substring(split)}'
      .replaceFirst(RegExp(r'\.?0+$'), '');
  return Decimal.parse(negative ? '-$value' : value);
}
