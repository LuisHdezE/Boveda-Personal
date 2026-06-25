import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';

class CategoryBreakdown {
  CategoryBreakdown({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.percentage,
  }) {
    if (amount.minorUnits < 0) {
      throw ArgumentError.value(amount, 'amount');
    }
    if (percentage < Decimal.zero || percentage > Decimal.fromInt(100)) {
      throw ArgumentError.value(percentage, 'percentage');
    }
  }

  final String categoryId;
  final String categoryName;
  final Money amount;
  final Decimal percentage;

  @override
  bool operator ==(Object other) {
    return other is CategoryBreakdown &&
        other.categoryId == categoryId &&
        other.categoryName == categoryName &&
        other.amount == amount &&
        other.percentage == percentage;
  }

  @override
  int get hashCode =>
      Object.hash(categoryId, categoryName, amount, percentage);
}

class CashFlowPoint {
  CashFlowPoint({
    required this.period,
    required this.income,
    required this.expense,
  }) {
    if (income.currency != expense.currency) {
      throw ArgumentError('Cash flow amounts must share a currency');
    }
  }

  final DateRange period;
  final Money income;
  final Money expense;

  Money get savings => income - expense;

  @override
  bool operator ==(Object other) {
    return other is CashFlowPoint &&
        other.period == period &&
        other.income == income &&
        other.expense == expense;
  }

  @override
  int get hashCode => Object.hash(period, income, expense);
}

class NetWorthPoint {
  const NetWorthPoint({
    required this.at,
    required this.value,
  });

  final DateTime at;
  final Money value;

  @override
  bool operator ==(Object other) {
    return other is NetWorthPoint &&
        other.at == at &&
        other.value == value;
  }

  @override
  int get hashCode => Object.hash(at, value);
}

class FinancialReport {
  FinancialReport({
    required this.period,
    required this.currency,
    required this.income,
    required this.expense,
    required this.savingsRate,
    required List<CategoryBreakdown> categoryBreakdown,
    required List<CashFlowPoint> cashFlow,
    required List<NetWorthPoint> netWorth,
  })  : categoryBreakdown = List.unmodifiable(categoryBreakdown),
        cashFlow = List.unmodifiable(cashFlow),
        netWorth = List.unmodifiable(netWorth) {
    if (income.currency != currency || expense.currency != currency) {
      throw ArgumentError('Report totals must use report currency');
    }
    if (savingsRate > Decimal.fromInt(100)) {
      throw ArgumentError.value(savingsRate, 'savingsRate');
    }
    if (this.categoryBreakdown.any(
          (item) => item.amount.currency != currency,
        ) ||
        this.cashFlow.any(
          (item) =>
              item.income.currency != currency ||
              item.expense.currency != currency,
        ) ||
        this.netWorth.any((item) => item.value.currency != currency)) {
      throw ArgumentError('Report series must use report currency');
    }
    if (!_dateRangesOrdered(this.cashFlow.map((point) => point.period)) ||
        !_datesOrdered(this.netWorth.map((point) => point.at))) {
      throw ArgumentError('Report series must be chronological');
    }
  }

  final DateRange period;
  final Currency currency;
  final Money income;
  final Money expense;
  final Decimal savingsRate;
  final List<CategoryBreakdown> categoryBreakdown;
  final List<CashFlowPoint> cashFlow;
  final List<NetWorthPoint> netWorth;

  Money get savings => income - expense;

  @override
  bool operator ==(Object other) {
    return other is FinancialReport &&
        other.period == period &&
        other.currency == currency &&
        other.income == income &&
        other.expense == expense &&
        other.savingsRate == savingsRate &&
        const ListEquality<CategoryBreakdown>().equals(
          other.categoryBreakdown,
          categoryBreakdown,
        ) &&
        const ListEquality<CashFlowPoint>().equals(other.cashFlow, cashFlow) &&
        const ListEquality<NetWorthPoint>().equals(other.netWorth, netWorth);
  }

  @override
  int get hashCode => Object.hash(
        period,
        currency,
        income,
        expense,
        savingsRate,
        const ListEquality<CategoryBreakdown>().hash(categoryBreakdown),
        const ListEquality<CashFlowPoint>().hash(cashFlow),
        const ListEquality<NetWorthPoint>().hash(netWorth),
      );
}

bool _dateRangesOrdered(Iterable<DateRange> ranges) {
  DateTime? previous;
  for (final range in ranges) {
    if (previous != null && range.start.isBefore(previous)) {
      return false;
    }
    previous = range.start;
  }
  return true;
}

bool _datesOrdered(Iterable<DateTime> dates) {
  DateTime? previous;
  for (final date in dates) {
    if (previous != null && date.isBefore(previous)) {
      return false;
    }
    previous = date;
  }
  return true;
}
