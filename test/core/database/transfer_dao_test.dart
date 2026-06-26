import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/dao/transfer_dao.dart';
import 'package:boveda_personal/core/database/database_schema.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late BovedaDatabase database;
  late TransferDao dao;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = BovedaDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    dao = TransferDao(database);
    final db = await database.open();
    await db.insert(DatabaseTables.users, _user);
    await db.insert(DatabaseTables.accounts, _usd);
    await db.insert(DatabaseTables.accounts, _peso);
  });

  tearDown(() => database.close());

  test('DB-019 crea transferencia y ambos movimientos atómicamente', () async {
    await dao.insert(
      transfer: _transfer,
      outgoingMovement: _outgoing,
      incomingMovement: _incoming,
    );
    final db = await database.open();

    expect(await db.query(DatabaseTables.transfers), hasLength(1));
    expect(await db.query(DatabaseTables.movements), hasLength(2));
  });

  test('DB-020 un fallo en el segundo movimiento revierte todo', () async {
    await expectLater(
      dao.insert(
        transfer: _transfer,
        outgoingMovement: _outgoing,
        incomingMovement: {..._incoming, 'amount_minor': 0},
      ),
      throwsA(isA<DatabaseException>()),
    );
    final db = await database.open();

    expect(await db.query(DatabaseTables.transfers), isEmpty);
    expect(await db.query(DatabaseTables.movements), isEmpty);
  });

  test('DB-021 eliminar transferencia elimina ambos movimientos', () async {
    await dao.insert(
      transfer: _transfer,
      outgoingMovement: _outgoing,
      incomingMovement: _incoming,
    );

    await dao.delete('transfer-1');
    final db = await database.open();

    expect(await db.query(DatabaseTables.transfers), isEmpty);
    expect(await db.query(DatabaseTables.movements), isEmpty);
  });

  test(
    'DB-025 impide desincronizar una transferencia con update directo',
    () async {
      await dao.insert(
        transfer: _transfer,
        outgoingMovement: _outgoing,
        incomingMovement: _incoming,
      );
      final db = await database.open();

      await expectLater(
        db.update(
          DatabaseTables.transfers,
          {'source_amount_minor': 200},
          where: 'id = ?',
          whereArgs: ['transfer-1'],
        ),
        throwsA(isA<DatabaseException>()),
      );
    },
  );
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

const _usd = <String, Object?>{
  'id': 'usd',
  'user_id': 'user-1',
  'currency_code': 'USD',
  'currency_scale': 2,
  'name': 'Dólares',
  'created_at': 1,
  'updated_at': 1,
};

const _peso = <String, Object?>{
  'id': 'peso',
  'user_id': 'user-1',
  'currency_code': 'UYU',
  'currency_scale': 2,
  'name': 'Pesos',
  'created_at': 1,
  'updated_at': 1,
};

const _transfer = <String, Object?>{
  'id': 'transfer-1',
  'source_account_id': 'usd',
  'destination_account_id': 'peso',
  'source_amount_minor': 100,
  'destination_amount_minor': 4000,
  'exchange_rate': '40',
  'occurred_at': 1,
  'created_at': 1,
  'updated_at': 1,
};

const _outgoing = <String, Object?>{
  'id': 'movement-out',
  'account_id': 'usd',
  'transfer_id': 'transfer-1',
  'type': 'transfer_out',
  'amount_minor': 100,
  'occurred_at': 1,
  'created_at': 1,
  'updated_at': 1,
};

const _incoming = <String, Object?>{
  'id': 'movement-in',
  'account_id': 'peso',
  'transfer_id': 'transfer-1',
  'type': 'transfer_in',
  'amount_minor': 4000,
  'occurred_at': 1,
  'created_at': 1,
  'updated_at': 1,
};
