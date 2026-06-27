import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/dao/user_settings_dao.dart';
import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/features/auth/data/sqlite_auth_repository.dart';
import 'package:boveda_personal/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late BovedaDatabase database;
  late SqliteAuthRepository repository;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = BovedaDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await database.open();
    repository = SqliteAuthRepository(UserSettingsDao(database));
  });

  tearDown(() => database.close());

  final _fixture = User(
    id: 'usr-001',
    displayName: 'Luis',
    username: 'luis',
    passwordHash: 'hashValue',
    passwordSalt: 'saltValue',
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );

  test('AUTH-REPO-001 findByUsername retorna null cuando no existe', () async {
    final result = await repository.findByUsername('noexiste');
    expect(result, isNull);
  });

  test('AUTH-REPO-002 save persiste y findByUsername recupera el usuario',
      () async {
    await repository.save(_fixture);
    final found = await repository.findByUsername('luis');

    expect(found, isNotNull);
    expect(found!.id, 'usr-001');
    expect(found.displayName, 'Luis');
    expect(found.passwordHash, 'hashValue');
    expect(found.passwordSalt, 'saltValue');
  });

  test('AUTH-REPO-003 findByUsername es case-insensitive', () async {
    await repository.save(_fixture);
    final found = await repository.findByUsername('LUIS');
    expect(found, isNotNull);
    expect(found!.username, 'luis');
  });

  test('AUTH-REPO-004 findByUsername retorna null para usuario distinto',
      () async {
    await repository.save(_fixture);
    final result = await repository.findByUsername('otro');
    expect(result, isNull);
  });
}
