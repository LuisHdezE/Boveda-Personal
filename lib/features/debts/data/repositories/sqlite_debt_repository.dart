import 'package:boveda_personal/core/database/dao/debt_dao.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/debts/data/models/debt_model.dart';
import 'package:boveda_personal/features/debts/domain/entities/debt.dart';
import 'package:boveda_personal/features/debts/domain/repositories/debt_repository.dart';

class SqliteDebtRepository implements DebtRepository {
  const SqliteDebtRepository(this._dao);

  final DebtDao _dao;

  @override
  Future<void> save(Debt debt, String userId) async {
    final model = DebtModel(
      id: debt.id,
      userId: userId,
      name: debt.name,
      amountMinor: debt.amount.minorUnits,
      currencyCode: debt.amount.currency.code,
      dueDate: debt.dueDate,
      isActive: debt.isActive,
      createdAt: debt.createdAt,
      updatedAt: debt.updatedAt,
    );

    await _dao.insert(model);
  }

  @override
  Future<void> delete(String id, String userId) async {
    await _dao.delete(id, userId);
  }

  @override
  Future<List<Debt>> getAll(String userId) async {
    final models = await _dao.getAll(userId);
    return models.map((m) {
      return Debt(
        id: m.id,
        name: m.name,
        amount: Money(minorUnits: m.amountMinor, currency: Currency(code: m.currencyCode, scale: 2)), // Use minorUnits named param
        dueDate: m.dueDate,
        isActive: m.isActive,
        createdAt: m.createdAt,
        updatedAt: m.updatedAt,
      );
    }).toList();
  }
}
