import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/converter/domain/entities/conversion.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final usd = Currency(code: 'USD', scale: 2);
  final uyu = Currency(code: 'UYU', scale: 2);

  test('CAL-010 conversión conserva solicitud, resultado y tasa', () {
    final request = ConversionRequest(
      amount: Money(minorUnits: 100, currency: usd),
      targetCurrency: uyu,
    );
    final quote = ConversionQuote(
      request: request,
      convertedAmount: Money(minorUnits: 4000, currency: uyu),
      rate: Decimal.parse('40'),
      quotedAt: DateTime.utc(2026, 6, 25),
      path: const ['USD', 'UYU'],
    );

    expect(quote.sourceAmount.currency, usd);
    expect(quote.convertedAmount.currency, uyu);
    expect(quote.path, ['USD', 'UYU']);
  });

  test('MODEL-008 rechaza resultado en moneda incorrecta', () {
    final request = ConversionRequest(
      amount: Money(minorUnits: 100, currency: usd),
      targetCurrency: uyu,
    );

    expect(
      () => ConversionQuote(
        request: request,
        convertedAmount: Money(minorUnits: 100, currency: usd),
        rate: Decimal.fromInt(1),
        quotedAt: DateTime.utc(2026),
        path: const ['USD'],
      ),
      throwsArgumentError,
    );
  });
}
