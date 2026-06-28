import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/database_schema.dart';

class AccountDao {
  const AccountDao(this._database);

  static const columns = <String>[
    'id',
    'user_id',
    'currency_code',
    'currency_scale',
    'name',
    'is_active',
    'created_at',
    'updated_at',
  ];

  final BovedaDatabase _database;

  Future<void> insert(Map<String, Object?> values) async {
    final db = await _database.open();
    await db.insert(DatabaseTables.accounts, values);
  }

  Future<List<Map<String, Object?>>> list({bool activeOnly = false}) async {
    final db = await _database.open();
    return db.query(
      DatabaseTables.accounts,
      columns: columns,
      where: activeOnly ? 'is_active = 1' : null,
      orderBy: 'created_at ASC, id ASC',
    );
  }

  Future<Map<String, Object?>?> findById(String id) async {
    final db = await _database.open();
    final rows = await db.query(
      DatabaseTables.accounts,
      columns: columns,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.single;
  }

  Future<int?> balanceMinor(String id) async {
    final db = await _database.open();
    final rows = await db.query(
      DatabaseViews.accountBalances,
      columns: ['balance_minor'],
      where: 'account_id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.single['balance_minor'] as int;
  }

  Future<void> setActive(String id, {required bool active}) async {
    final db = await _database.open();
    final changed = await db.update(
      DatabaseTables.accounts,
      {'is_active': active ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    if (changed == 0) {
      throw StateError('Account not found: $id');
    }
  }

  Future<void> updateCurrency(String id, {required String currencyCode, required int currencyScale}) async {
    final db = await _database.open();
    final changed = await db.update(
      DatabaseTables.accounts,
      {
        'currency_code': currencyCode,
        'currency_scale': currencyScale,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    if (changed == 0) {
      throw StateError('Account not found: $id');
    }
  }
}
