import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';

class MovementModel {
  const MovementModel(this.entity);

  final Movement entity;

  factory MovementModel.fromEntity(Movement entity) => MovementModel(entity);

  factory MovementModel.fromRow(
    Map<String, Object?> row, {
    required Currency currency,
  }) {
    return MovementModel(
      Movement(
        id: row.requiredString('id'),
        accountId: row.requiredString('account_id'),
        categoryId: row.optionalString('category_id'),
        transferId: row.optionalString('transfer_id'),
        type: MovementType.fromStorage(row.requiredString('type')),
        amount: Money(
          minorUnits: row.requiredInt('amount_minor'),
          currency: currency,
        ),
        occurredAt: row.requiredDate('occurred_at'),
        note: row.optionalString('note'),
        createdAt: row.requiredDate('created_at'),
        updatedAt: row.requiredDate('updated_at'),
      ),
    );
  }

  Movement toEntity() => entity;

  Map<String, Object?> toRow() => {
        'id': entity.id,
        'account_id': entity.accountId,
        'category_id': entity.categoryId,
        'transfer_id': entity.transferId,
        'type': entity.type.value,
        'amount_minor': entity.amount.minorUnits,
        'occurred_at': RowConverters.dateToSql(entity.occurredAt),
        'note': entity.note,
        'created_at': RowConverters.dateToSql(entity.createdAt),
        'updated_at': RowConverters.dateToSql(entity.updatedAt),
      };
}
