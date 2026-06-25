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
      }
    }
  }

  static Future<void> _createVersion1(DatabaseExecutor database) async {
    final batch = database.batch();
    for (final statement in DatabaseSchema.createStatements) {
      batch.execute(statement);
    }
    for (final category in DatabaseSeeds.systemCategories) {
      batch.rawInsert(
        '''
        INSERT OR IGNORE INTO ${DatabaseTables.categories} (
          id,
          name,
          icon,
          color,
          movement_type,
          is_system,
          is_active,
          created_at,
          updated_at
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
    await batch.commit(noResult: true);
  }
}
