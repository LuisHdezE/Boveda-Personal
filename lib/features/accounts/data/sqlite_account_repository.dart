import 'package:boveda_personal/core/database/dao/account_dao.dart';
import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account_balance.dart';
import 'package:boveda_personal/features/accounts/domain/repositories/account_repository.dart';

class SqliteAccountRepository implements AccountRepository {
  const SqliteAccountRepository(this._dao);

  final AccountDao _dao;

  @override
  Future<Account?> findById(String id) async {
    final row = await _dao.findById(id);
    if (row == null) return null;
    return _accountFromRow(row);
  }

  @override
  Future<List<Account>> list({bool activeOnly = false}) async {
    final rows = await _dao.list(activeOnly: activeOnly);
    return rows.map(_accountFromRow).toList();
  }

  @override
  Future<List<AccountBalance>> balances() async {
    final rows = await _dao.list();
    final result = <AccountBalance>[];
    for (final row in rows) {
      final account = _accountFromRow(row);
      final minor = await _dao.balanceMinor(account.id);
      result.add(AccountBalance(
        accountId: account.id,
        userId: account.userId,
        currency: account.currency,
        balance: Money(minorUnits: minor ?? 0, currency: account.currency),
      ));
    }
    return result;
  }

  @override
  Future<void> save(Account account) async {
    await _dao.insert(_toRow(account));
  }

  @override
  Future<void> setActive(String id, {required bool active}) async {
    await _dao.setActive(id, active: active);
  }

  // ─── Mapeo ────────────────────────────────────────────────────────────────

  static Account _accountFromRow(Map<String, Object?> row) {
    final currency = Currency(
      code: row.requiredString('currency_code'),
      scale: row.requiredInt('currency_scale'),
    );
    return Account(
      id: row.requiredString('id'),
      userId: row.requiredString('user_id'),
      currency: currency,
      name: row.requiredString('name'),
      isActive: row.requiredBool('is_active'),
      createdAt: row.requiredDate('created_at'),
      updatedAt: row.requiredDate('updated_at'),
    );
  }

  static Map<String, Object?> _toRow(Account a) {
    return {
      'id': a.id,
      'user_id': a.userId,
      'currency_code': a.currency.code,
      'currency_scale': a.currency.scale,
      'name': a.name,
      'is_active': RowConverters.boolToSql(a.isActive),
      'created_at': RowConverters.dateToSql(a.createdAt),
      'updated_at': RowConverters.dateToSql(a.updatedAt),
    };
  }
}
