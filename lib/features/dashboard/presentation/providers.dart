import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account_balance.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lista cuentas activas con sus saldos actuales.
final accountBalancesProvider = FutureProvider<List<AccountBalance>>((ref) async {
  return ref.watch(accountRepositoryProvider).balances();
});

/// Últimos 5 movimientos (sin filtro, página 1).
final recentMovementsProvider = FutureProvider<List<Movement>>((ref) async {
  return ref.watch(movementRepositoryProvider).list(
    MovementFilter(),
    PageRequest(limit: 5, offset: 0),
  );
});

class DashboardSummary {
  const DashboardSummary({
    required this.income,
    required this.expense,
  });
  final int income; // minorUnits
  final int expense; // minorUnits
}

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 1);
  
  final movements = await ref.watch(movementRepositoryProvider).list(
    MovementFilter(
      period: DateRange(start: startOfMonth, endExclusive: endOfMonth),
    ),
    PageRequest(limit: 1000, offset: 0),
  );
  
  int income = 0;
  int expense = 0;
  for (final movement in movements) {
    if (movement.type == MovementType.income) {
      income += movement.amount.minorUnits;
    } else {
      expense += movement.amount.minorUnits;
    }
  }
  
  return DashboardSummary(income: income, expense: expense);
});
