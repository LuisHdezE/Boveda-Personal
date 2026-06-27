import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/database_schema.dart';
import 'package:boveda_personal/features/subscriptions/data/models/subscription_model.dart';
import 'package:sqflite/sqflite.dart';

class SubscriptionDao {
  const SubscriptionDao(this._database);

  final BovedaDatabase _database;

  Future<void> insert(SubscriptionModel subscription) async {
    final db = await _database.open();
    await db.insert(
      DatabaseTables.subscriptions,
      subscription.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(SubscriptionModel subscription) async {
    final db = await _database.open();
    await db.update(
      DatabaseTables.subscriptions,
      subscription.toMap(),
      where: 'id = ? AND user_id = ?',
      whereArgs: [subscription.id, subscription.userId],
    );
  }

  Future<void> delete(String id, String userId) async {
    final db = await _database.open();
    await db.delete(
      DatabaseTables.subscriptions,
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, userId],
    );
  }

  Future<List<SubscriptionModel>> getAll(String userId) async {
    final db = await _database.open();
    final result = await db.query(
      DatabaseTables.subscriptions,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'next_billing_date ASC',
    );
    return result.map(SubscriptionModel.fromMap).toList();
  }
}
