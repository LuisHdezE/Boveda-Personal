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
        case 3:
          await _createVersion3(database);
          break;
        case 4:
          await _createVersion4(database);
          break;
        case 5:
          await _createVersion5(database);
          break;
        case 6:
          await _createVersion6(database);
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
        // Only insert if it doesn't exist to allow safe re-running or migrations
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

  static Future<void> _createVersion3(DatabaseExecutor database) async {
    try {
      final columns = await database.rawQuery('PRAGMA table_info(${DatabaseTables.settings})');
      final hasColumn = columns.any((col) => col['name'] == 'secondary_currency_code');
      
      final batch = database.batch();
      if (!hasColumn) {
        batch.execute('''
          ALTER TABLE ${DatabaseTables.settings} 
          ADD COLUMN secondary_currency_code TEXT NOT NULL DEFAULT 'CUP'
        ''');
      }
      batch.execute('PRAGMA user_version = 3');
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Error inside _createVersion3: $e');
    }
  }

  static Future<void> _createVersion4(DatabaseExecutor database) async {
    try {
      final columns = await database.rawQuery('PRAGMA table_info(${DatabaseTables.subscriptions})');
      final hasColumn = columns.any((col) => col['name'] == 'last_payment_date');
      
      final batch = database.batch();
      if (!hasColumn) {
        batch.execute('''
          ALTER TABLE ${DatabaseTables.subscriptions} 
          ADD COLUMN last_payment_date TEXT
        ''');
      }
      
      final category = DatabaseSeeds.systemCategories.firstWhere((c) => c['id'] == 'expense-subscriptions');
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

      batch.execute('PRAGMA user_version = 4');
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Error inside _createVersion4: $e');
    }
  }

  static Future<void> _createVersion5(DatabaseExecutor database) async {
    try {
      final columns = await database.rawQuery('PRAGMA table_info(${DatabaseTables.debts})');
      final hasRemaining = columns.any((col) => col['name'] == 'remaining_amount_minor');
      
      final batch = database.batch();
      if (!hasRemaining) {
        batch.execute('''
          ALTER TABLE ${DatabaseTables.debts} 
          ADD COLUMN remaining_amount_minor INTEGER NOT NULL DEFAULT 0
        ''');
        batch.execute('''
          ALTER TABLE ${DatabaseTables.debts} 
          ADD COLUMN total_installments INTEGER
        ''');
        batch.execute('''
          ALTER TABLE ${DatabaseTables.debts} 
          ADD COLUMN paid_installments INTEGER NOT NULL DEFAULT 0
        ''');
        batch.execute('''
          UPDATE ${DatabaseTables.debts} 
          SET remaining_amount_minor = amount_minor
        ''');
      }
      
      final category = DatabaseSeeds.systemCategories.firstWhere((c) => c['id'] == 'expense-debts');
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

      batch.execute('PRAGMA user_version = 5');
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Error inside _createVersion5: $e');
    }
  }

  static Future<void> _createVersion6(DatabaseExecutor database) async {
    try {
      final batch = database.batch();
      batch.execute('PRAGMA user_version = 6');
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception('Error inside _createVersion6: $e');
    }
  }
}
