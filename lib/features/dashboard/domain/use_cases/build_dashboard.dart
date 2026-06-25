import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/ports/money_converter.dart';
import 'package:boveda_personal/features/accounts/domain/repositories/account_repository.dart';
import 'package:boveda_personal/features/dashboard/domain/entities/dashboard_snapshot.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:boveda_personal/features/movements/domain/repositories/movement_repository.dart';

class BuildDashboard {
  const BuildDashboard({
    required this.accounts,
    required this.movements,
    required this.converter,
    required this.now,
  });

  final AccountRepository accounts;
  final MovementRepository movements;
  final MoneyConverter converter;
  final DateTime Function() now;

  Future<DashboardSnapshot> call({
    required Currency primaryCurrency,
    int recentLimit = 5,
  }) async {
    if (recentLimit <= 0) {
      throw ArgumentError.value(recentLimit, 'recentLimit');
    }
    final instant = now().toUtc();
    final balances = await accounts.balances();
    var total = Money.zero(primaryCurrency);
    for (final balance in balances) {
      total = total +
          await converter.convert(
            balance.balance,
            target: primaryCurrency,
            at: instant,
          );
    }
    final month = DateRange.forPeriod(instant, PeriodUnit.month);
    final monthly = await movements.list(
      MovementFilter(
        period: month,
        types: const {MovementType.income, MovementType.expense},
      ),
      PageRequest(limit: 1000000),
    );
    var income = Money.zero(primaryCurrency);
    var expense = Money.zero(primaryCurrency);
    for (final movement in monthly) {
      final converted = await converter.convert(
        movement.amount,
        target: primaryCurrency,
        at: movement.occurredAt,
      );
      if (movement.type == MovementType.income) {
        income = income + converted;
      } else if (movement.type == MovementType.expense) {
        expense = expense + converted;
      }
    }
    final recent = await movements.list(
      MovementFilter(),
      PageRequest(limit: recentLimit),
    );
    return DashboardSnapshot(
      balances: balances,
      totalInPrimaryCurrency: total,
      monthlyIncome: income,
      monthlyExpense: expense,
      recentMovementIds: recent.map((movement) => movement.id).toList(),
      wealthEvolution: [
        WealthPoint(at: instant, value: total),
      ],
      calculatedAt: instant,
    );
  }
}
