import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/database_schema.dart';
import 'package:sqflite/sqflite.dart';

class UserSettingsDao {
  const UserSettingsDao(this._database);

  final BovedaDatabase _database;

  Future<void> insertUser(Map<String, Object?> values) async {
    final db = await _database.open();
    await db.insert(DatabaseTables.users, values);
  }

  Future<Map<String, Object?>?> findUserByUsername(String username) async {
    final db = await _database.open();
    final rows = await db.query(
      DatabaseTables.users,
      columns: const [
        'id',
        'display_name',
        'username',
        'password_hash',
        'password_salt',
        'created_at',
        'updated_at',
      ],
      where: 'username = ? COLLATE NOCASE',
      whereArgs: [username],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.single;
  }

  Future<Map<String, Object?>?> findUserById(String id) async {
    final db = await _database.open();
    final rows = await db.query(
      DatabaseTables.users,
      columns: const [
        'id',
        'display_name',
        'username',
        'password_hash',
        'password_salt',
        'created_at',
        'updated_at',
      ],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.single;
  }

  Future<void> updateUser(String id, String displayName, String username) async {
    final db = await _database.open();
    await db.update(
      DatabaseTables.users,
      {
        'display_name': displayName,
        'username': username,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> saveSettings(Map<String, Object?> values) async {
    final db = await _database.open();
    await db.insert(
      DatabaseTables.settings,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, Object?>?> loadSettings() async {
    final db = await _database.open();
    final rows = await db.query(
      DatabaseTables.settings,
      columns: const [
        'id',
        'user_id',
        'primary_currency_code',
        'locale',
        'biometrics_enabled',
        'auto_lock_duration_seconds',
        'onboarding_completed',
        'created_at',
        'updated_at',
      ],
      where: 'id = 1',
      limit: 1,
    );
    return rows.isEmpty ? null : rows.single;
  }
}
