import 'package:boveda_personal/features/simulator/domain/entities/simulation_history.dart';

abstract interface class SimulationRepository {
  Future<List<SimulationHistory>> list();
  Future<void> save(SimulationHistory simulation);
  Future<void> delete(String id);
}
