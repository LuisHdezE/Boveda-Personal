import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/features/auth/domain/entities/user.dart';
import 'package:boveda_personal/features/auth/domain/repositories/auth_repository.dart';
import 'package:boveda_personal/features/settings/domain/commands/profile_update.dart';
import 'package:boveda_personal/features/settings/domain/entities/app_settings.dart';
import 'package:boveda_personal/features/settings/domain/repositories/settings_repository.dart';

class UpdateProfile {
  const UpdateProfile({
    required this.repository,
    required this.now,
  });

  final AuthRepository repository;
  final DateTime Function() now;

  Future<User> call(User user, ProfileUpdate update) async {
    final existing = await repository.findByUsername(update.username);
    if (existing != null && existing.id != user.id) {
      throw const ConflictFailure('username_already_exists');
    }
    final changed = user.copyWith(
      displayName: update.displayName,
      username: update.username,
      updatedAt: now().toUtc(),
    );
    await repository.save(changed);
    return changed;
  }
}

class SaveSettings {
  const SaveSettings(this.repository);
  final SettingsRepository repository;

  Future<AppSettings> call(AppSettings settings) async {
    await repository.save(settings);
    return settings;
  }
}

class LoadSettings {
  const LoadSettings(this.repository);
  final SettingsRepository repository;

  Future<AppSettings> call() async {
    final settings = await repository.load();
    if (settings == null) {
      throw const NotFoundFailure('settings_not_found');
    }
    return settings;
  }
}
