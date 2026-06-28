import 'package:boveda_personal/core/database/dao/user_settings_dao.dart';
import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/features/settings/domain/entities/app_settings.dart';
import 'package:boveda_personal/features/settings/domain/repositories/settings_repository.dart';

class SqliteSettingsRepository implements SettingsRepository {
  const SqliteSettingsRepository(this._dao);

  final UserSettingsDao _dao;

  @override
  Future<AppSettings?> load() async {
    final row = await _dao.loadSettings();
    if (row == null) return null;
    return _fromRow(row);
  }

  @override
  Future<void> save(AppSettings settings) async {
    await _dao.saveSettings(_toRow(settings));
  }

  // ─── Mapeo ────────────────────────────────────────────────────────────────

  static AppSettings _fromRow(Map<String, Object?> row) {
    final autoLockSeconds = row.optionalInt('auto_lock_duration_seconds');
    return AppSettings(
      userId: row.requiredString('user_id'),
      primaryCurrencyCode: row.requiredString('primary_currency_code'),
      secondaryCurrencyCode: row.requiredString('secondary_currency_code'),
      locale: row.requiredString('locale'),
      biometricsEnabled: row.requiredBool('biometrics_enabled'),
      autoLockDuration: autoLockSeconds != null
          ? Duration(seconds: autoLockSeconds)
          : null,
      onboardingCompleted: row.requiredBool('onboarding_completed'),
      createdAt: row.requiredDate('created_at'),
      updatedAt: row.requiredDate('updated_at'),
    );
  }

  static Map<String, Object?> _toRow(AppSettings s) {
    return {
      'id': AppSettings.singletonId,
      'user_id': s.userId,
      'primary_currency_code': s.primaryCurrencyCode,
      'secondary_currency_code': s.secondaryCurrencyCode,
      'locale': s.locale,
      'biometrics_enabled': RowConverters.boolToSql(s.biometricsEnabled),
      'auto_lock_duration_seconds': s.autoLockDuration?.inSeconds,
      'onboarding_completed': RowConverters.boolToSql(s.onboardingCompleted),
      'created_at': RowConverters.dateToSql(s.createdAt),
      'updated_at': RowConverters.dateToSql(s.updatedAt),
    };
  }
}
