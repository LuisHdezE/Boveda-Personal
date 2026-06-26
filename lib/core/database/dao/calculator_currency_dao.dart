import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/database_schema.dart';

class CalculatorCurrencyDao {
  const CalculatorCurrencyDao(this._database);

  final BovedaDatabase _database;

  Future<void> insert(Map<String, Object?> values) async {
    final db = await _database.open();
    await db.insert(DatabaseTables.calculatorCurrencies, values);
  }

  Future<void> update(String id, Map<String, Object?> values) async {
    final db = await _database.open();
    final changed = await db.update(
      DatabaseTables.calculatorCurrencies,
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (changed == 0) {
      throw StateError('Calculator currency not found: $id');
    }
  }

  Future<List<Map<String, Object?>>> list({bool activeOnly = false}) async {
    final db = await _database.open();
    return db.query(
      DatabaseTables.calculatorCurrencies,
      columns: const [
        'id',
        'name',
        'code',
        'symbol',
        'currency_scale',
        'units_per_usd',
        'is_active',
        'created_at',
        'updated_at',
      ],
      where: activeOnly ? 'is_active = 1' : null,
      orderBy: 'code ASC, id ASC',
    );
  }
}
