import 'package:boveda_personal/features/settings/domain/entities/app_settings.dart';

abstract interface class SettingsRepository {
  Future<AppSettings?> load();
  Future<void> save(AppSettings settings);
}
