import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/converter/domain/entities/calculator_currency.dart';
import 'package:boveda_personal/features/converter/domain/entities/conversion.dart';
import 'package:boveda_personal/features/converter/domain/repositories/calculator_currency_repository.dart';
import 'package:boveda_personal/features/converter/domain/use_cases/convert_currency.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 6, 25);
  final usd = Currency(code: 'USD', scale: 2);
  final uyu = Currency(code: 'UYU', scale: 2);
  final eur = Currency(code: 'EUR', scale: 2);

  test('CAL-007 convierte USD a moneda usando unitsPerUsd', () async {
    final useCase = ConvertCurrency(
      _CurrencyRepository([_currency(uyu, Decimal.fromInt(40), now)]),
      now: () => now,
    );

    final quote = await useCase(
      ConversionRequest(
        amount: Money(minorUnits: 100, currency: usd),
        targetCurrency: uyu,
      ),
    );

    expect(quote.convertedAmount.minorUnits, 4000);
    expect(quote.path, ['USD', 'UYU']);
  });

  test('CAL-009 convierte entre monedas usando USD como puente', () async {
    final useCase = ConvertCurrency(
      _CurrencyRepository([
        _currency(uyu, Decimal.fromInt(40), now),
        _currency(eur, Decimal.parse('0.8'), now),
      ]),
      now: () => now,
    );

    final quote = await useCase(
      ConversionRequest(
        amount: Money(minorUnits: 4000, currency: uyu),
        targetCurrency: eur,
      ),
    );

    expect(quote.convertedAmount.minorUnits, 80);
    expect(quote.path, ['UYU', 'USD', 'EUR']);
  });
}

CalculatorCurrency _currency(Currency currency, Decimal rate, DateTime now) {
  return CalculatorCurrency(
    id: currency.code,
    name: currency.code,
    currency: currency,
    symbol: currency.code,
    unitsPerUsd: rate,
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );
}

class _CurrencyRepository implements CalculatorCurrencyRepository {
  _CurrencyRepository(this.items);

  final List<CalculatorCurrency> items;

  @override
  Future<CalculatorCurrency?> findActiveByCode(String code) async {
    return items.cast<CalculatorCurrency?>().firstWhere(
      (item) => item?.currency.code == code.toUpperCase(),
      orElse: () => null,
    );
  }

  @override
  Future<List<CalculatorCurrency>> list({bool activeOnly = false}) async {
    return activeOnly ? items.where((item) => item.isActive).toList() : items;
  }

  @override
  Future<void> save(CalculatorCurrency currency) async {}

  @override
  Future<void> setActive(String id, {required bool active}) async {}
}
