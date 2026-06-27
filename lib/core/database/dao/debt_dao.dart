import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/database_schema.dart';
import 'package:boveda_personal/features/debts/data/models/debt_model.dart';
import 'package:sqflite/sqflite.dart';

class DebtDao {
  const DebtDao(this._database);

  final BovedaDatabase _database;

  Future<void> insert(DebtModel debt) async {
    final db = await _database.open();
    await db.insert(
      DatabaseTables.debts,
      debt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(DebtModel debt) async {
    final db = await _database.open();
    await db.update(
      DatabaseTables.debts,
      debt.toMap(),
      where: 'id = ? AND user_id = ?',
      whereArgs: [debt.id, debt.userId],
    );
  }

  Future<void> delete(String id, String userId) async {
    final db = await _database.open();
    await db.delete(
      DatabaseTables.debts,
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, userId],
    );
  }

  Future<List<DebtModel>> getAll(String userId) async {
    final db = await _database.open();
    final rows = await db.query(
      DatabaseTables.debts,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'due_date ASC',
    );
    return rows.map((row) => DebtModel.fromMap(row)).toList();
  }
}
