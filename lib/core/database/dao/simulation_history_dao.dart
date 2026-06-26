import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/database_schema.dart';

class SimulationHistoryDao {
  const SimulationHistoryDao(this._database);

  final BovedaDatabase _database;

  Future<void> insert(Map<String, Object?> values) async {
    final db = await _database.open();
    await db.insert(DatabaseTables.simulationHistory, values);
  }

  Future<List<Map<String, Object?>>> list({int? limit, int? offset}) async {
    final db = await _database.open();
    return db.query(
      DatabaseTables.simulationHistory,
      columns: const [
        'id',
        'currency_code',
        'currency_scale',
        'initial_balance_minor',
        'monthly_income_minor',
        'monthly_expense_minor',
        'duration_months',
        'projected_balance_minor',
        'created_at',
      ],
      orderBy: 'created_at DESC, id DESC',
      limit: limit,
      offset: offset,
    );
  }

  Future<void> delete(String id) async {
    final db = await _database.open();
    final changed = await db.delete(
      DatabaseTables.simulationHistory,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (changed == 0) {
      throw StateError('Simulation not found: $id');
    }
  }
}
