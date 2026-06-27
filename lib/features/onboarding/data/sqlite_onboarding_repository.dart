import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/dao/account_dao.dart';
import 'package:boveda_personal/core/database/dao/exchange_rate_dao.dart';
import 'package:boveda_personal/core/database/dao/movement_dao.dart';
import 'package:boveda_personal/core/database/dao/user_settings_dao.dart';
import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:sqflite/sqflite.dart';

class SqliteOnboardingRepository implements OnboardingRepository {
  const SqliteOnboardingRepository({
    required BovedaDatabase database,
    required UserSettingsDao userDao,
    required AccountDao accountDao,
    required MovementDao movementDao,
    required ExchangeRateDao exchangeRateDao,
  }) : _database = database,
       _userDao = userDao,
       _accountDao = accountDao,
       _movementDao = movementDao,
       _exchangeRateDao = exchangeRateDao;

  final BovedaDatabase _database;
  final UserSettingsDao _userDao;
  final AccountDao _accountDao;
  final MovementDao _movementDao;
  final ExchangeRateDao _exchangeRateDao;

  @override
  Future<bool> isConfigured() async {
    final row = await _userDao.loadSettings();
    return row != null && (row['onboarding_completed'] == 1);
  }

  @override
  Future<void> initialize(OnboardingData data) async {
    await _database.transaction((txn) async {
      // Usuario
      await txn.insert('users', {
        'id': data.user.id,
        'display_name': data.user.displayName,
        'username': data.user.username,
        'password_hash': data.user.passwordHash,
        'password_salt': data.user.passwordSalt,
        'created_at': RowConverters.dateToSql(data.user.createdAt),
        'updated_at': RowConverters.dateToSql(data.user.updatedAt),
      });

      // Cuentas
      for (final account in data.accounts) {
        await txn.insert('accounts', {
          'id': account.id,
          'user_id': account.userId,
          'currency_code': account.currency.code,
          'currency_scale': account.currency.scale,
          'name': account.name,
          'is_active': RowConverters.boolToSql(account.isActive),
          'created_at': RowConverters.dateToSql(account.createdAt),
          'updated_at': RowConverters.dateToSql(account.updatedAt),
        });
      }

      // Settings
      await txn.insert(
        'settings',
        {
          'id': 1,
          'user_id': data.settings.userId,
          'primary_currency_code': data.settings.primaryCurrencyCode,
          'locale': data.settings.locale,
          'biometrics_enabled': RowConverters.boolToSql(data.settings.biometricsEnabled),
          'auto_lock_duration_seconds': data.settings.autoLockDuration?.inSeconds,
          'onboarding_completed': RowConverters.boolToSql(data.settings.onboardingCompleted),
          'created_at': RowConverters.dateToSql(data.settings.createdAt),
          'updated_at': RowConverters.dateToSql(data.settings.updatedAt),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Tasa de cambio inicial
      await txn.insert('exchange_rates', {
        'id': data.initialRate.id,
        'base_currency_code': data.initialRate.baseCurrencyCode,
        'quote_currency_code': data.initialRate.quoteCurrencyCode,
        'rate': data.initialRate.rate.toString(),
        'effective_at': RowConverters.dateToSql(data.initialRate.effectiveAt),
        'created_at': RowConverters.dateToSql(data.initialRate.createdAt),
      });

      // Movimientos de apertura
      for (final m in data.openingMovements) {
        await txn.insert('movements', {
          'id': m.id,
          'account_id': m.accountId,
          'category_id': m.categoryId,
          'transfer_id': m.transferId,
          'type': m.type.value,
          'amount_minor': m.amount.minorUnits,
          'occurred_at': RowConverters.dateToSql(m.occurredAt),
          'note': m.note,
          'created_at': RowConverters.dateToSql(m.createdAt),
          'updated_at': RowConverters.dateToSql(m.updatedAt),
        });
      }
    });
  }
}
