import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/database_schema.dart';

class TransferDao {
  const TransferDao(this._database);

  static const columns = <String>[
    'id',
    'source_account_id',
    'destination_account_id',
    'source_amount_minor',
    'destination_amount_minor',
    'exchange_rate',
    'occurred_at',
    'note',
    'created_at',
    'updated_at',
  ];

  final BovedaDatabase _database;

  Future<void> insert({
    required Map<String, Object?> transfer,
    required Map<String, Object?> outgoingMovement,
    required Map<String, Object?> incomingMovement,
  }) {
    return _database.transaction((transaction) async {
      await transaction.insert(DatabaseTables.transfers, transfer);
      await transaction.insert(DatabaseTables.movements, outgoingMovement);
      await transaction.insert(DatabaseTables.movements, incomingMovement);
    });
  }

  Future<void> replace({
    required String id,
    required Map<String, Object?> transfer,
    required Map<String, Object?> outgoingMovement,
    required Map<String, Object?> incomingMovement,
  }) {
    return _database.transaction((transaction) async {
      final removed = await transaction.delete(
        DatabaseTables.transfers,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (removed == 0) {
        throw StateError('Transfer not found: $id');
      }
      await transaction.insert(DatabaseTables.transfers, transfer);
      await transaction.insert(DatabaseTables.movements, outgoingMovement);
      await transaction.insert(DatabaseTables.movements, incomingMovement);
    });
  }

  Future<void> delete(String id) {
    return _database.transaction((transaction) async {
      final removed = await transaction.delete(
        DatabaseTables.transfers,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (removed == 0) {
        throw StateError('Transfer not found: $id');
      }
    });
  }

  Future<Map<String, Object?>?> findById(String id) async {
    final db = await _database.open();
    final rows = await db.query(
      DatabaseTables.transfers,
      columns: columns,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.single;
  }
}
