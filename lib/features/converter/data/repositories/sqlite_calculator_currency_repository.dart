import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/database_schema.dart';
import 'package:boveda_personal/features/converter/data/models/calculator_currency_model.dart';
import 'package:boveda_personal/features/converter/domain/entities/calculator_currency.dart';
import 'package:boveda_personal/features/converter/domain/repositories/calculator_currency_repository.dart';
import 'package:sqflite/sqflite.dart';

class SqliteCalculatorCurrencyRepository implements CalculatorCurrencyRepository {
  const SqliteCalculatorCurrencyRepository(this._database);

  final BovedaDatabase _database;

  @override
  Future<CalculatorCurrency?> findActiveByCode(String code) async {
    final db = await _database.open();
    final rows = await db.query(
      DatabaseTables.calculatorCurrencies,
      where: 'code = ? AND is_active = 1',
      whereArgs: [code.toUpperCase()],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return CalculatorCurrencyModel.fromRow(rows.first).toEntity();
  }

  @override
  Future<List<CalculatorCurrency>> list({bool activeOnly = false}) async {
    final db = await _database.open();
    final rows = await db.query(
      DatabaseTables.calculatorCurrencies,
      where: activeOnly ? 'is_active = 1' : null,
      orderBy: 'code ASC',
    );

    return rows
        .map((row) => CalculatorCurrencyModel.fromRow(row).toEntity())
        .toList();
  }

  @override
  Future<void> save(CalculatorCurrency currency) async {
    final db = await _database.open();
    final row = CalculatorCurrencyModel.fromEntity(currency).toRow();
    await db.insert(
      DatabaseTables.calculatorCurrencies,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> setActive(String id, {required bool active}) async {
    final db = await _database.open();
    await db.update(
      DatabaseTables.calculatorCurrencies,
      {'is_active': active ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
