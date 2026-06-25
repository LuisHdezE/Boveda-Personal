import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/features/auth/domain/entities/auth_session.dart';
import 'package:boveda_personal/features/auth/domain/entities/biometric_status.dart';
import 'package:boveda_personal/features/auth/domain/repositories/biometric_repository.dart';

class GetBiometricStatus {
  const GetBiometricStatus(this.repository);
  final BiometricRepository repository;

  Future<BiometricStatus> call() => repository.status();
}

class EnableBiometrics {
  const EnableBiometrics(this.repository);
  final BiometricRepository repository;

  Future<void> call(String userId) async {
    final status = await repository.status();
    if (!status.canAuthenticate) {
      throw const ValidationFailure('biometrics_unavailable');
    }
    if (!await repository.authenticate()) {
      throw const AuthenticationFailure('biometric_authentication_failed');
    }
    await repository.storeUserId(userId);
  }
}

class DisableBiometrics {
  const DisableBiometrics(this.repository);
  final BiometricRepository repository;

  Future<void> call() => repository.clearUserId();
}

class UnlockWithBiometrics {
  const UnlockWithBiometrics({
    required this.repository,
    required this.now,
    required this.autoLockDuration,
  });

  final BiometricRepository repository;
  final DateTime Function() now;
  final Future<Duration?> Function() autoLockDuration;

  Future<AuthSession> call() async {
    final userId = await repository.readUserId();
    if (userId == null || !await repository.authenticate()) {
      throw const AuthenticationFailure('biometric_authentication_failed');
    }
    final instant = now().toUtc();
    return AuthSession.authenticated(
      userId: userId,
      authenticatedAt: instant,
      lastActivityAt: instant,
      autoLockDuration: await autoLockDuration(),
    );
  }
}
