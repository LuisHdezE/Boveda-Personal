import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/database_schema.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late BovedaDatabase database;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = BovedaDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await database.open();
  });

  tearDown(() => database.close());

  test('DB-001 crea todas las tablas, índices, vista y triggers', () async {
    final db = await database.open();
    final objects = await db.rawQuery('''
      SELECT type, name
      FROM sqlite_master
      WHERE name NOT LIKE 'sqlite_%'
      ORDER BY type, name
      ''');

    final names = objects.map((row) => row['name']).toSet();

    expect(names, containsAll(DatabaseSchema.requiredObjects));
  });

  test('DB-002 activa claves foráneas en cada conexión', () async {
    final db = await database.open();

    final result = await db.rawQuery('PRAGMA foreign_keys');

    expect(result.single['foreign_keys'], 1);
  });

  test('DB-003 registra la versión inicial del esquema', () async {
    final db = await database.open();

    final result = await db.rawQuery('PRAGMA user_version');

    expect(result.single['user_version'], DatabaseSchema.version);
  });

  test('DB-024 activa borrado seguro de páginas SQLite', () async {
    final db = await database.open();

    final result = await db.rawQuery('PRAGMA secure_delete');

    expect(result.single['secure_delete'], 1);
  });

  test('DB-004 inserta exactamente las categorías del sistema', () async {
    final db = await database.open();

    final rows = await db.query(DatabaseTables.categories);

    expect(rows, hasLength(DatabaseSeeds.systemCategories.length));
    expect(
      rows.map((row) => row['id']).toSet(),
      DatabaseSeeds.systemCategories.map((row) => row['id']).toSet(),
    );
    expect(rows.every((row) => row['is_system'] == 1), isTrue);
  });

  test('DB-005 abrir nuevamente no duplica seeds', () async {
    await database.close();
    await database.open();
    final db = await database.open();

    final rows = await db.query(DatabaseTables.categories);

    expect(rows, hasLength(DatabaseSeeds.systemCategories.length));
  });

  test('DB-006 deriva el saldo aplicando el signo por tipo', () async {
    final db = await database.open();
    await _insertUserAndAccount(db);
    await db.insert(DatabaseTables.movements, {
      'id': 'opening',
      'account_id': 'usd',
      'type': 'opening',
      'amount_minor': 100000,
      'occurred_at': 1,
      'created_at': 1,
      'updated_at': 1,
    });
    await db.insert(DatabaseTables.movements, {
      'id': 'expense',
      'account_id': 'usd',
      'category_id': 'expense-food',
      'type': 'expense',
      'amount_minor': 2500,
      'occurred_at': 2,
      'created_at': 2,
      'updated_at': 2,
    });

    final balance = await db.query(
      DatabaseViews.accountBalances,
      where: 'account_id = ?',
      whereArgs: ['usd'],
    );

    expect(balance.single['balance_minor'], 97500);
  });

  test('DB-007 revierte completamente una transacción fallida', () async {
    final db = await database.open();

    await expectLater(
      db.transaction((txn) async {
        await txn.insert(DatabaseTables.users, _userRow());
        throw StateError('forced failure');
      }),
      throwsStateError,
    );

    expect(await db.query(DatabaseTables.users), isEmpty);
  });

  test('DB-008 rechaza códigos de moneda no normalizados', () async {
    final db = await database.open();
    await db.insert(DatabaseTables.users, _userRow());

    await expectLater(
      db.insert(DatabaseTables.accounts, {
        'id': 'bad-currency',
        'user_id': 'user-1',
        'currency_code': 'usd',
        'currency_scale': 2,
        'name': 'USD',
        'created_at': 1,
        'updated_at': 1,
      }),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('DB-009 rechaza importes no positivos', () async {
    final db = await database.open();
    await _insertUserAndAccount(db);

    await expectLater(
      db.insert(DatabaseTables.movements, {
        'id': 'invalid',
        'account_id': 'usd',
        'type': 'income',
        'amount_minor': 0,
        'occurred_at': 1,
        'created_at': 1,
        'updated_at': 1,
      }),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('DB-010 exige transfer_id para movimientos de transferencia', () async {
    final db = await database.open();
    await _insertUserAndAccount(db);

    await expectLater(
      db.insert(DatabaseTables.movements, {
        'id': 'invalid-transfer',
        'account_id': 'usd',
        'type': 'transfer_out',
        'amount_minor': 100,
        'occurred_at': 1,
        'created_at': 1,
        'updated_at': 1,
      }),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('DB-011 impide eliminar categorías con historial', () async {
    final db = await database.open();
    await _insertUserAndAccount(db);
    await db.insert(DatabaseTables.movements, {
      'id': 'expense',
      'account_id': 'usd',
      'category_id': 'expense-food',
      'type': 'expense',
      'amount_minor': 100,
      'occurred_at': 1,
      'created_at': 1,
      'updated_at': 1,
    });

    await expectLater(
      db.delete(
        DatabaseTables.categories,
        where: 'id = ?',
        whereArgs: ['expense-food'],
      ),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('DB-015 rechaza una categoría incompatible con el movimiento', () async {
    final db = await database.open();
    await _insertUserAndAccount(db);

    await expectLater(
      db.insert(DatabaseTables.movements, {
        'id': 'invalid-category',
        'account_id': 'usd',
        'category_id': 'expense-food',
        'type': 'income',
        'amount_minor': 100,
        'occurred_at': 1,
        'created_at': 1,
        'updated_at': 1,
      }),
      throwsA(isA<DatabaseException>()),
    );
  });

  test('DB-016 rechaza movimientos nuevos en una cuenta inactiva', () async {
    final db = await database.open();
    await _insertUserAndAccount(db);
    await db.update(
      DatabaseTables.accounts,
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: ['usd'],
    );

    await expectLater(
      db.insert(DatabaseTables.movements, {
        'id': 'inactive-account',
        'account_id': 'usd',
        'category_id': 'income-salary',
        'type': 'income',
        'amount_minor': 100,
        'occurred_at': 1,
        'created_at': 1,
        'updated_at': 1,
      }),
      throwsA(isA<DatabaseException>()),
    );
  });
}

Map<String, Object?> _userRow() => {
  'id': 'user-1',
  'display_name': 'Luis',
  'username': 'luis',
  'password_hash': 'hash',
  'password_salt': 'salt',
  'created_at': 1,
  'updated_at': 1,
};

Future<void> _insertUserAndAccount(Database db) async {
  await db.insert(DatabaseTables.users, _userRow());
  await db.insert(DatabaseTables.accounts, {
    'id': 'usd',
    'user_id': 'user-1',
    'currency_code': 'USD',
    'currency_scale': 2,
    'name': 'Dólares',
    'created_at': 1,
    'updated_at': 1,
  });
}
