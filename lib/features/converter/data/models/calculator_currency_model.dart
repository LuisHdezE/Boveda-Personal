import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/features/converter/domain/entities/calculator_currency.dart';
import 'package:decimal/decimal.dart';

class CalculatorCurrencyModel {
  const CalculatorCurrencyModel(this.entity);

  final CalculatorCurrency entity;

  factory CalculatorCurrencyModel.fromEntity(CalculatorCurrency entity) {
    return CalculatorCurrencyModel(entity);
  }

  factory CalculatorCurrencyModel.fromRow(Map<String, Object?> row) {
    return CalculatorCurrencyModel(
      CalculatorCurrency(
        id: row.requiredString('id'),
        name: row.requiredString('name'),
        currency: Currency(
          code: row.requiredString('code'),
          scale: row.requiredInt('currency_scale'),
        ),
        symbol: row.requiredString('symbol'),
        unitsPerUsd: Decimal.parse(row.requiredString('units_per_usd')),
        isActive: row.requiredBool('is_active'),
        createdAt: row.requiredDate('created_at'),
        updatedAt: row.requiredDate('updated_at'),
      ),
    );
  }

  CalculatorCurrency toEntity() => entity;

  Map<String, Object?> toRow() => {
        'id': entity.id,
        'name': entity.name,
        'code': entity.currency.code,
        'symbol': entity.symbol,
        'currency_scale': entity.currency.scale,
        'units_per_usd': entity.unitsPerUsd.toString(),
        'is_active': RowConverters.boolToSql(entity.isActive),
        'created_at': RowConverters.dateToSql(entity.createdAt),
        'updated_at': RowConverters.dateToSql(entity.updatedAt),
      };
}
