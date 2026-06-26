import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/ports/id_generator.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account_balance.dart';
import 'package:boveda_personal/features/accounts/domain/repositories/account_repository.dart';
import 'package:boveda_personal/features/categories/domain/entities/category.dart';
import 'package:boveda_personal/features/categories/domain/repositories/category_repository.dart';
import 'package:boveda_personal/features/movements/domain/commands/movement_commands.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/movements/domain/repositories/movement_repository.dart';
import 'package:boveda_personal/features/movements/domain/use_cases/create_movement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 6, 25);
  final usd = Currency(code: 'USD', scale: 2);

  test('MOV-001 crea y persiste un ingreso válido', () async {
    final movements = _MovementRepository();
    final useCase = CreateMovement(
      movements: movements,
      accounts: _AccountRepository(
        Account(
          id: 'usd',
          userId: 'user',
          currency: usd,
          name: 'USD',
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
      ),
      categories: _CategoryRepository(
        Category(
          id: 'salary',
          name: 'Salario',
          icon: 'work',
          colorValue: 1,
          movementType: CategoryMovementType.income,
          isSystem: true,
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
      ),
      ids: const _Ids(),
      now: () => now,
    );

    final movement = await useCase(
      MovementDraft(
        accountId: 'usd',
        categoryId: 'salary',
        type: MovementType.income,
        amount: Money(minorUnits: 1000, currency: usd),
        occurredAt: now,
      ),
    );

    expect(movement.id, 'generated-id');
    expect(movements.saved, movement);
  });
}

class _MovementRepository implements MovementRepository {
  Movement? saved;

  @override
  Future<void> create(Movement movement) async => saved = movement;

  @override
  Future<void> delete(String id) async {}

  @override
  Future<Movement?> findById(String id) async => null;

  @override
  Future<List<Movement>> list(MovementFilter filter, PageRequest page) async =>
      [];

  @override
  Future<void> update(Movement movement) async {}
}

class _AccountRepository implements AccountRepository {
  _AccountRepository(this.account);
  final Account account;

  @override
  Future<Account?> findById(String id) async =>
      id == account.id ? account : null;

  @override
  Future<List<AccountBalance>> balances() async => [];

  @override
  Future<List<Account>> list({bool activeOnly = false}) async => [account];

  @override
  Future<void> save(Account account) async {}

  @override
  Future<void> setActive(String id, {required bool active}) async {}
}

class _CategoryRepository implements CategoryRepository {
  _CategoryRepository(this.category);
  final Category category;

  @override
  Future<Category?> findById(String id) async =>
      id == category.id ? category : null;

  @override
  Future<List<Category>> list({
    CategoryMovementType? movementType,
    bool activeOnly = true,
  }) async => [category];

  @override
  Future<void> save(Category category) async {}

  @override
  Future<void> setActive(String id, {required bool active}) async {}
}

class _Ids implements IdGenerator {
  const _Ids();
  @override
  String next() => 'generated-id';
}
