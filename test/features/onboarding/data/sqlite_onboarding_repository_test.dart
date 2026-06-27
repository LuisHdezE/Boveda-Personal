import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/dao/account_dao.dart';
import 'package:boveda_personal/core/database/dao/exchange_rate_dao.dart';
import 'package:boveda_personal/core/database/dao/movement_dao.dart';
import 'package:boveda_personal/core/database/dao/user_settings_dao.dart';
import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/features/onboarding/data/sqlite_onboarding_repository.dart';
import 'package:boveda_personal/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:boveda_personal/models.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late BovedaDatabase database;
  late SqliteOnboardingRepository repository;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = BovedaDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    await database.open();
    repository = SqliteOnboardingRepository(
      database: database,
      userDao: UserSettingsDao(database),
      accountDao: AccountDao(database),
      movementDao: MovementDao(database),
      exchangeRateDao: ExchangeRateDao(database),
    );
  });

  tearDown(() => database.close());

  final _ars = Currency(code: 'ARS', scale: 2);
  final _usd = Currency(code: 'USD', scale: 2);

  OnboardingData _buildData({bool withOpeningBalances = false}) {
    final now = DateTime.utc(2026, 1, 1);
    final user = User(
      id: 'u1',
      displayName: 'Luis',
      username: 'luis',
      passwordHash: 'h',
      passwordSalt: 's',
      createdAt: now,
      updatedAt: now,
    );
    final primary = Account(
      id: 'acc-ars',
      userId: 'u1',
      currency: _ars,
      name: 'ARS',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    final secondary = Account(
      id: 'acc-usd',
      userId: 'u1',
      currency: _usd,
      name: 'USD',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    final settings = AppSettings(
      userId: 'u1',
      primaryCurrencyCode: 'ARS',
      locale: 'es_AR',
      biometricsEnabled: false,
      autoLockDuration: Duration.zero,
      onboardingCompleted: true,
      createdAt: now,
      updatedAt: now,
    );
    final rate = ExchangeRate(
      id: 'rate-1',
      baseCurrencyCode: 'ARS',
      quoteCurrencyCode: 'USD',
      rate: Decimal.parse('1000'),
      effectiveAt: now,
      createdAt: now,
    );
    final openingMovements = withOpeningBalances
        ? [
            Movement(
              id: 'mov-1',
              accountId: 'acc-ars',
              type: MovementType.opening,
              amount: Money(minorUnits: 100000, currency: _ars),
              occurredAt: now,
              createdAt: now,
              updatedAt: now,
            ),
          ]
        : <Movement>[];
    return OnboardingData(
      user: user,
      settings: settings,
      accounts: [primary, secondary],
      initialRate: rate,
      openingMovements: openingMovements,
    );
  }

  test('ONB-REPO-001 isConfigured retorna false en BD vacía', () async {
    expect(await repository.isConfigured(), isFalse);
  });

  test('ONB-REPO-002 initialize persiste usuario, cuentas, settings y tasa',
      () async {
    await repository.initialize(_buildData());
    expect(await repository.isConfigured(), isTrue);
  });

  test('ONB-REPO-003 initialize con saldo inicial persiste movimiento',
      () async {
    await repository.initialize(_buildData(withOpeningBalances: true));
    expect(await repository.isConfigured(), isTrue);
  });

  test('ONB-REPO-004 initialize es atómico: falla si datos duplicados',
      () async {
    await repository.initialize(_buildData());
    // Segunda llamada debe fallar (usuario ya existe)
    expect(
      () => repository.initialize(_buildData()),
      throwsA(isA<Exception>()),
    );
  });
}
