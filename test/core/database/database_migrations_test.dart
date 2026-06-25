import 'package:boveda_personal/core/database/database_migrations.dart';
import 'package:boveda_personal/core/database/database_schema.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(sqfliteFfiInit);

  test('DB-012 una base nueva migra desde cero a la versión actual', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

    await DatabaseMigrator.migrate(db, from: 0, to: DatabaseSchema.version);

    final version = await db.rawQuery('PRAGMA user_version');
    expect(version.single['user_version'], DatabaseSchema.version);
    await db.close();
  });

  test('DB-013 rechaza downgrade implícito', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

    await expectLater(
      DatabaseMigrator.migrate(db, from: 2, to: 1),
      throwsA(isA<UnsupportedError>()),
    );
    await db.close();
  });

  test('DB-014 no acepta una versión objetivo desconocida', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

    await expectLater(
      DatabaseMigrator.migrate(
        db,
        from: DatabaseSchema.version,
        to: DatabaseSchema.version + 1,
      ),
      throwsA(isA<UnsupportedError>()),
    );
    await db.close();
  });
}
