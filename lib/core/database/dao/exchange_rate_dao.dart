import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/database_schema.dart';

class ExchangeRateDao {
  const ExchangeRateDao(this._database);

  static const columns = <String>[
    'id',
    'base_currency_code',
    'quote_currency_code',
    'rate',
    'effective_at',
    'created_at',
  ];

  final BovedaDatabase _database;

  Future<void> insert(Map<String, Object?> values) async {
    final db = await _database.open();
    await db.insert(DatabaseTables.exchangeRates, values);
  }

  Future<Map<String, Object?>?> latestAt({
    required String baseCurrencyCode,
    required String quoteCurrencyCode,
    required int instant,
  }) async {
    final db = await _database.open();
    final rows = await db.query(
      DatabaseTables.exchangeRates,
      columns: columns,
      where: '''
        base_currency_code = ?
        AND quote_currency_code = ?
        AND effective_at <= ?
      ''',
      whereArgs: [
        baseCurrencyCode.toUpperCase(),
        quoteCurrencyCode.toUpperCase(),
        instant,
      ],
      orderBy: 'effective_at DESC, id DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : rows.single;
  }

  Future<List<Map<String, Object?>>> history({
    required String baseCurrencyCode,
    required String quoteCurrencyCode,
  }) async {
    final db = await _database.open();
    return db.query(
      DatabaseTables.exchangeRates,
      columns: columns,
      where: 'base_currency_code = ? AND quote_currency_code = ?',
      whereArgs: [
        baseCurrencyCode.toUpperCase(),
        quoteCurrencyCode.toUpperCase(),
      ],
      orderBy: 'effective_at DESC, id DESC',
    );
  }
}
