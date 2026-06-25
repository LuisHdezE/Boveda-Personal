import 'package:decimal/decimal.dart';

class ExchangeRate {
  const ExchangeRate({
    required this.id,
    required String baseCurrencyCode,
    required String quoteCurrencyCode,
    required this.rate,
    required this.effectiveAt,
    required this.createdAt,
  })  : _baseCurrencyCode = baseCurrencyCode,
        _quoteCurrencyCode = quoteCurrencyCode;

  final String id;
  final String _baseCurrencyCode;
  final String _quoteCurrencyCode;
  final Decimal rate;
  final DateTime effectiveAt;
  final DateTime createdAt;

  String get baseCurrencyCode => _baseCurrencyCode.toUpperCase();
  String get quoteCurrencyCode => _quoteCurrencyCode.toUpperCase();

  ExchangeRate copyWith({
    Decimal? rate,
    DateTime? effectiveAt,
  }) {
    return ExchangeRate(
      id: id,
      baseCurrencyCode: baseCurrencyCode,
      quoteCurrencyCode: quoteCurrencyCode,
      rate: rate ?? this.rate,
      effectiveAt: effectiveAt ?? this.effectiveAt,
      createdAt: createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExchangeRate &&
        other.id == id &&
        other.baseCurrencyCode == baseCurrencyCode &&
        other.quoteCurrencyCode == quoteCurrencyCode &&
        other.rate == rate &&
        other.effectiveAt == effectiveAt &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        baseCurrencyCode,
        quoteCurrencyCode,
        rate,
        effectiveAt,
        createdAt,
      );
}
