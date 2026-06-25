import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/features/converter/domain/entities/conversion.dart';
import 'package:boveda_personal/features/converter/domain/repositories/calculator_currency_repository.dart';
import 'package:decimal/decimal.dart';

class ConvertCurrency {
  const ConvertCurrency(
    this.repository, {
    required this.now,
  });

  final CalculatorCurrencyRepository repository;
  final DateTime Function() now;

  Future<ConversionQuote> call(ConversionRequest request) async {
    final source = request.amount.currency;
    final target = request.targetCurrency;
    if (source == target) {
      return ConversionQuote(
        request: request,
        convertedAmount: request.amount,
        rate: Decimal.fromInt(1),
        quotedAt: now().toUtc(),
        path: [source.code],
      );
    }

    final sourceRate = source.code == 'USD'
        ? Decimal.fromInt(1)
        : (await repository.findActiveByCode(source.code))?.unitsPerUsd;
    final targetRate = target.code == 'USD'
        ? Decimal.fromInt(1)
        : (await repository.findActiveByCode(target.code))?.unitsPerUsd;
    if (sourceRate == null || targetRate == null) {
      throw const NotFoundFailure('calculator_currency_not_found');
    }

    final convertedMinor = _convertMinor(
      request.amount.minorUnits,
      sourceScale: source.scale,
      targetScale: target.scale,
      sourceUnitsPerUsd: sourceRate,
      targetUnitsPerUsd: targetRate,
    );
    final path = source.code == 'USD' || target.code == 'USD'
        ? [source.code, target.code]
        : [source.code, 'USD', target.code];
    return ConversionQuote(
      request: request,
      convertedAmount: Money(
        minorUnits: convertedMinor,
        currency: target,
      ),
      rate: _effectiveRate(sourceRate, targetRate),
      quotedAt: now().toUtc(),
      path: path,
    );
  }
}

int _convertMinor(
  int sourceMinor, {
  required int sourceScale,
  required int targetScale,
  required Decimal sourceUnitsPerUsd,
  required Decimal targetUnitsPerUsd,
}) {
  final sourceRate = _fraction(sourceUnitsPerUsd);
  final targetRate = _fraction(targetUnitsPerUsd);
  final numerator = BigInt.from(sourceMinor) *
      _pow10(targetScale) *
      sourceRate.denominator *
      targetRate.numerator;
  final denominator = _pow10(sourceScale) *
      sourceRate.numerator *
      targetRate.denominator;
  return _roundHalfAwayFromZero(numerator, denominator).toInt();
}

Decimal _effectiveRate(Decimal source, Decimal target) {
  final sourceFraction = _fraction(source);
  final targetFraction = _fraction(target);
  final numerator = targetFraction.numerator * sourceFraction.denominator;
  final denominator = targetFraction.denominator * sourceFraction.numerator;
  final scaled = _roundHalfAwayFromZero(
    numerator * _pow10(12),
    denominator,
  );
  return Decimal.parse(_scaledString(scaled, 12));
}

({BigInt numerator, BigInt denominator}) _fraction(Decimal value) {
  final text = value.toString().toLowerCase();
  final exponentParts = text.split('e');
  final mantissa = exponentParts.first;
  final exponent =
      exponentParts.length == 2 ? int.parse(exponentParts.last) : 0;
  final parts = mantissa.split('.');
  final decimalCount = parts.length == 2 ? parts[1].length : 0;
  final effectiveScale = decimalCount - exponent;
  final digits = BigInt.parse(parts.join());
  if (effectiveScale <= 0) {
    return (
      numerator: digits * _pow10(-effectiveScale),
      denominator: BigInt.one,
    );
  }
  return (
    numerator: digits,
    denominator: _pow10(effectiveScale),
  );
}

BigInt _roundHalfAwayFromZero(BigInt numerator, BigInt denominator) {
  final negative = numerator.isNegative != denominator.isNegative;
  final absoluteNumerator = numerator.abs();
  final absoluteDenominator = denominator.abs();
  final quotient = absoluteNumerator ~/ absoluteDenominator;
  final remainder = absoluteNumerator % absoluteDenominator;
  final rounded = remainder * BigInt.from(2) >= absoluteDenominator
      ? quotient + BigInt.one
      : quotient;
  return negative ? -rounded : rounded;
}

BigInt _pow10(int exponent) => BigInt.from(10).pow(exponent);

String _scaledString(BigInt value, int scale) {
  final negative = value.isNegative;
  final digits = value.abs().toString().padLeft(scale + 1, '0');
  final split = digits.length - scale;
  final text = '${digits.substring(0, split)}.${digits.substring(split)}'
      .replaceFirst(RegExp(r'\.?0+$'), '');
  return negative ? '-$text' : text;
}
