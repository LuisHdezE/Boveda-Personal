import 'package:decimal/decimal.dart';

class ExchangeRateUpdate {
  ExchangeRateUpdate({
    required String baseCurrencyCode,
    required String quoteCurrencyCode,
    required this.rate,
    required this.effectiveAt,
  }) : baseCurrencyCode = baseCurrencyCode.trim().toUpperCase(),
       quoteCurrencyCode = quoteCurrencyCode.trim().toUpperCase() {
    if (this.baseCurrencyCode == this.quoteCurrencyCode) {
      throw ArgumentError('Currency pair must contain different currencies');
    }
    if (rate <= Decimal.zero) {
      throw ArgumentError.value(rate, 'rate');
    }
  }

  final String baseCurrencyCode;
  final String quoteCurrencyCode;
  final Decimal rate;
  final DateTime effectiveAt;

  @override
  bool operator ==(Object other) {
    return other is ExchangeRateUpdate &&
        other.baseCurrencyCode == baseCurrencyCode &&
        other.quoteCurrencyCode == quoteCurrencyCode &&
        other.rate == rate &&
        other.effectiveAt == effectiveAt;
  }

  @override
  int get hashCode =>
      Object.hash(baseCurrencyCode, quoteCurrencyCode, rate, effectiveAt);
}
