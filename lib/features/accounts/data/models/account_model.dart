import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account.dart';

class AccountModel {
  const AccountModel(this.entity);

  final Account entity;

  factory AccountModel.fromEntity(Account entity) => AccountModel(entity);

  factory AccountModel.fromRow(Map<String, Object?> row) {
    return AccountModel(
      Account(
        id: row.requiredString('id'),
        userId: row.requiredString('user_id'),
        currency: Currency(
          code: row.requiredString('currency_code'),
          scale: row.requiredInt('currency_scale'),
        ),
        name: row.requiredString('name'),
        isActive: row.requiredBool('is_active'),
        createdAt: row.requiredDate('created_at'),
        updatedAt: row.requiredDate('updated_at'),
      ),
    );
  }

  Account toEntity() => entity;

  Map<String, Object?> toRow() => {
        'id': entity.id,
        'user_id': entity.userId,
        'currency_code': entity.currency.code,
        'currency_scale': entity.currency.scale,
        'name': entity.name,
        'is_active': RowConverters.boolToSql(entity.isActive),
        'created_at': RowConverters.dateToSql(entity.createdAt),
        'updated_at': RowConverters.dateToSql(entity.updatedAt),
      };
}
