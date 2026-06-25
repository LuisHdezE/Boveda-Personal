import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/movements/domain/entities/transfer.dart';
import 'package:decimal/decimal.dart';

class TransferModel {
  const TransferModel(this.entity);

  final Transfer entity;

  factory TransferModel.fromEntity(Transfer entity) => TransferModel(entity);

  factory TransferModel.fromRow(
    Map<String, Object?> row, {
    required Currency sourceCurrency,
    required Currency destinationCurrency,
  }) {
    return TransferModel(
      Transfer(
        id: row.requiredString('id'),
        sourceAccountId: row.requiredString('source_account_id'),
        destinationAccountId: row.requiredString('destination_account_id'),
        sourceAmount: Money(
          minorUnits: row.requiredInt('source_amount_minor'),
          currency: sourceCurrency,
        ),
        destinationAmount: Money(
          minorUnits: row.requiredInt('destination_amount_minor'),
          currency: destinationCurrency,
        ),
        exchangeRate: Decimal.parse(row.requiredString('exchange_rate')),
        occurredAt: row.requiredDate('occurred_at'),
        note: row.optionalString('note'),
        createdAt: row.requiredDate('created_at'),
        updatedAt: row.requiredDate('updated_at'),
      ),
    );
  }

  Transfer toEntity() => entity;

  Map<String, Object?> toRow() => {
        'id': entity.id,
        'source_account_id': entity.sourceAccountId,
        'destination_account_id': entity.destinationAccountId,
        'source_amount_minor': entity.sourceAmount.minorUnits,
        'destination_amount_minor': entity.destinationAmount.minorUnits,
        'exchange_rate': entity.exchangeRate.toString(),
        'occurred_at': RowConverters.dateToSql(entity.occurredAt),
        'note': entity.note,
        'created_at': RowConverters.dateToSql(entity.createdAt),
        'updated_at': RowConverters.dateToSql(entity.updatedAt),
      };
}
