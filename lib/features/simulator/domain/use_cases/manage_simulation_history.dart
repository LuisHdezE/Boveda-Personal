import 'package:boveda_personal/features/simulator/domain/entities/simulation_history.dart';
import 'package:boveda_personal/features/simulator/domain/repositories/simulation_repository.dart';

class ListSimulationHistory {
  const ListSimulationHistory(this.repository);
  final SimulationRepository repository;

  Future<List<SimulationHistory>> call() => repository.list();
}

class DeleteSimulationHistory {
  const DeleteSimulationHistory(this.repository);
  final SimulationRepository repository;

  Future<void> call(String id) => repository.delete(id);
}
