import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/accounts/data/models/account_model.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account.dart';
import 'package:boveda_personal/features/auth/data/models/user_model.dart';
import 'package:boveda_personal/features/auth/domain/entities/user.dart';
import 'package:boveda_personal/features/categories/data/models/category_model.dart';
import 'package:boveda_personal/features/categories/domain/entities/category.dart';
import 'package:boveda_personal/features/converter/data/models/calculator_currency_model.dart';
import 'package:boveda_personal/features/converter/domain/entities/calculator_currency.dart';
import 'package:boveda_personal/features/movements/data/models/movement_model.dart';
import 'package:boveda_personal/features/movements/data/models/transfer_model.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/entities/transfer.dart';
import 'package:boveda_personal/features/rates/data/models/exchange_rate_model.dart';
import 'package:boveda_personal/features/rates/domain/entities/exchange_rate.dart';
import 'package:boveda_personal/features/settings/data/models/app_settings_model.dart';
import 'package:boveda_personal/features/settings/domain/entities/app_settings.dart';
import 'package:boveda_personal/features/simulator/data/models/simulation_history_model.dart';
import 'package:boveda_personal/features/simulator/domain/entities/simulation_history.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 6, 25, 18, 30);
  final usd = Currency(code: 'USD', scale: 2);
  final uyu = Currency(code: 'UYU', scale: 2);

  test('MAP-001 todos los modelos hacen roundtrip SQLite sin pérdida', () {
    final entities = <Object>[
      User(
        id: 'user',
        displayName: 'Luis',
        username: 'luis',
        passwordHash: 'hash',
        passwordSalt: 'salt',
        createdAt: now,
        updatedAt: now,
      ),
      Account(
        id: 'usd',
        userId: 'user',
        currency: usd,
        name: 'Dólares',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: 'food',
        name: 'Alimentación',
        icon: 'restaurant',
        colorValue: 0xFFFFB4AB,
        movementType: CategoryMovementType.expense,
        isSystem: true,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      Movement(
        id: 'movement',
        accountId: 'usd',
        categoryId: 'food',
        type: MovementType.expense,
        amount: Money(minorUnits: 1250, currency: usd),
        note: 'Cena',
        occurredAt: now,
        createdAt: now,
        updatedAt: now,
      ),
      Transfer(
        id: 'transfer',
        sourceAccountId: 'usd',
        destinationAccountId: 'uyu',
        sourceAmount: Money(minorUnits: 100, currency: usd),
        destinationAmount: Money(minorUnits: 4000, currency: uyu),
        exchangeRate: Decimal.parse('40'),
        occurredAt: now,
        createdAt: now,
        updatedAt: now,
      ),
      ExchangeRate(
        id: 'rate',
        baseCurrencyCode: 'USD',
        quoteCurrencyCode: 'UYU',
        rate: Decimal.parse('40'),
        effectiveAt: now,
        createdAt: now,
      ),
      CalculatorCurrency(
        id: 'uyu',
        name: 'Peso uruguayo',
        currency: uyu,
        symbol: r'$',
        unitsPerUsd: Decimal.parse('40'),
        isActive: true,
        createdAt: now,
        updatedAt: now,
      ),
      SimulationHistory(
        id: 'simulation',
        currency: usd,
        initialBalance: Money(minorUnits: 10000, currency: usd),
        monthlyIncome: Money(minorUnits: 1000, currency: usd),
        monthlyExpense: Money(minorUnits: 500, currency: usd),
        durationMonths: 12,
        projectedBalance: Money(minorUnits: 16000, currency: usd),
        createdAt: now,
      ),
      AppSettings(
        userId: 'user',
        primaryCurrencyCode: 'USD',
        locale: 'es',
        biometricsEnabled: true,
        autoLockDuration: const Duration(minutes: 5),
        onboardingCompleted: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    final restored = <Object>[
      UserModel.fromRow(
        UserModel.fromEntity(entities[0] as User).toRow(),
      ).toEntity(),
      AccountModel.fromRow(
        AccountModel.fromEntity(entities[1] as Account).toRow(),
      ).toEntity(),
      CategoryModel.fromRow(
        CategoryModel.fromEntity(entities[2] as Category).toRow(),
      ).toEntity(),
      MovementModel.fromRow(
        MovementModel.fromEntity(entities[3] as Movement).toRow(),
        currency: usd,
      ).toEntity(),
      TransferModel.fromRow(
        TransferModel.fromEntity(entities[4] as Transfer).toRow(),
        sourceCurrency: usd,
        destinationCurrency: uyu,
      ).toEntity(),
      ExchangeRateModel.fromRow(
        ExchangeRateModel.fromEntity(entities[5] as ExchangeRate).toRow(),
      ).toEntity(),
      CalculatorCurrencyModel.fromRow(
        CalculatorCurrencyModel.fromEntity(
          entities[6] as CalculatorCurrency,
        ).toRow(),
      ).toEntity(),
      SimulationHistoryModel.fromRow(
        SimulationHistoryModel.fromEntity(
          entities[7] as SimulationHistory,
        ).toRow(),
      ).toEntity(),
      AppSettingsModel.fromRow(
        AppSettingsModel.fromEntity(entities[8] as AppSettings).toRow(),
      ).toEntity(),
    ];

    expect(restored, entities);
  });
}
