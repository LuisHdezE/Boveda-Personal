import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/simulator/domain/entities/simulation_history.dart';

class SimulationHistoryModel {
  const SimulationHistoryModel(this.entity);

  final SimulationHistory entity;

  factory SimulationHistoryModel.fromEntity(SimulationHistory entity) {
    return SimulationHistoryModel(entity);
  }

  factory SimulationHistoryModel.fromRow(Map<String, Object?> row) {
    final currency = Currency(
      code: row.requiredString('currency_code'),
      scale: row.requiredInt('currency_scale'),
    );
    return SimulationHistoryModel(
      SimulationHistory(
        id: row.requiredString('id'),
        currency: currency,
        initialBalance: Money(
          minorUnits: row.requiredInt('initial_balance_minor'),
          currency: currency,
        ),
        monthlyIncome: Money(
          minorUnits: row.requiredInt('monthly_income_minor'),
          currency: currency,
        ),
        monthlyExpense: Money(
          minorUnits: row.requiredInt('monthly_expense_minor'),
          currency: currency,
        ),
        durationMonths: row.requiredInt('duration_months'),
        projectedBalance: Money(
          minorUnits: row.requiredInt('projected_balance_minor'),
          currency: currency,
        ),
        createdAt: row.requiredDate('created_at'),
      ),
    );
  }

  SimulationHistory toEntity() => entity;

  Map<String, Object?> toRow() => {
    'id': entity.id,
    'currency_code': entity.currency.code,
    'currency_scale': entity.currency.scale,
    'initial_balance_minor': entity.initialBalance.minorUnits,
    'monthly_income_minor': entity.monthlyIncome.minorUnits,
    'monthly_expense_minor': entity.monthlyExpense.minorUnits,
    'duration_months': entity.durationMonths,
    'projected_balance_minor': entity.projectedBalance.minorUnits,
    'created_at': RowConverters.dateToSql(entity.createdAt),
  };
}
