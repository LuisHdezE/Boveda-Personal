import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/dao/exchange_rate_dao.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late BovedaDatabase database;
  late ExchangeRateDao dao;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    database = BovedaDatabase(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    dao = ExchangeRateDao(database);
    await database.open();
  });

  tearDown(() => database.close());

  test('DB-022 obtiene la última tasa no posterior al instante', () async {
    await dao.insert(_rate(id: 'old', rate: '39', effectiveAt: 10));
    await dao.insert(_rate(id: 'current', rate: '40', effectiveAt: 20));
    await dao.insert(_rate(id: 'future', rate: '41', effectiveAt: 30));

    final result = await dao.latestAt(
      baseCurrencyCode: 'USD',
      quoteCurrencyCode: 'UYU',
      instant: 25,
    );

    expect(result?['id'], 'current');
  });

  test('DB-023 devuelve null cuando no existe una tasa aplicable', () async {
    await dao.insert(_rate(id: 'future', rate: '41', effectiveAt: 30));

    final result = await dao.latestAt(
      baseCurrencyCode: 'USD',
      quoteCurrencyCode: 'UYU',
      instant: 20,
    );

    expect(result, isNull);
  });
}

Map<String, Object?> _rate({
  required String id,
  required String rate,
  required int effectiveAt,
}) {
  return {
    'id': id,
    'base_currency_code': 'USD',
    'quote_currency_code': 'UYU',
    'rate': rate,
    'effective_at': effectiveAt,
    'created_at': effectiveAt,
  };
}
