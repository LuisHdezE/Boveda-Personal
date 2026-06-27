import 'package:boveda_personal/core/database/database_schema.dart';
import 'package:sqflite/sqflite.dart';

abstract final class DatabaseMigrator {
  static Future<void> migrate(
    DatabaseExecutor database, {
    required int from,
    required int to,
  }) async {
    if (to < from) {
      throw UnsupportedError(
        'Database downgrade is not supported: $from -> $to',
      );
    }
    if (to > DatabaseSchema.version) {
      throw UnsupportedError('Unknown target database version: $to');
    }

    for (var version = from + 1; version <= to; version++) {
      switch (version) {
        case 1:
          await _createVersion1(database);
          break;
        case 2:
          await _createVersion2(database);
          break;
      }
    }
  }

  static Future<void> _createVersion1(DatabaseExecutor database) async {
    try {
      final batch = database.batch();
      for (final statement in DatabaseSchema.createStatements) {
        batch.execute(statement);
      }
      for (final category in DatabaseSeeds.systemCategories) {
        batch.rawInsert(
          '''
          INSERT OR IGNORE INTO ${DatabaseTables.categories} (
            id, name, icon, color, movement_type, is_system, is_active, created_at, updated_at
          ) VALUES (?, ?, ?, ?, ?, 1, 1, 0, 0)
          ''',
          [
            category['id'],
            category['name'],
            category['icon'],
            category['color'],
            category['movement_type'],
          ],
        );
      }
      batch.execute('PRAGMA user_version = ${DatabaseSchema.version}');
      await batch.commit(noResult: true).timeout(
        const Duration(seconds: 2),
        onTimeout: () => throw Exception('Timeout in batch.commit in _createVersion1'),
      );
    } catch (e) {
      throw Exception('Error inside _createVersion1: $e');
    }
  }

  static Future<void> _createVersion2(DatabaseExecutor database) async {
    try {
      final batch = database.batch();
      
      batch.execute('''
        CREATE TABLE IF NOT EXISTS ${DatabaseTables.debts} (
          id TEXT PRIMARY KEY NOT NULL,
          user_id TEXT NOT NULL REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE,
          name TEXT NOT NULL CHECK (length(trim(name)) > 0),
          amount_minor INTEGER NOT NULL,
          currency_code TEXT NOT NULL CHECK (length(currency_code) = 3),
          due_date TEXT,
          is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');

      batch.execute('''
        CREATE TABLE IF NOT EXISTS ${DatabaseTables.subscriptions} (
          id TEXT PRIMARY KEY NOT NULL,
          user_id TEXT NOT NULL REFERENCES ${DatabaseTables.users}(id) ON DELETE CASCADE,
          name TEXT NOT NULL CHECK (length(trim(name)) > 0),
          amount_minor INTEGER NOT NULL,
          currency_code TEXT NOT NULL CHECK (length(currency_code) = 3),
          billing_cycle TEXT NOT NULL CHECK (billing_cycle IN ('monthly', 'yearly', 'weekly')),
          next_billing_date TEXT NOT NULL,
          is_active INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');

      batch.execute('PRAGMA user_version = 2');
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Error inside _createVersion2: $e');
    }
  }
}
