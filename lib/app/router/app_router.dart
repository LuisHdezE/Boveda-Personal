import 'package:boveda_personal/shared/presentation/scaffold/feature_placeholder_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const movement = '/movements/new';
  static const history = '/movements';
  static const reports = '/reports';
  static const simulator = '/simulator';
  static const converter = '/converter';
  static const settings = '/settings';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const FeaturePlaceholderScreen(title: 'Splash'),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) =>
            const FeaturePlaceholderScreen(title: 'Configuración inicial'),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => const FeaturePlaceholderScreen(title: 'Login'),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (_, _) => const FeaturePlaceholderScreen(title: 'Inicio'),
      ),
      GoRoute(
        path: AppRoutes.movement,
        builder: (_, _) =>
            const FeaturePlaceholderScreen(title: 'Nuevo movimiento'),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (_, _) =>
            const FeaturePlaceholderScreen(title: 'Históricos'),
      ),
      GoRoute(
        path: AppRoutes.reports,
        builder: (_, _) => const FeaturePlaceholderScreen(title: 'Reportes'),
      ),
      GoRoute(
        path: AppRoutes.simulator,
        builder: (_, _) => const FeaturePlaceholderScreen(title: 'Simulador'),
      ),
      GoRoute(
        path: AppRoutes.converter,
        builder: (_, _) => const FeaturePlaceholderScreen(title: 'Conversor'),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) =>
            const FeaturePlaceholderScreen(title: 'Configuración'),
      ),
    ],
  );
});
