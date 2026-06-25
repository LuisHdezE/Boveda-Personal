import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';

class SimulationHistory {
  const SimulationHistory({
    required this.id,
    required this.currency,
    required this.initialBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.durationMonths,
    required this.projectedBalance,
    required this.createdAt,
  });

  final String id;
  final Currency currency;
  final Money initialBalance;
  final Money monthlyIncome;
  final Money monthlyExpense;
  final int durationMonths;
  final Money projectedBalance;
  final DateTime createdAt;

  Money get netMonthly => monthlyIncome - monthlyExpense;

  @override
  bool operator ==(Object other) {
    return other is SimulationHistory &&
        other.id == id &&
        other.currency == currency &&
        other.initialBalance == initialBalance &&
        other.monthlyIncome == monthlyIncome &&
        other.monthlyExpense == monthlyExpense &&
        other.durationMonths == durationMonths &&
        other.projectedBalance == projectedBalance &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        currency,
        initialBalance,
        monthlyIncome,
        monthlyExpense,
        durationMonths,
        projectedBalance,
        createdAt,
      );
}
