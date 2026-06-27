import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/onboarding/domain/entities/onboarding_setup.dart';
import 'package:boveda_personal/features/onboarding/domain/use_cases/configure_application.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingState {
  const OnboardingState({this.isLoading = false, this.error, this.completed = false});

  final bool isLoading;
  final String? error;
  final bool completed;

  OnboardingState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? completed,
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      completed: completed ?? this.completed,
    );
  }
}

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  Future<void> configure(OnboardingSetup setup) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final useCase = ConfigureApplication(
        repository: ref.read(onboardingRepositoryProvider),
        hasher: ref.read(passwordHasherProvider),
        ids: ref.read(idGeneratorProvider),
        now: DateTime.now,
      );

      await useCase(setup);
      state = state.copyWith(isLoading: false, completed: true);
    } on ValidationFailure catch (e) {
      state = state.copyWith(isLoading: false, error: 'Datos incompletos: ${e.code}');
    } on ConflictFailure {
      state = state.copyWith(
        isLoading: false,
        error: 'La aplicación ya fue configurada.',
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al guardar la configuración.',
      );
    }
  }
}

final onboardingNotifierProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);
