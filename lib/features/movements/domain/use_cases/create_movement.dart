import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/core/ports/id_generator.dart';
import 'package:boveda_personal/features/accounts/domain/repositories/account_repository.dart';
import 'package:boveda_personal/features/categories/domain/repositories/category_repository.dart';
import 'package:boveda_personal/features/movements/domain/commands/movement_commands.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/repositories/movement_repository.dart';

class CreateMovement {
  const CreateMovement({
    required this.movements,
    required this.accounts,
    required this.categories,
    required this.ids,
    required this.now,
  });

  final MovementRepository movements;
  final AccountRepository accounts;
  final CategoryRepository categories;
  final IdGenerator ids;
  final DateTime Function() now;

  Future<Movement> call(MovementDraft draft) async {
    final account = await accounts.findById(draft.accountId);
    if (account == null) {
      throw const NotFoundFailure('account_not_found');
    }
    if (!account.isActive) {
      throw const ValidationFailure('account_inactive');
    }
    if (account.currency != draft.amount.currency) {
      throw const ValidationFailure('movement_currency_mismatch');
    }
    final category = await categories.findById(draft.categoryId);
    if (category == null) {
      throw const NotFoundFailure('category_not_found');
    }
    if (!category.isActive || !category.supports(draft.type.name)) {
      throw const ValidationFailure('category_incompatible');
    }
    final instant = now().toUtc();
    final movement = Movement(
      id: ids.next(),
      accountId: draft.accountId,
      categoryId: draft.categoryId,
      type: draft.type,
      amount: draft.amount,
      occurredAt: draft.occurredAt.toUtc(),
      note: draft.note,
      createdAt: instant,
      updatedAt: instant,
    );
    await movements.create(movement);
    return movement;
  }
}
