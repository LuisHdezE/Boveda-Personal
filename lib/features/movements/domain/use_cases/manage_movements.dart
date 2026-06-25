import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/features/accounts/domain/repositories/account_repository.dart';
import 'package:boveda_personal/features/categories/domain/repositories/category_repository.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/movements/domain/repositories/movement_repository.dart';

class GetMovement {
  const GetMovement(this.repository);
  final MovementRepository repository;

  Future<Movement> call(String id) async {
    final movement = await repository.findById(id);
    if (movement == null) {
      throw const NotFoundFailure('movement_not_found');
    }
    return movement;
  }
}

class ListMovements {
  const ListMovements(this.repository);
  final MovementRepository repository;

  Future<List<Movement>> call({
    MovementFilter? filter,
    PageRequest? page,
  }) {
    return repository.list(
      filter ?? MovementFilter(),
      page ?? PageRequest(),
    );
  }
}

class UpdateMovement {
  const UpdateMovement({
    required this.repository,
    required this.accounts,
    required this.categories,
  });

  final MovementRepository repository;
  final AccountRepository accounts;
  final CategoryRepository categories;

  Future<Movement> call(Movement movement) async {
    if (movement.isTransfer) {
      throw const ValidationFailure('transfer_movement_is_immutable');
    }
    if (movement.amount.minorUnits <= 0) {
      throw const ValidationFailure('movement_amount_must_be_positive');
    }
    final account = await accounts.findById(movement.accountId);
    if (account == null) {
      throw const NotFoundFailure('account_not_found');
    }
    if (!account.isActive || account.currency != movement.amount.currency) {
      throw const ValidationFailure('movement_account_invalid');
    }
    if (movement.type == MovementType.income ||
        movement.type == MovementType.expense) {
      final categoryId = movement.categoryId;
      final category =
          categoryId == null ? null : await categories.findById(categoryId);
      if (category == null ||
          !category.isActive ||
          !category.supports(movement.type.name)) {
        throw const ValidationFailure('category_incompatible');
      }
    }
    await repository.update(movement);
    return movement;
  }
}

class DeleteMovement {
  const DeleteMovement(this.repository);
  final MovementRepository repository;

  Future<void> call(Movement movement) {
    if (movement.isTransfer) {
      throw const ValidationFailure('transfer_movement_is_immutable');
    }
    return repository.delete(movement.id);
  }
}
