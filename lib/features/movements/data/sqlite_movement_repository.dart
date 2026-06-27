import 'package:boveda_personal/core/database/dao/movement_dao.dart';
import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/movements/domain/repositories/movement_repository.dart';
import 'package:boveda_personal/features/accounts/domain/repositories/account_repository.dart';

class SqliteMovementRepository implements MovementRepository {
  const SqliteMovementRepository({
    required MovementDao dao,
    required AccountRepository accounts,
  }) : _dao = dao,
       _accounts = accounts;

  final MovementDao _dao;
  final AccountRepository _accounts;

  @override
  Future<Movement?> findById(String id) async {
    final row = await _dao.findById(id);
    if (row == null) return null;
    return _fromRow(row, await _currencyForAccount(row.requiredString('account_id')));
  }

  @override
  Future<List<Movement>> list(MovementFilter filter, PageRequest page) async {
    final query = MovementQuery(
      accountId: filter.accountId,
      categoryId: filter.categoryId,
      type: filter.types.length == 1 ? filter.types.first.value : null,
      startAt: filter.period != null
          ? RowConverters.dateToSql(filter.period!.start)
          : null,
      endAtExclusive: filter.period != null
          ? RowConverters.dateToSql(filter.period!.endExclusive)
          : null,
      limit: page.limit,
      offset: page.offset,
    );
    final rows = await _dao.list(query);
    final result = <Movement>[];
    for (final row in rows) {
      final currency = await _currencyForAccount(row.requiredString('account_id'));
      result.add(_fromRow(row, currency));
    }
    return result;
  }

  @override
  Future<void> create(Movement movement) async {
    await _dao.insert(_toRow(movement));
  }

  @override
  Future<void> update(Movement movement) async {
    await _dao.update(movement.id, _toRow(movement));
  }

  @override
  Future<void> delete(String id) async {
    await _dao.delete(id);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Future<Currency> _currencyForAccount(String accountId) async {
    final account = await _accounts.findById(accountId);
    if (account == null) throw StateError('Account not found: $accountId');
    return account.currency;
  }

  static Movement _fromRow(Map<String, Object?> row, Currency currency) {
    return Movement(
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
    );
  }

  static Map<String, Object?> _toRow(Movement m) {
    return {
      'id': m.id,
      'account_id': m.accountId,
      'category_id': m.categoryId,
      'transfer_id': m.transferId,
      'type': m.type.value,
      'amount_minor': m.amount.minorUnits,
      'occurred_at': RowConverters.dateToSql(m.occurredAt),
      'note': m.note,
      'created_at': RowConverters.dateToSql(m.createdAt),
      'updated_at': RowConverters.dateToSql(m.updatedAt),
    };
  }
}
