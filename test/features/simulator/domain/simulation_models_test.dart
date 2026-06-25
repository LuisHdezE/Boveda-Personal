import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/simulator/domain/entities/simulation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final usd = Currency(code: 'USD', scale: 2);

  test('SIM-004 resultado exige tantos puntos como meses', () {
    final input = SimulationInput(
      initialBalance: Money(minorUnits: 10000, currency: usd),
      monthlyIncome: Money(minorUnits: 1000, currency: usd),
      monthlyExpense: Money(minorUnits: 500, currency: usd),
      durationMonths: 2,
      startsAt: DateTime.utc(2026, 1),
    );
    final result = SimulationResult(
      input: input,
      points: [
        ProjectionPoint(
          month: 1,
          date: DateTime.utc(2026, 2),
          balance: Money(minorUnits: 10500, currency: usd),
        ),
        ProjectionPoint(
          month: 2,
          date: DateTime.utc(2026, 3),
          balance: Money(minorUnits: 11000, currency: usd),
        ),
      ],
    );

    expect(result.finalBalance.minorUnits, 11000);
    expect(result.totalNetChange.minorUnits, 1000);
  });

  test('SIM-001 rechaza duración no positiva', () {
    expect(
      () => SimulationInput(
        initialBalance: Money.zero(usd),
        monthlyIncome: Money.zero(usd),
        monthlyExpense: Money.zero(usd),
        durationMonths: 0,
        startsAt: DateTime.utc(2026),
      ),
      throwsArgumentError,
    );
  });
}
