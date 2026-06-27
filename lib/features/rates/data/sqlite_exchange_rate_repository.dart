import 'package:boveda_personal/core/database/dao/exchange_rate_dao.dart';
import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/features/rates/domain/entities/exchange_rate.dart';
import 'package:boveda_personal/features/rates/domain/repositories/exchange_rate_repository.dart';
import 'package:decimal/decimal.dart';

class SqliteExchangeRateRepository implements ExchangeRateRepository {
  const SqliteExchangeRateRepository(this._dao);

  final ExchangeRateDao _dao;

  @override
  Future<ExchangeRate?> latestAt({
    required String baseCurrencyCode,
    required String quoteCurrencyCode,
    required DateTime instant,
  }) async {
    final row = await _dao.latestAt(
      baseCurrencyCode: baseCurrencyCode,
      quoteCurrencyCode: quoteCurrencyCode,
      instant: RowConverters.dateToSql(instant),
    );
    if (row == null) return null;
    return _fromRow(row);
  }

  @override
  Future<List<ExchangeRate>> history({
    required String baseCurrencyCode,
    required String quoteCurrencyCode,
  }) async {
    final rows = await _dao.history(
      baseCurrencyCode: baseCurrencyCode,
      quoteCurrencyCode: quoteCurrencyCode,
    );
    return rows.map(_fromRow).toList();
  }

  @override
  Future<void> save(ExchangeRate rate) async {
    await _dao.insert(_toRow(rate));
  }

  // ─── Mapeo ────────────────────────────────────────────────────────────────

  static ExchangeRate _fromRow(Map<String, Object?> row) {
    return ExchangeRate(
      id: row.requiredString('id'),
      baseCurrencyCode: row.requiredString('base_currency_code'),
      quoteCurrencyCode: row.requiredString('quote_currency_code'),
      rate: Decimal.parse(row.requiredString('rate')),
      effectiveAt: row.requiredDate('effective_at'),
      createdAt: row.requiredDate('created_at'),
    );
  }

  static Map<String, Object?> _toRow(ExchangeRate r) {
    return {
      'id': r.id,
      'base_currency_code': r.baseCurrencyCode,
      'quote_currency_code': r.quoteCurrencyCode,
      'rate': r.rate.toString(),
      'effective_at': RowConverters.dateToSql(r.effectiveAt),
      'created_at': RowConverters.dateToSql(r.createdAt),
    };
  }
}
