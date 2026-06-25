import 'package:boveda_personal/features/auth/domain/entities/auth_session.dart';

class EvaluateSessionLock {
  const EvaluateSessionLock();

  AuthSession call(AuthSession session, DateTime instant) {
    return session.shouldLockAt(instant)
        ? AuthSession.locked(session)
        : session;
  }
}

class RegisterSessionActivity {
  const RegisterSessionActivity();

  AuthSession call(AuthSession session, DateTime instant) {
    return session.recordActivity(instant);
  }
}

class Logout {
  const Logout();

  AuthSession call() => AuthSession.anonymous();
}
