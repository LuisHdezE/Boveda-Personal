enum SessionState {
  anonymous,
  authenticated,
  locked,
}

class AuthSession {
  const AuthSession._({
    required this.state,
    this.userId,
    this.authenticatedAt,
    this.lastActivityAt,
    this.autoLockDuration,
  });

  factory AuthSession.anonymous() {
    return const AuthSession._(state: SessionState.anonymous);
  }

  factory AuthSession.authenticated({
    required String userId,
    required DateTime authenticatedAt,
    required DateTime lastActivityAt,
    Duration? autoLockDuration,
  }) {
    if (userId.trim().isEmpty) {
      throw ArgumentError.value(userId, 'userId');
    }
    if (lastActivityAt.isBefore(authenticatedAt)) {
      throw ArgumentError('lastActivityAt cannot precede authenticatedAt');
    }
    if (autoLockDuration != null && autoLockDuration.isNegative) {
      throw ArgumentError.value(autoLockDuration, 'autoLockDuration');
    }
    return AuthSession._(
      state: SessionState.authenticated,
      userId: userId,
      authenticatedAt: authenticatedAt,
      lastActivityAt: lastActivityAt,
      autoLockDuration: autoLockDuration,
    );
  }

  factory AuthSession.locked(AuthSession session) {
    if (session.userId == null) {
      throw ArgumentError('Only an identified session can be locked');
    }
    return AuthSession._(
      state: SessionState.locked,
      userId: session.userId,
      authenticatedAt: session.authenticatedAt,
      lastActivityAt: session.lastActivityAt,
      autoLockDuration: session.autoLockDuration,
    );
  }

  final SessionState state;
  final String? userId;
  final DateTime? authenticatedAt;
  final DateTime? lastActivityAt;
  final Duration? autoLockDuration;

  bool get isAuthenticated => state == SessionState.authenticated;
  bool get isLocked => state == SessionState.locked;

  bool shouldLockAt(DateTime instant) {
    if (!isAuthenticated || autoLockDuration == null) {
      return false;
    }
    return !instant.isBefore(lastActivityAt!.add(autoLockDuration!));
  }

  AuthSession recordActivity(DateTime instant) {
    if (!isAuthenticated) {
      throw StateError('Only an authenticated session records activity');
    }
    if (instant.isBefore(lastActivityAt!)) {
      throw ArgumentError('Activity cannot move backwards in time');
    }
    return AuthSession.authenticated(
      userId: userId!,
      authenticatedAt: authenticatedAt!,
      lastActivityAt: instant,
      autoLockDuration: autoLockDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AuthSession &&
        other.state == state &&
        other.userId == userId &&
        other.authenticatedAt == authenticatedAt &&
        other.lastActivityAt == lastActivityAt &&
        other.autoLockDuration == autoLockDuration;
  }

  @override
  int get hashCode => Object.hash(
        state,
        userId,
        authenticatedAt,
        lastActivityAt,
        autoLockDuration,
      );
}
