import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/core/ports/password_hasher.dart';
import 'package:boveda_personal/features/auth/domain/commands/auth_commands.dart';
import 'package:boveda_personal/features/auth/domain/entities/auth_session.dart';
import 'package:boveda_personal/features/auth/domain/repositories/auth_repository.dart';

class Login {
  const Login({
    required this.repository,
    required this.hasher,
    required this.now,
    required this.autoLockDuration,
  });

  final AuthRepository repository;
  final PasswordHasher hasher;
  final DateTime Function() now;
  final Future<Duration?> Function() autoLockDuration;

  Future<AuthSession> call(LoginCredentials credentials) async {
    final user = await repository.findByUsername(credentials.username);
    final valid = await hasher.verify(
      password: credentials.password,
      hash: user?.passwordHash ?? _dummyHash,
      salt: user?.passwordSalt ?? _dummySalt,
    );
    if (!valid || user == null) {
      throw const AuthenticationFailure('invalid_credentials');
    }
    final instant = now().toUtc();
    return AuthSession.authenticated(
      userId: user.id,
      authenticatedAt: instant,
      lastActivityAt: instant,
      autoLockDuration: await autoLockDuration(),
    );
  }
}

const _dummyHash = 'invalid-user-dummy-hash';
const _dummySalt = 'invalid-user-dummy-salt';
