import 'package:boveda_personal/core/ports/password_hasher.dart';
import 'package:boveda_personal/features/auth/domain/commands/auth_commands.dart';
import 'package:boveda_personal/features/auth/domain/entities/user.dart';
import 'package:boveda_personal/features/auth/domain/repositories/auth_repository.dart';
import 'package:boveda_personal/features/auth/domain/use_cases/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 6, 25);

  test('AUTH-006 credenciales válidas crean sesión autenticada', () async {
    final useCase = Login(
      repository: _AuthRepository(
        User(
          id: 'user',
          displayName: 'Luis',
          username: 'luis',
          passwordHash: 'hash',
          passwordSalt: 'salt',
          createdAt: now,
          updatedAt: now,
        ),
      ),
      hasher: const _Hasher(),
      now: () => now,
      autoLockDuration: () async => const Duration(minutes: 5),
    );

    final session = await useCase(
      LoginCredentials(username: 'luis', password: 'correct'),
    );

    expect(session.isAuthenticated, isTrue);
    expect(session.userId, 'user');
  });
}

class _AuthRepository implements AuthRepository {
  _AuthRepository(this.user);
  final User user;

  @override
  Future<User?> findByUsername(String username) async =>
      username == user.username ? user : null;

  @override
  Future<void> save(User user) async {}
}

class _Hasher implements PasswordHasher {
  const _Hasher();

  @override
  Future<PasswordDigest> hash(String password) async =>
      const PasswordDigest(hash: 'hash', salt: 'salt');

  @override
  Future<bool> verify({
    required String password,
    required String hash,
    required String salt,
  }) async => password == 'correct' && hash == 'hash' && salt == 'salt';
}
