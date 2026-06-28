import 'package:boveda_personal/core/database/dao/transfer_dao.dart';
import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/entities/transfer.dart';
import 'package:boveda_personal/features/movements/domain/repositories/transfer_repository.dart';

class SqliteTransferRepository implements TransferRepository {
  const SqliteTransferRepository(this._dao);

  final TransferDao _dao;

  @override
  Future<Transfer?> findById(String id) async {
    throw UnimplementedError('findById not implemented');
  }

  @override
  Future<void> create({
    required Transfer transfer,
    required Movement outgoing,
    required Movement incoming,
  }) async {
    await _dao.insert(
      transfer: _transferToRow(transfer),
      outgoingMovement: _movementToRow(outgoing),
      incomingMovement: _movementToRow(incoming),
    );
  }

  @override
  Future<void> replace({
    required Transfer transfer,
    required Movement outgoing,
    required Movement incoming,
  }) async {
    await _dao.replace(
      id: transfer.id,
      transfer: _transferToRow(transfer),
      outgoingMovement: _movementToRow(outgoing),
      incomingMovement: _movementToRow(incoming),
    );
  }

  @override
  Future<void> delete(String id) async {
    await _dao.delete(id);
  }

  static Map<String, Object?> _transferToRow(Transfer t) {
    return {
      'id': t.id,
      'source_account_id': t.sourceAccountId,
      'destination_account_id': t.destinationAccountId,
      'source_amount_minor': t.sourceAmount.minorUnits,
      'destination_amount_minor': t.destinationAmount.minorUnits,
      'exchange_rate': t.exchangeRate.toString(),
      'occurred_at': RowConverters.dateToSql(t.occurredAt),
      'note': t.note,
      'created_at': RowConverters.dateToSql(t.createdAt),
      'updated_at': RowConverters.dateToSql(t.updatedAt),
    };
  }

  static Map<String, Object?> _movementToRow(Movement m) {
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
