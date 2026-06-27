import 'package:boveda_personal/core/database/database_constants.dart';
import 'package:boveda_personal/core/database/database_migrations.dart';
import 'package:boveda_personal/core/database/database_schema.dart';
import 'package:path/path.dart' as path_util;
import 'package:sqflite/sqflite.dart';

class BovedaDatabase {
  BovedaDatabase({DatabaseFactory? factory, String? path})
    : _factory = factory ?? databaseFactory,
      _path = path;

  final DatabaseFactory _factory;
  final String? _path;
  Database? _database;

  Future<Database> open() async {
    final current = _database;
    if (current != null && current.isOpen) {
      return current;
    }

    final databasePath = _path ??
        path_util.join(
          await _factory.getDatabasesPath(),
          DatabaseConstants.name,
        );

    final opened = await _factory.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: DatabaseSchema.version,
        onConfigure: _configure,
        onCreate: (db, version) =>
            DatabaseMigrator.migrate(db, from: 0, to: version),
        onUpgrade: (db, oldVersion, newVersion) =>
            DatabaseMigrator.migrate(db, from: oldVersion, to: newVersion),
        onDowngrade: (db, oldVersion, newVersion) {
          throw UnsupportedError(
            'Database downgrade is not supported: '
            '$oldVersion -> $newVersion',
          );
        },
        onOpen: _verifyIntegrity,
      ),
    );
    _database = opened;
    return opened;
  }

  Future<T> transaction<T>(
    Future<T> Function(Transaction transaction) action,
  ) async {
    final db = await open();
    return db.transaction(action);
  }

  Future<void> close() async {
    final current = _database;
    _database = null;
    if (current != null && current.isOpen) {
      await current.close();
    }
  }

  static Future<void> _configure(Database db) async {
    await db.rawQuery('PRAGMA foreign_keys = ON');
    await db.rawQuery('PRAGMA secure_delete = ON');
    await db.rawQuery(
      'PRAGMA busy_timeout = ${DatabaseConstants.busyTimeoutMilliseconds}',
    );
  }

  static Future<void> _verifyIntegrity(Database db) async {
    final foreignKeys = await db.rawQuery('PRAGMA foreign_keys');
    if (foreignKeys.single['foreign_keys'] != 1) {
      throw StateError('SQLite foreign key enforcement is disabled');
    }

    final version = await db.rawQuery('PRAGMA user_version');
    if (version.single['user_version'] != DatabaseSchema.version) {
      throw StateError('Unexpected SQLite schema version');
    }
  }
}
