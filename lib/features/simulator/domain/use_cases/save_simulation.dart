import 'package:boveda_personal/core/ports/id_generator.dart';
import 'package:boveda_personal/features/simulator/domain/entities/simulation.dart';
import 'package:boveda_personal/features/simulator/domain/entities/simulation_history.dart';
import 'package:boveda_personal/features/simulator/domain/repositories/simulation_repository.dart';

class SaveSimulation {
  const SaveSimulation({
    required this.repository,
    required this.ids,
    required this.now,
  });

  final SimulationRepository repository;
  final IdGenerator ids;
  final DateTime Function() now;

  Future<SimulationHistory> call(SimulationResult result) async {
    final history = SimulationHistory(
      id: ids.next(),
      currency: result.input.initialBalance.currency,
      initialBalance: result.input.initialBalance,
      monthlyIncome: result.input.monthlyIncome,
      monthlyExpense: result.input.monthlyExpense,
      durationMonths: result.input.durationMonths,
      projectedBalance: result.finalBalance,
      createdAt: now().toUtc(),
    );
    await repository.save(history);
    return history;
  }
}
