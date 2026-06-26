import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/features/rates/domain/entities/exchange_rate.dart';
import 'package:decimal/decimal.dart';

class ExchangeRateModel {
  const ExchangeRateModel(this.entity);

  final ExchangeRate entity;

  factory ExchangeRateModel.fromEntity(ExchangeRate entity) {
    return ExchangeRateModel(entity);
  }

  factory ExchangeRateModel.fromRow(Map<String, Object?> row) {
    return ExchangeRateModel(
      ExchangeRate(
        id: row.requiredString('id'),
        baseCurrencyCode: row.requiredString('base_currency_code'),
        quoteCurrencyCode: row.requiredString('quote_currency_code'),
        rate: Decimal.parse(row.requiredString('rate')),
        effectiveAt: row.requiredDate('effective_at'),
        createdAt: row.requiredDate('created_at'),
      ),
    );
  }

  ExchangeRate toEntity() => entity;

  Map<String, Object?> toRow() => {
    'id': entity.id,
    'base_currency_code': entity.baseCurrencyCode,
    'quote_currency_code': entity.quoteCurrencyCode,
    'rate': entity.rate.toString(),
    'effective_at': RowConverters.dateToSql(entity.effectiveAt),
    'created_at': RowConverters.dateToSql(entity.createdAt),
  };
}
