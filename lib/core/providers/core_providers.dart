import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/dao/account_dao.dart';
import 'package:boveda_personal/core/database/dao/exchange_rate_dao.dart';
import 'package:boveda_personal/core/database/dao/movement_dao.dart';
import 'package:boveda_personal/core/database/dao/user_settings_dao.dart';
import 'package:boveda_personal/core/infrastructure/uuid_id_generator.dart';
import 'package:boveda_personal/core/ports/id_generator.dart';
import 'package:boveda_personal/core/ports/password_hasher.dart';
import 'package:boveda_personal/core/security/cryptography_password_hasher.dart';
import 'package:boveda_personal/features/accounts/data/sqlite_account_repository.dart';
import 'package:boveda_personal/features/accounts/domain/repositories/account_repository.dart';
import 'package:boveda_personal/features/auth/data/sqlite_auth_repository.dart';
import 'package:boveda_personal/features/auth/domain/repositories/auth_repository.dart';
import 'package:boveda_personal/features/movements/data/sqlite_movement_repository.dart';
import 'package:boveda_personal/features/movements/domain/repositories/movement_repository.dart';
import 'package:boveda_personal/features/onboarding/data/sqlite_onboarding_repository.dart';
import 'package:boveda_personal/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:boveda_personal/features/rates/data/sqlite_exchange_rate_repository.dart';
import 'package:boveda_personal/features/rates/domain/repositories/exchange_rate_repository.dart';
import 'package:boveda_personal/features/settings/data/sqlite_settings_repository.dart';
import 'package:boveda_personal/features/settings/domain/entities/app_settings.dart';
import 'package:boveda_personal/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:boveda_personal/core/database/dao/debt_dao.dart';
import 'package:boveda_personal/core/database/dao/subscription_dao.dart';
import 'package:boveda_personal/features/debts/data/repositories/sqlite_debt_repository.dart';
import 'package:boveda_personal/features/debts/domain/repositories/debt_repository.dart';
import 'package:boveda_personal/features/subscriptions/data/repositories/sqlite_subscription_repository.dart';
import 'package:boveda_personal/features/subscriptions/domain/repositories/subscription_repository.dart';

// ── Infraestructura ────────────────────────────────────────────────────────

final passwordHasherProvider = Provider<PasswordHasher>(
  (_) => const CryptographyPasswordHasher(),
);

final idGeneratorProvider = Provider<IdGenerator>(
  (_) => const UuidIdGenerator(),
);

// ── Base de datos ──────────────────────────────────────────────────────────

final bovedaDatabaseProvider = Provider<BovedaDatabase>((ref) {
  final db = BovedaDatabase();
  ref.onDispose(db.close);
  return db;
});

// ── DAOs ──────────────────────────────────────────────────────────────────

final userSettingsDaoProvider = Provider<UserSettingsDao>((ref) {
  return UserSettingsDao(ref.watch(bovedaDatabaseProvider));
});

final accountDaoProvider = Provider<AccountDao>((ref) {
  return AccountDao(ref.watch(bovedaDatabaseProvider));
});

final movementDaoProvider = Provider<MovementDao>((ref) {
  return MovementDao(ref.watch(bovedaDatabaseProvider));
});

final exchangeRateDaoProvider = Provider<ExchangeRateDao>((ref) {
  return ExchangeRateDao(ref.watch(bovedaDatabaseProvider));
});

final debtDaoProvider = Provider<DebtDao>((ref) {
  return DebtDao(ref.watch(bovedaDatabaseProvider));
});

final subscriptionDaoProvider = Provider<SubscriptionDao>((ref) {
  return SubscriptionDao(ref.watch(bovedaDatabaseProvider));
});

// ── Repositorios ──────────────────────────────────────────────────────────

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SqliteSettingsRepository(ref.watch(userSettingsDaoProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SqliteAuthRepository(ref.watch(userSettingsDaoProvider));
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return SqliteOnboardingRepository(
    database: ref.watch(bovedaDatabaseProvider),
    userDao: ref.watch(userSettingsDaoProvider),
    accountDao: ref.watch(accountDaoProvider),
    movementDao: ref.watch(movementDaoProvider),
    exchangeRateDao: ref.watch(exchangeRateDaoProvider),
  );
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return SqliteAccountRepository(ref.watch(accountDaoProvider));
});

final movementRepositoryProvider = Provider<MovementRepository>((ref) {
  return SqliteMovementRepository(
    dao: ref.watch(movementDaoProvider),
    accounts: ref.watch(accountRepositoryProvider),
  );
});

final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>((ref) {
  return SqliteExchangeRateRepository(ref.watch(exchangeRateDaoProvider));
});

final debtRepositoryProvider = Provider<DebtRepository>((ref) {
  return SqliteDebtRepository(ref.watch(debtDaoProvider));
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SqliteSubscriptionRepository(ref.watch(subscriptionDaoProvider));
});

// ── Settings globales ─────────────────────────────────────────────────────

/// Carga los [AppSettings] desde la BD. Retorna null si aún no está configurado.
final appSettingsProvider = FutureProvider<AppSettings?>((ref) async {
  return ref.watch(settingsRepositoryProvider).load();
});
