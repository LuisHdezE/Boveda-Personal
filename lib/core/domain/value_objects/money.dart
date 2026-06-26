import 'package:boveda_personal/core/domain/value_objects/currency.dart';

class Money implements Comparable<Money> {
  Money({required this.minorUnits, required this.currency});

  final int minorUnits;
  final Currency currency;

  factory Money.zero(Currency currency) {
    return Money(minorUnits: 0, currency: currency);
  }

  factory Money.parseMajor(String value, {required Currency currency}) {
    final match = RegExp(
      r'^([+-]?)(\d+)(?:\.(\d+))?$',
    ).firstMatch(value.trim());
    if (match == null) {
      throw const FormatException('Invalid monetary amount');
    }
    final decimals = match.group(3) ?? '';
    if (decimals.length > currency.scale) {
      throw const FormatException('Too many decimal places');
    }
    final sign = match.group(1) == '-' ? -1 : 1;
    final whole = int.parse(match.group(2)!);
    final fraction = decimals.padRight(currency.scale, '0');
    final factor = _powerOfTen(currency.scale);
    final minor = whole * factor + (fraction.isEmpty ? 0 : int.parse(fraction));
    return Money(minorUnits: sign * minor, currency: currency);
  }

  String get majorUnits {
    final factor = _powerOfTen(currency.scale);
    final absolute = minorUnits.abs();
    final whole = absolute ~/ factor;
    if (currency.scale == 0) {
      return '${minorUnits < 0 ? '-' : ''}$whole';
    }
    final fraction = (absolute % factor).toString().padLeft(
      currency.scale,
      '0',
    );
    return '${minorUnits < 0 ? '-' : ''}$whole.$fraction';
  }

  bool get isZero => minorUnits == 0;
  bool get isPositive => minorUnits > 0;
  bool get isNegative => minorUnits < 0;

  Money operator +(Money other) {
    _requireSameCurrency(other);
    return Money(minorUnits: minorUnits + other.minorUnits, currency: currency);
  }

  Money operator -(Money other) {
    _requireSameCurrency(other);
    return Money(minorUnits: minorUnits - other.minorUnits, currency: currency);
  }

  Money operator -() => Money(minorUnits: -minorUnits, currency: currency);

  Money abs() => Money(minorUnits: minorUnits.abs(), currency: currency);

  @override
  int compareTo(Money other) {
    _requireSameCurrency(other);
    return minorUnits.compareTo(other.minorUnits);
  }

  void _requireSameCurrency(Money other) {
    if (other.currency != currency) {
      throw ArgumentError('Money currencies must match');
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Money &&
        other.minorUnits == minorUnits &&
        other.currency == currency;
  }

  @override
  int get hashCode => Object.hash(minorUnits, currency);

  @override
  String toString() => 'Money($majorUnits ${currency.code})';
}

int _powerOfTen(int exponent) {
  var result = 1;
  for (var index = 0; index < exponent; index++) {
    result *= 10;
  }
  return result;
}
