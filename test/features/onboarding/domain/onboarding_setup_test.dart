import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/onboarding/domain/entities/onboarding_setup.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final usd = Currency(code: 'USD', scale: 2);
  final uyu = Currency(code: 'UYU', scale: 2);

  test('ONB-003 configuración completa exige todos los campos', () {
    final setup = OnboardingSetup(
      displayName: 'Luis',
      username: 'luis',
      password: 'password',
      primaryCurrency: usd,
      secondaryCurrency: uyu,
      initialExchangeRate: Decimal.parse('40'),
      primaryOpeningBalance: Money.zero(usd),
      secondaryOpeningBalance: Money.zero(uyu),
      locale: 'es',
    );

    expect(setup.isComplete, isTrue);
  });

  test('ONB-014 rechaza cuentas con la misma moneda', () {
    expect(
      () => OnboardingSetup(
        displayName: 'Luis',
        username: 'luis',
        password: 'password',
        primaryCurrency: usd,
        secondaryCurrency: usd,
        initialExchangeRate: Decimal.fromInt(1),
        primaryOpeningBalance: Money.zero(usd),
        secondaryOpeningBalance: Money.zero(usd),
        locale: 'es',
      ),
      throwsArgumentError,
    );
  });

  test('LOG-001 onboarding no imprime la contraseña', () {
    final setup = OnboardingSetup(
      displayName: 'Luis',
      username: 'luis',
      password: 'super-secret',
      primaryCurrency: usd,
      secondaryCurrency: uyu,
      initialExchangeRate: Decimal.parse('40'),
      primaryOpeningBalance: Money.zero(usd),
      secondaryOpeningBalance: Money.zero(uyu),
      locale: 'es',
    );

    expect(setup.toString(), isNot(contains('super-secret')));
  });
}
