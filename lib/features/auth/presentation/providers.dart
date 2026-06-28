import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/auth/domain/commands/auth_commands.dart';
import 'package:boveda_personal/features/auth/domain/entities/auth_session.dart';
import 'package:boveda_personal/features/auth/domain/use_cases/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Sesión activa ──────────────────────────────────────────────────────────

class SessionNotifier extends Notifier<AuthSession> {
  @override
  AuthSession build() => AuthSession.anonymous();

  void updateState(AuthSession newSession) {
    state = newSession;
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, AuthSession>(
  SessionNotifier.new,
);

// ── Notifier de login ──────────────────────────────────────────────────────

class LoginState {
  const LoginState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  LoginState copyWith({bool? isLoading, String? error, bool clearError = false}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final settings = await ref.read(appSettingsProvider.future);
      final useCase = Login(
        repository: ref.read(authRepositoryProvider),
        hasher: ref.read(passwordHasherProvider),
        now: DateTime.now,
        autoLockDuration: () async => settings?.autoLockDuration,
      );

      final session = await useCase(
        LoginCredentials(username: username, password: password),
      );

      ref.read(sessionProvider.notifier).updateState(session);
      state = state.copyWith(isLoading: false);
      return true;
    } on AuthenticationFailure {
      state = state.copyWith(
        isLoading: false,
        error: 'Usuario o contraseña incorrectos',
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error inesperado. Intenta de nuevo.',
      );
      return false;
    }
  }



  void logout() {
    ref.read(sessionProvider.notifier).updateState(AuthSession.anonymous());
  }
}

final loginNotifierProvider = NotifierProvider<LoginNotifier, LoginState>(
  LoginNotifier.new,
);


