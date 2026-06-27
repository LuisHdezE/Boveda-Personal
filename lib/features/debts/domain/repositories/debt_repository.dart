import 'package:boveda_personal/features/debts/domain/entities/debt.dart';

abstract class DebtRepository {
  Future<void> save(Debt debt, String userId);
  Future<void> delete(String id, String userId);
  Future<List<Debt>> getAll(String userId);
}
