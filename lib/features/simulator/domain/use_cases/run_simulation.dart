import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/simulator/domain/entities/simulation.dart';

class RunSimulation {
  const RunSimulation();

  SimulationResult call(SimulationInput input) {
    final points = <ProjectionPoint>[];
    var balance = input.initialBalance;
    for (var month = 1; month <= input.durationMonths; month++) {
      balance = balance + input.monthlyNet;
      points.add(
        ProjectionPoint(
          month: month,
          date: _addMonths(input.startsAt, month),
          balance: balance,
        ),
      );
    }
    return SimulationResult(input: input, points: points);
  }
}

DateTime _addMonths(DateTime source, int months) {
  final targetMonth = source.month + months;
  final firstOfTarget = source.isUtc
      ? DateTime.utc(source.year, targetMonth)
      : DateTime(source.year, targetMonth);
  final firstOfNext = source.isUtc
      ? DateTime.utc(firstOfTarget.year, firstOfTarget.month + 1)
      : DateTime(firstOfTarget.year, firstOfTarget.month + 1);
  final lastDay = firstOfNext.subtract(const Duration(days: 1)).day;
  final day = source.day > lastDay ? lastDay : source.day;
  return source.isUtc
      ? DateTime.utc(firstOfTarget.year, firstOfTarget.month, day)
      : DateTime(firstOfTarget.year, firstOfTarget.month, day);
}
