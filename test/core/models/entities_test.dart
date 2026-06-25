import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account.dart';
import 'package:boveda_personal/features/auth/domain/entities/user.dart';
import 'package:boveda_personal/features/categories/domain/entities/category.dart';
import 'package:boveda_personal/features/converter/domain/entities/calculator_currency.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/entities/transfer.dart';
import 'package:boveda_personal/features/rates/domain/entities/exchange_rate.dart';
import 'package:boveda_personal/features/settings/domain/entities/app_settings.dart';
import 'package:boveda_personal/features/simulator/domain/entities/simulation_history.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 6, 25);
  final usd = Currency(code: 'USD', scale: 2);
  final uyu = Currency(code: 'UYU', scale: 2);

  test('MODEL-001 entidades con los mismos datos son iguales', () {
    final first = Account(
      id: 'usd',
      userId: 'user',
      currency: usd,
      name: 'Dólares',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    final second = first.copyWith();

    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });

  test('MODEL-002 copyWith cambia solo los campos indicados', () {
    final account = Account(
      id: 'usd',
      userId: 'user',
      currency: usd,
      name: 'Dólares',
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    final changed = account.copyWith(name: 'Cuenta USD', isActive: false);

    expect(changed.name, 'Cuenta USD');
    expect(changed.isActive, isFalse);
    expect(changed.id, account.id);
    expect(changed.currency, account.currency);
  });

  test('LOG-001 User.toString no expone hash ni salt', () {
    final user = User(
      id: 'user',
      displayName: 'Luis',
      username: 'luis',
      passwordHash: 'secret-hash',
      passwordSalt: 'secret-salt',
      createdAt: now,
      updatedAt: now,
    );

    expect(user.toString(), isNot(contains('secret-hash')));
    expect(user.toString(), isNot(contains('secret-salt')));
  });

  test('MODEL-003 modelos financieros conservan sus tipos', () {
    final category = Category(
      id: 'food',
      name: 'Alimentación',
      icon: 'restaurant',
      colorValue: 0xFFFFB4AB,
      movementType: CategoryMovementType.expense,
      isSystem: true,
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    final movement = Movement(
      id: 'movement',
      accountId: 'usd',
      categoryId: category.id,
      type: MovementType.expense,
      amount: Money(minorUnits: 1250, currency: usd),
      occurredAt: now,
      createdAt: now,
      updatedAt: now,
    );
    final transfer = Transfer(
      id: 'transfer',
      sourceAccountId: 'usd',
      destinationAccountId: 'uyu',
      sourceAmount: Money(minorUnits: 100, currency: usd),
      destinationAmount: Money(minorUnits: 4000, currency: uyu),
      exchangeRate: Decimal.parse('40'),
      occurredAt: now,
      createdAt: now,
      updatedAt: now,
    );

    expect(movement.isDebit, isTrue);
    expect(movement.signedMinorUnits, -1250);
    expect(transfer.sourceAmount.currency, usd);
    expect(transfer.destinationAmount.currency, uyu);
  });

  test('MODEL-004 settings y modelos auxiliares se construyen completos', () {
    final settings = AppSettings(
      userId: 'user',
      primaryCurrencyCode: 'usd',
      locale: 'es',
      biometricsEnabled: false,
      autoLockDuration: const Duration(minutes: 5),
      onboardingCompleted: true,
      createdAt: now,
      updatedAt: now,
    );
    final rate = ExchangeRate(
      id: 'rate',
      baseCurrencyCode: 'usd',
      quoteCurrencyCode: 'uyu',
      rate: Decimal.parse('40'),
      effectiveAt: now,
      createdAt: now,
    );
    final currency = CalculatorCurrency(
      id: 'uyu',
      name: 'Peso uruguayo',
      currency: uyu,
      symbol: r'$',
      unitsPerUsd: Decimal.parse('40'),
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );
    final simulation = SimulationHistory(
      id: 'simulation',
      currency: usd,
      initialBalance: Money(minorUnits: 10000, currency: usd),
      monthlyIncome: Money(minorUnits: 1000, currency: usd),
      monthlyExpense: Money(minorUnits: 500, currency: usd),
      durationMonths: 12,
      projectedBalance: Money(minorUnits: 16000, currency: usd),
      createdAt: now,
    );

    expect(settings.primaryCurrencyCode, 'USD');
    expect(rate.baseCurrencyCode, 'USD');
    expect(currency.unitsPerUsd, Decimal.parse('40'));
    expect(simulation.netMonthly.minorUnits, 500);
  });
}
