import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';

class ConversionRequest {
  ConversionRequest({required this.amount, required this.targetCurrency}) {
    if (amount.minorUnits < 0) {
      throw ArgumentError.value(amount, 'amount');
    }
  }

  final Money amount;
  final Currency targetCurrency;

  @override
  bool operator ==(Object other) {
    return other is ConversionRequest &&
        other.amount == amount &&
        other.targetCurrency == targetCurrency;
  }

  @override
  int get hashCode => Object.hash(amount, targetCurrency);
}

class ConversionQuote {
  ConversionQuote({
    required this.request,
    required this.convertedAmount,
    required this.rate,
    required this.quotedAt,
    required List<String> path,
  }) : path = List.unmodifiable(path.map((code) => code.toUpperCase())) {
    if (convertedAmount.currency != request.targetCurrency) {
      throw ArgumentError('Converted amount must use target currency');
    }
    if (rate <= Decimal.zero) {
      throw ArgumentError.value(rate, 'rate');
    }
    if (this.path.isEmpty ||
        this.path.first != request.amount.currency.code ||
        this.path.last != request.targetCurrency.code) {
      throw ArgumentError('Conversion path must connect source and target');
    }
  }

  final ConversionRequest request;
  final Money convertedAmount;
  final Decimal rate;
  final DateTime quotedAt;
  final List<String> path;

  Money get sourceAmount => request.amount;

  @override
  bool operator ==(Object other) {
    return other is ConversionQuote &&
        other.request == request &&
        other.convertedAmount == convertedAmount &&
        other.rate == rate &&
        other.quotedAt == quotedAt &&
        const ListEquality<String>().equals(other.path, path);
  }

  @override
  int get hashCode => Object.hash(
    request,
    convertedAmount,
    rate,
    quotedAt,
    const ListEquality<String>().hash(path),
  );
}
