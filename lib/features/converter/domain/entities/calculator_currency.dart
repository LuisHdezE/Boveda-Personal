import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:decimal/decimal.dart';

class CalculatorCurrency {
  const CalculatorCurrency({
    required this.id,
    required this.name,
    required this.currency,
    required this.symbol,
    required this.unitsPerUsd,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final Currency currency;
  final String symbol;
  final Decimal unitsPerUsd;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CalculatorCurrency copyWith({
    String? name,
    String? symbol,
    Decimal? unitsPerUsd,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return CalculatorCurrency(
      id: id,
      name: name ?? this.name,
      currency: currency,
      symbol: symbol ?? this.symbol,
      unitsPerUsd: unitsPerUsd ?? this.unitsPerUsd,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CalculatorCurrency &&
        other.id == id &&
        other.name == name &&
        other.currency == currency &&
        other.symbol == symbol &&
        other.unitsPerUsd == unitsPerUsd &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    currency,
    symbol,
    unitsPerUsd,
    isActive,
    createdAt,
    updatedAt,
  );
}
