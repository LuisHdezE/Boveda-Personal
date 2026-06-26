import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/auth/domain/commands/auth_commands.dart';
import 'package:boveda_personal/features/movements/domain/commands/movement_commands.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/rates/domain/commands/exchange_rate_update.dart';
import 'package:boveda_personal/features/settings/domain/commands/profile_update.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 6, 25);
  final usd = Currency(code: 'USD', scale: 2);
  final uyu = Currency(code: 'UYU', scale: 2);

  test('MODEL-011 credenciales no exponen contraseñas', () {
    final credentials = LoginCredentials(
      username: 'luis',
      password: 'super-secret',
    );
    final change = PasswordChange(
      currentPassword: 'old-secret',
      newPassword: 'new-secret',
    );

    expect(credentials.toString(), isNot(contains('super-secret')));
    expect(change.toString(), isNot(contains('old-secret')));
    expect(change.toString(), isNot(contains('new-secret')));
  });

  test('MOV-003 borrador rechaza importe no positivo', () {
    expect(
      () => MovementDraft(
        accountId: 'usd',
        categoryId: 'food',
        type: MovementType.expense,
        amount: Money.zero(usd),
        occurredAt: now,
      ),
      throwsArgumentError,
    );
  });

  test('TRF-001 borrador rechaza cuentas iguales', () {
    expect(
      () => TransferDraft(
        sourceAccountId: 'usd',
        destinationAccountId: 'usd',
        sourceAmount: Money(minorUnits: 100, currency: usd),
        destinationAmount: Money(minorUnits: 100, currency: uyu),
        exchangeRate: Decimal.fromInt(40),
        occurredAt: now,
      ),
      throwsArgumentError,
    );
  });

  test('RATE-003 actualización rechaza par idéntico', () {
    expect(
      () => ExchangeRateUpdate(
        baseCurrencyCode: 'USD',
        quoteCurrencyCode: 'usd',
        rate: Decimal.fromInt(1),
        effectiveAt: now,
      ),
      throwsArgumentError,
    );
  });

  test('SET-002 perfil normaliza espacios externos', () {
    final update = ProfileUpdate(displayName: '  Luis  ', username: '  luis  ');

    expect(update.displayName, 'Luis');
    expect(update.username, 'luis');
  });
}
