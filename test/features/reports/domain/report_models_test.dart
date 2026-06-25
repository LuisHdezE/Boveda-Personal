import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/reports/domain/entities/report.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final usd = Currency(code: 'USD', scale: 2);
  final period = DateRange(
    start: DateTime.utc(2026, 6, 1),
    endExclusive: DateTime.utc(2026, 7, 1),
  );

  test('REP-003 resumen calcula ahorro', () {
    final report = FinancialReport(
      period: period,
      currency: usd,
      income: Money(minorUnits: 5000, currency: usd),
      expense: Money(minorUnits: 1250, currency: usd),
      savingsRate: Decimal.parse('75'),
      categoryBreakdown: const [],
      cashFlow: const [],
      netWorth: const [],
    );

    expect(report.savings.minorUnits, 3750);
  });

  test('REP-009 categoría valida porcentaje entre cero y cien', () {
    expect(
      () => CategoryBreakdown(
        categoryId: 'food',
        categoryName: 'Alimentación',
        amount: Money(minorUnits: 100, currency: usd),
        percentage: Decimal.parse('101'),
      ),
      throwsArgumentError,
    );
  });

  test('MODEL-010 series se ordenan cronológicamente', () {
    expect(
      () => FinancialReport(
        period: period,
        currency: usd,
        income: Money.zero(usd),
        expense: Money.zero(usd),
        savingsRate: Decimal.zero,
        categoryBreakdown: const [],
        cashFlow: [
          CashFlowPoint(
            period: DateRange(
              start: DateTime.utc(2026, 6, 2),
              endExclusive: DateTime.utc(2026, 6, 3),
            ),
            income: Money.zero(usd),
            expense: Money.zero(usd),
          ),
          CashFlowPoint(
            period: DateRange(
              start: DateTime.utc(2026, 6, 1),
              endExclusive: DateTime.utc(2026, 6, 2),
            ),
            income: Money.zero(usd),
            expense: Money.zero(usd),
          ),
        ],
        netWorth: const [],
      ),
      throwsArgumentError,
    );
  });
}
