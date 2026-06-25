import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:collection/collection.dart';

class SimulationInput {
  SimulationInput({
    required this.initialBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.durationMonths,
    required this.startsAt,
  }) {
    if (durationMonths <= 0) {
      throw ArgumentError.value(durationMonths, 'durationMonths');
    }
    if (monthlyIncome.minorUnits < 0 || monthlyExpense.minorUnits < 0) {
      throw ArgumentError('Monthly income and expense cannot be negative');
    }
    final currency = initialBalance.currency;
    if (monthlyIncome.currency != currency ||
        monthlyExpense.currency != currency) {
      throw ArgumentError('All simulation amounts must share a currency');
    }
  }

  final Money initialBalance;
  final Money monthlyIncome;
  final Money monthlyExpense;
  final int durationMonths;
  final DateTime startsAt;

  Money get monthlyNet => monthlyIncome - monthlyExpense;

  @override
  bool operator ==(Object other) {
    return other is SimulationInput &&
        other.initialBalance == initialBalance &&
        other.monthlyIncome == monthlyIncome &&
        other.monthlyExpense == monthlyExpense &&
        other.durationMonths == durationMonths &&
        other.startsAt == startsAt;
  }

  @override
  int get hashCode => Object.hash(
        initialBalance,
        monthlyIncome,
        monthlyExpense,
        durationMonths,
        startsAt,
      );
}

class ProjectionPoint {
  ProjectionPoint({
    required this.month,
    required this.date,
    required this.balance,
  }) {
    if (month <= 0) {
      throw ArgumentError.value(month, 'month');
    }
  }

  final int month;
  final DateTime date;
  final Money balance;

  @override
  bool operator ==(Object other) {
    return other is ProjectionPoint &&
        other.month == month &&
        other.date == date &&
        other.balance == balance;
  }

  @override
  int get hashCode => Object.hash(month, date, balance);
}

class SimulationResult {
  SimulationResult({
    required this.input,
    required List<ProjectionPoint> points,
  }) : points = List.unmodifiable(points) {
    if (this.points.length != input.durationMonths) {
      throw ArgumentError('Projection must contain one point per month');
    }
    for (var index = 0; index < this.points.length; index++) {
      final point = this.points[index];
      if (point.month != index + 1 ||
          point.balance.currency != input.initialBalance.currency) {
        throw ArgumentError('Projection points are inconsistent');
      }
      if (index > 0 && !point.date.isAfter(this.points[index - 1].date)) {
        throw ArgumentError('Projection points must be chronological');
      }
    }
  }

  final SimulationInput input;
  final List<ProjectionPoint> points;

  Money get finalBalance => points.last.balance;
  Money get totalNetChange => finalBalance - input.initialBalance;

  @override
  bool operator ==(Object other) {
    return other is SimulationResult &&
        other.input == input &&
        const ListEquality<ProjectionPoint>().equals(other.points, points);
  }

  @override
  int get hashCode => Object.hash(
        input,
        const ListEquality<ProjectionPoint>().hash(points),
      );
}
