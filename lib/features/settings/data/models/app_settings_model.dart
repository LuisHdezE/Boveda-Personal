import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/features/settings/domain/entities/app_settings.dart';

class AppSettingsModel {
  const AppSettingsModel(this.entity);

  final AppSettings entity;

  factory AppSettingsModel.fromEntity(AppSettings entity) {
    return AppSettingsModel(entity);
  }

  factory AppSettingsModel.fromRow(Map<String, Object?> row) {
    final lockSeconds = row.optionalInt('auto_lock_duration_seconds');
    return AppSettingsModel(
      AppSettings(
        userId: row.requiredString('user_id'),
        primaryCurrencyCode: row.requiredString('primary_currency_code'),
        locale: row.requiredString('locale'),
        biometricsEnabled: row.requiredBool('biometrics_enabled'),
        autoLockDuration:
            lockSeconds == null ? null : Duration(seconds: lockSeconds),
        onboardingCompleted: row.requiredBool('onboarding_completed'),
        createdAt: row.requiredDate('created_at'),
        updatedAt: row.requiredDate('updated_at'),
      ),
    );
  }

  AppSettings toEntity() => entity;

  Map<String, Object?> toRow() => {
        'id': AppSettings.singletonId,
        'user_id': entity.userId,
        'primary_currency_code': entity.primaryCurrencyCode,
        'locale': entity.locale,
        'biometrics_enabled':
            RowConverters.boolToSql(entity.biometricsEnabled),
        'auto_lock_duration_seconds': entity.autoLockDuration?.inSeconds,
        'onboarding_completed':
            RowConverters.boolToSql(entity.onboardingCompleted),
        'created_at': RowConverters.dateToSql(entity.createdAt),
        'updated_at': RowConverters.dateToSql(entity.updatedAt),
      };
}
