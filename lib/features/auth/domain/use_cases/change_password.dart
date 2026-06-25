import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/core/ports/password_hasher.dart';
import 'package:boveda_personal/features/auth/domain/commands/auth_commands.dart';
import 'package:boveda_personal/features/auth/domain/entities/user.dart';
import 'package:boveda_personal/features/auth/domain/repositories/auth_repository.dart';

class ChangePassword {
  const ChangePassword({
    required this.repository,
    required this.hasher,
    required this.now,
  });

  final AuthRepository repository;
  final PasswordHasher hasher;
  final DateTime Function() now;

  Future<User> call({
    required User user,
    required PasswordChange change,
  }) async {
    final currentIsValid = await hasher.verify(
      password: change.currentPassword,
      hash: user.passwordHash,
      salt: user.passwordSalt,
    );
    if (!currentIsValid) {
      throw const AuthenticationFailure('invalid_current_password');
    }
    final digest = await hasher.hash(change.newPassword);
    final updated = user.copyWith(
      passwordHash: digest.hash,
      passwordSalt: digest.salt,
      updatedAt: now().toUtc(),
    );
    await repository.save(updated);
    return updated;
  }
}
