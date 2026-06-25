import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/core/ports/id_generator.dart';
import 'package:boveda_personal/core/ports/password_hasher.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account.dart';
import 'package:boveda_personal/features/auth/domain/entities/user.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/onboarding/domain/entities/onboarding_setup.dart';
import 'package:boveda_personal/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:boveda_personal/features/rates/domain/entities/exchange_rate.dart';
import 'package:boveda_personal/features/settings/domain/entities/app_settings.dart';

class ConfigureApplication {
  const ConfigureApplication({
    required this.repository,
    required this.hasher,
    required this.ids,
    required this.now,
  });

  final OnboardingRepository repository;
  final PasswordHasher hasher;
  final IdGenerator ids;
  final DateTime Function() now;

  Future<OnboardingData> call(OnboardingSetup setup) async {
    if (!setup.isComplete) {
      throw const ValidationFailure('onboarding_incomplete');
    }
    if (await repository.isConfigured()) {
      throw const ConflictFailure('application_already_configured');
    }
    final instant = now().toUtc();
    final digest = await hasher.hash(setup.password);
    final userId = ids.next();
    final user = User(
      id: userId,
      displayName: setup.displayName,
      username: setup.username,
      passwordHash: digest.hash,
      passwordSalt: digest.salt,
      createdAt: instant,
      updatedAt: instant,
    );
    final primaryAccount = Account(
      id: ids.next(),
      userId: userId,
      currency: setup.primaryCurrency,
      name: setup.primaryCurrency.code,
      isActive: true,
      createdAt: instant,
      updatedAt: instant,
    );
    final secondaryAccount = Account(
      id: ids.next(),
      userId: userId,
      currency: setup.secondaryCurrency,
      name: setup.secondaryCurrency.code,
      isActive: true,
      createdAt: instant,
      updatedAt: instant,
    );
    final settings = AppSettings(
      userId: userId,
      primaryCurrencyCode: setup.primaryCurrency.code,
      locale: setup.locale,
      biometricsEnabled: false,
      autoLockDuration: Duration.zero,
      onboardingCompleted: true,
      createdAt: instant,
      updatedAt: instant,
    );
    final initialRate = ExchangeRate(
      id: ids.next(),
      baseCurrencyCode: setup.primaryCurrency.code,
      quoteCurrencyCode: setup.secondaryCurrency.code,
      rate: setup.initialExchangeRate,
      effectiveAt: instant,
      createdAt: instant,
    );
    final openingMovements = <Movement>[
      if (!setup.primaryOpeningBalance.isZero)
        _opening(
          id: ids.next(),
          account: primaryAccount,
          amount: setup.primaryOpeningBalance,
          instant: instant,
        ),
      if (!setup.secondaryOpeningBalance.isZero)
        _opening(
          id: ids.next(),
          account: secondaryAccount,
          amount: setup.secondaryOpeningBalance,
          instant: instant,
        ),
    ];
    final data = OnboardingData(
      user: user,
      settings: settings,
      accounts: [primaryAccount, secondaryAccount],
      initialRate: initialRate,
      openingMovements: openingMovements,
    );
    await repository.initialize(data);
    return data;
  }
}

Movement _opening({
  required String id,
  required Account account,
  required Money amount,
  required DateTime instant,
}) {
  return Movement(
    id: id,
    accountId: account.id,
    type: MovementType.opening,
    amount: amount,
    occurredAt: instant,
    createdAt: instant,
    updatedAt: instant,
  );
}
