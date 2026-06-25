import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account_balance.dart';
import 'package:boveda_personal/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final usd = Currency(code: 'USD', scale: 2);

  test('DASH-008 snapshot calcula ahorro mensual', () {
    final snapshot = DashboardSnapshot(
      balances: [
        AccountBalance(
          accountId: 'usd',
          userId: 'user',
          currency: usd,
          balance: Money(minorUnits: 10000, currency: usd),
        ),
      ],
      totalInPrimaryCurrency: Money(minorUnits: 10000, currency: usd),
      monthlyIncome: Money(minorUnits: 5000, currency: usd),
      monthlyExpense: Money(minorUnits: 1250, currency: usd),
      recentMovementIds: const ['one'],
      wealthEvolution: [
        WealthPoint(
          at: DateTime.utc(2026, 6, 1),
          value: Money(minorUnits: 10000, currency: usd),
        ),
      ],
      calculatedAt: DateTime.utc(2026, 6, 25),
    );

    expect(snapshot.monthlySavings.minorUnits, 3750);
  });

  test('MODEL-009 dashboard rechaza métricas en monedas distintas', () {
    final uyu = Currency(code: 'UYU', scale: 2);
    expect(
      () => DashboardSnapshot(
        balances: const [],
        totalInPrimaryCurrency: Money.zero(usd),
        monthlyIncome: Money.zero(usd),
        monthlyExpense: Money.zero(uyu),
        recentMovementIds: const [],
        wealthEvolution: const [],
        calculatedAt: DateTime.utc(2026),
      ),
      throwsArgumentError,
    );
  });
}
