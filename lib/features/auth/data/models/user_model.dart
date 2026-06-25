import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/features/auth/domain/entities/user.dart';

class UserModel {
  const UserModel(this.entity);

  final User entity;

  factory UserModel.fromEntity(User entity) => UserModel(entity);

  factory UserModel.fromRow(Map<String, Object?> row) {
    return UserModel(
      User(
        id: row.requiredString('id'),
        displayName: row.requiredString('display_name'),
        username: row.requiredString('username'),
        passwordHash: row.requiredString('password_hash'),
        passwordSalt: row.requiredString('password_salt'),
        createdAt: row.requiredDate('created_at'),
        updatedAt: row.requiredDate('updated_at'),
      ),
    );
  }

  User toEntity() => entity;

  Map<String, Object?> toRow() => {
        'id': entity.id,
        'display_name': entity.displayName,
        'username': entity.username,
        'password_hash': entity.passwordHash,
        'password_salt': entity.passwordSalt,
        'created_at': RowConverters.dateToSql(entity.createdAt),
        'updated_at': RowConverters.dateToSql(entity.updatedAt),
      };
}
