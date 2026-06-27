import 'package:boveda_personal/core/database/dao/user_settings_dao.dart';
import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/features/auth/domain/entities/user.dart';
import 'package:boveda_personal/features/auth/domain/repositories/auth_repository.dart';

class SqliteAuthRepository implements AuthRepository {
  const SqliteAuthRepository(this._dao);

  final UserSettingsDao _dao;

  @override
  Future<User?> findByUsername(String username) async {
    final row = await _dao.findUserByUsername(username);
    if (row == null) return null;
    return _fromRow(row);
  }

  @override
  Future<void> save(User user) async {
    await _dao.insertUser(_toRow(user));
  }

  // ─── Mapeo ────────────────────────────────────────────────────────────────

  static User _fromRow(Map<String, Object?> row) {
    return User(
      id: row.requiredString('id'),
      displayName: row.requiredString('display_name'),
      username: row.requiredString('username'),
      passwordHash: row.requiredString('password_hash'),
      passwordSalt: row.requiredString('password_salt'),
      createdAt: row.requiredDate('created_at'),
      updatedAt: row.requiredDate('updated_at'),
    );
  }

  static Map<String, Object?> _toRow(User u) {
    return {
      'id': u.id,
      'display_name': u.displayName,
      'username': u.username,
      'password_hash': u.passwordHash,
      'password_salt': u.passwordSalt,
      'created_at': RowConverters.dateToSql(u.createdAt),
      'updated_at': RowConverters.dateToSql(u.updatedAt),
    };
  }
}
