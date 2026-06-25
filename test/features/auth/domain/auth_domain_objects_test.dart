import 'package:boveda_personal/features/auth/domain/entities/auth_session.dart';
import 'package:boveda_personal/features/auth/domain/entities/biometric_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 6, 25, 12);

  test('AUTH-014 sesión determina expiración por inactividad', () {
    final session = AuthSession.authenticated(
      userId: 'user',
      authenticatedAt: now,
      lastActivityAt: now,
      autoLockDuration: const Duration(minutes: 5),
    );

    expect(session.shouldLockAt(now.add(const Duration(minutes: 4))), isFalse);
    expect(session.shouldLockAt(now.add(const Duration(minutes: 5))), isTrue);
  });

  test('AUTH-017 registrar actividad reinicia el instante', () {
    final session = AuthSession.authenticated(
      userId: 'user',
      authenticatedAt: now,
      lastActivityAt: now,
      autoLockDuration: const Duration(minutes: 5),
    );

    final updated = session.recordActivity(now.add(const Duration(minutes: 2)));

    expect(updated.lastActivityAt, now.add(const Duration(minutes: 2)));
  });

  test('AUTH-020 duración nula no bloquea automáticamente', () {
    final session = AuthSession.authenticated(
      userId: 'user',
      authenticatedAt: now,
      lastActivityAt: now,
    );

    expect(session.shouldLockAt(now.add(const Duration(days: 10))), isFalse);
  });

  test('BIO-002 distingue estados biométricos', () {
    expect(
      BiometricStatus(
        availability: BiometricAvailability.notEnrolled,
      ).canAuthenticate,
      isFalse,
    );
    expect(
      BiometricStatus(
        availability: BiometricAvailability.available,
        supportedTypes: const {BiometricKind.fingerprint},
      ).canAuthenticate,
      isTrue,
    );
  });
}
