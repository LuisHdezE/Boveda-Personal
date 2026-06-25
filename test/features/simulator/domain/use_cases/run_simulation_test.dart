import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/simulator/domain/entities/simulation.dart';
import 'package:boveda_personal/features/simulator/domain/use_cases/run_simulation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final usd = Currency(code: 'USD', scale: 2);

  test('SIM-004 genera un punto por mes y saldo final', () {
    final input = SimulationInput(
      initialBalance: Money(minorUnits: 10000, currency: usd),
      monthlyIncome: Money(minorUnits: 1000, currency: usd),
      monthlyExpense: Money(minorUnits: 500, currency: usd),
      durationMonths: 3,
      startsAt: DateTime.utc(2026, 1, 31),
    );

    final result = const RunSimulation()(input);

    expect(result.points.map((point) => point.balance.minorUnits), [
      10500,
      11000,
      11500,
    ]);
    expect(result.finalBalance.minorUnits, 11500);
  });
}
