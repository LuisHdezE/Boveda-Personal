import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/dao/movement_dao.dart';
import 'package:boveda_personal/core/database/database_schema.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late BovedaDatabase database;
  late MovementDao dao;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = BovedaDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    dao = MovementDao(database);
    final db = await database.open();
    await db.insert(DatabaseTables.users, _user);
    await db.insert(DatabaseTables.accounts, _account);
  });

  tearDown(() => database.close());

  test('DB-017 filtra movimientos combinando criterios con AND', () async {
    await dao.insert(_movement(id: 'one', occurredAt: 10));
    await dao.insert(_movement(id: 'two', occurredAt: 20));

    final result = await dao.list(
      MovementQuery(
        accountId: 'usd',
        categoryId: 'expense-food',
        type: 'expense',
        startAt: 15,
        endAtExclusive: 30,
      ),
    );

    expect(result.map((row) => row['id']), ['two']);
  });

  test('DB-018 pagina con orden estable por fecha e id', () async {
    await dao.insert(_movement(id: 'a', occurredAt: 20));
    await dao.insert(_movement(id: 'b', occurredAt: 20));
    await dao.insert(_movement(id: 'c', occurredAt: 10));

    final first = await dao.list(MovementQuery(limit: 2));
    final second = await dao.list(MovementQuery(limit: 2, offset: 2));

    expect(first.map((row) => row['id']), ['b', 'a']);
    expect(second.map((row) => row['id']), ['c']);
  });
}

const _user = <String, Object?>{
  'id': 'user-1',
  'display_name': 'Luis',
  'username': 'luis',
  'password_hash': 'hash',
  'password_salt': 'salt',
  'created_at': 1,
  'updated_at': 1,
};

const _account = <String, Object?>{
  'id': 'usd',
  'user_id': 'user-1',
  'currency_code': 'USD',
  'currency_scale': 2,
  'name': 'Dólares',
  'created_at': 1,
  'updated_at': 1,
};

Map<String, Object?> _movement({
  required String id,
  required int occurredAt,
}) {
  return {
    'id': id,
    'account_id': 'usd',
    'category_id': 'expense-food',
    'type': 'expense',
    'amount_minor': 100,
    'occurred_at': occurredAt,
    'created_at': occurredAt,
    'updated_at': occurredAt,
  };
}
