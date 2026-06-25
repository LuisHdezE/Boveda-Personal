import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/core/ports/id_generator.dart';
import 'package:boveda_personal/features/accounts/domain/repositories/account_repository.dart';
import 'package:boveda_personal/features/movements/domain/commands/movement_commands.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/entities/transfer.dart';
import 'package:boveda_personal/features/movements/domain/repositories/transfer_repository.dart';

class ExecuteTransfer {
  const ExecuteTransfer({
    required this.repository,
    required this.accounts,
    required this.ids,
    required this.now,
  });

  final TransferRepository repository;
  final AccountRepository accounts;
  final IdGenerator ids;
  final DateTime Function() now;

  Future<Transfer> call(TransferDraft draft) async {
    final source = await accounts.findById(draft.sourceAccountId);
    final destination = await accounts.findById(draft.destinationAccountId);
    if (source == null || destination == null) {
      throw const NotFoundFailure('transfer_account_not_found');
    }
    if (!source.isActive || !destination.isActive) {
      throw const ValidationFailure('transfer_account_inactive');
    }
    if (source.currency != draft.sourceAmount.currency ||
        destination.currency != draft.destinationAmount.currency) {
      throw const ValidationFailure('transfer_currency_mismatch');
    }
    final instant = now().toUtc();
    final transferId = ids.next();
    final transfer = Transfer(
      id: transferId,
      sourceAccountId: source.id,
      destinationAccountId: destination.id,
      sourceAmount: draft.sourceAmount,
      destinationAmount: draft.destinationAmount,
      exchangeRate: draft.exchangeRate,
      occurredAt: draft.occurredAt.toUtc(),
      note: draft.note,
      createdAt: instant,
      updatedAt: instant,
    );
    final outgoing = Movement(
      id: ids.next(),
      accountId: source.id,
      transferId: transferId,
      type: MovementType.transferOut,
      amount: draft.sourceAmount,
      occurredAt: transfer.occurredAt,
      note: draft.note,
      createdAt: instant,
      updatedAt: instant,
    );
    final incoming = Movement(
      id: ids.next(),
      accountId: destination.id,
      transferId: transferId,
      type: MovementType.transferIn,
      amount: draft.destinationAmount,
      occurredAt: transfer.occurredAt,
      note: draft.note,
      createdAt: instant,
      updatedAt: instant,
    );
    await repository.create(
      transfer: transfer,
      outgoing: outgoing,
      incoming: incoming,
    );
    return transfer;
  }
}

class ReplaceTransfer {
  const ReplaceTransfer({
    required this.repository,
    required this.accounts,
    required this.ids,
    required this.now,
  });

  final TransferRepository repository;
  final AccountRepository accounts;
  final IdGenerator ids;
  final DateTime Function() now;

  Future<Transfer> call({
    required Transfer original,
    required TransferDraft replacement,
  }) async {
    final source = await accounts.findById(replacement.sourceAccountId);
    final destination =
        await accounts.findById(replacement.destinationAccountId);
    if (source == null || destination == null) {
      throw const NotFoundFailure('transfer_account_not_found');
    }
    if (!source.isActive || !destination.isActive) {
      throw const ValidationFailure('transfer_account_inactive');
    }
    if (source.currency != replacement.sourceAmount.currency ||
        destination.currency != replacement.destinationAmount.currency) {
      throw const ValidationFailure('transfer_currency_mismatch');
    }
    final instant = now().toUtc();
    final transfer = original.copyWith(
      sourceAccountId: source.id,
      destinationAccountId: destination.id,
      sourceAmount: replacement.sourceAmount,
      destinationAmount: replacement.destinationAmount,
      exchangeRate: replacement.exchangeRate,
      occurredAt: replacement.occurredAt.toUtc(),
      note: replacement.note,
      clearNote: replacement.note == null,
      updatedAt: instant,
    );
    final outgoing = Movement(
      id: ids.next(),
      accountId: source.id,
      transferId: transfer.id,
      type: MovementType.transferOut,
      amount: replacement.sourceAmount,
      occurredAt: transfer.occurredAt,
      note: replacement.note,
      createdAt: instant,
      updatedAt: instant,
    );
    final incoming = Movement(
      id: ids.next(),
      accountId: destination.id,
      transferId: transfer.id,
      type: MovementType.transferIn,
      amount: replacement.destinationAmount,
      occurredAt: transfer.occurredAt,
      note: replacement.note,
      createdAt: instant,
      updatedAt: instant,
    );
    await repository.replace(
      transfer: transfer,
      outgoing: outgoing,
      incoming: incoming,
    );
    return transfer;
  }
}

class DeleteTransfer {
  const DeleteTransfer(this.repository);
  final TransferRepository repository;

  Future<void> call(String id) => repository.delete(id);
}
