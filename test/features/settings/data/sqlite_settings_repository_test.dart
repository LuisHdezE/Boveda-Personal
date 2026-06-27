import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/dao/user_settings_dao.dart';
import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/features/settings/data/sqlite_settings_repository.dart';
import 'package:boveda_personal/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late BovedaDatabase database;
  late SqliteSettingsRepository repository;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = BovedaDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await database.open();
    repository = SqliteSettingsRepository(UserSettingsDao(database));
  });

  tearDown(() => database.close());

  final _fixture = AppSettings(
    userId: 'user-1',
    primaryCurrencyCode: 'ARS',
    locale: 'es_AR',
    biometricsEnabled: false,
    autoLockDuration: const Duration(minutes: 5),
    onboardingCompleted: true,
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );

  test('SET-REPO-001 load retorna null cuando no hay settings', () async {
    final result = await repository.load();
    expect(result, isNull);
  });

  test('SET-REPO-002 save persiste y load recupera los settings', () async {
    // Primero se necesita un usuario en la BD (FK)
    final userRow = {
      'id': 'user-1',
      'display_name': 'Test User',
      'username': 'testuser',
      'password_hash': 'hash',
      'password_salt': 'salt',
      'created_at': RowConverters.dateToSql(DateTime.utc(2026, 1, 1)),
      'updated_at': RowConverters.dateToSql(DateTime.utc(2026, 1, 1)),
    };
    final userDao = UserSettingsDao(database);
    await userDao.insertUser(userRow);

    await repository.save(_fixture);
    final loaded = await repository.load();

    expect(loaded, isNotNull);
    expect(loaded!.userId, 'user-1');
    expect(loaded.primaryCurrencyCode, 'ARS');
    expect(loaded.locale, 'es_AR');
    expect(loaded.biometricsEnabled, isFalse);
    expect(loaded.onboardingCompleted, isTrue);
  });

  test('SET-REPO-003 save reemplaza settings existentes (upsert)', () async {
    final userDao = UserSettingsDao(database);
    await userDao.insertUser({
      'id': 'user-1',
      'display_name': 'Test',
      'username': 'test',
      'password_hash': 'h',
      'password_salt': 's',
      'created_at': RowConverters.dateToSql(DateTime.utc(2026, 1, 1)),
      'updated_at': RowConverters.dateToSql(DateTime.utc(2026, 1, 1)),
    });

    await repository.save(_fixture);
    final updated = _fixture.copyWith(locale: 'en_US', updatedAt: DateTime.utc(2026, 6, 1));
    await repository.save(updated);

    final loaded = await repository.load();
    expect(loaded!.locale, 'en_US');
  });
}
