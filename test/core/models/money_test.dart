import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final usd = Currency(code: 'USD', scale: 2);
  final uyu = Currency(code: 'UYU', scale: 2);

  test('MONEY-001 crea un importe desde unidades menores', () {
    final money = Money(minorUnits: 12345, currency: usd);

    expect(money.minorUnits, 12345);
    expect(money.majorUnits, '123.45');
  });

  test('MONEY-004 suma importes de la misma moneda', () {
    expect(
      Money(minorUnits: 100, currency: usd) +
          Money(minorUnits: 250, currency: usd),
      Money(minorUnits: 350, currency: usd),
    );
  });

  test('MONEY-006 rechaza operaciones entre monedas diferentes', () {
    expect(
      () =>
          Money(minorUnits: 100, currency: usd) +
          Money(minorUnits: 100, currency: uyu),
      throwsArgumentError,
    );
  });

  test('MONEY-014 restaura un importe decimal sin pérdida', () {
    expect(
      Money.parseMajor('123.45', currency: usd),
      Money(minorUnits: 12345, currency: usd),
    );
  });

  test('MONEY-021 rechaza más decimales que la escala', () {
    expect(
      () => Money.parseMajor('1.001', currency: usd),
      throwsFormatException,
    );
  });

  test('MONEY-017 normaliza códigos de moneda', () {
    expect(Currency(code: 'usd', scale: 2).code, 'USD');
  });

  test('MONEY-018 rechaza código o escala inválidos', () {
    final shortCode = 'U';
    final invalidScale = 7;

    expect(() => Currency(code: shortCode, scale: 2), throwsArgumentError);
    expect(
      () => Currency(code: 'USD', scale: invalidScale),
      throwsArgumentError,
    );
  });
}
