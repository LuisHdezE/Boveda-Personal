import 'package:boveda_personal/features/auth/presentation/views/login_view.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:flutter/material.dart';
import 'package:boveda_personal/features/converter/presentation/views/calculator_view.dart';
import 'package:boveda_personal/features/converter/presentation/views/converter_view.dart';
import 'package:boveda_personal/features/debts/presentation/views/debts_view.dart';
import 'package:boveda_personal/features/subscriptions/presentation/views/subscriptions_view.dart';
import 'package:boveda_personal/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:boveda_personal/features/movements/presentation/views/movement_detail_view.dart';
import 'package:boveda_personal/features/movements/presentation/views/movement_filters_view.dart';
import 'package:boveda_personal/features/movements/presentation/views/movements_history_view.dart';
import 'package:boveda_personal/features/movements/presentation/views/new_movement_view.dart';
import 'package:boveda_personal/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:boveda_personal/features/onboarding/presentation/views/splash_view.dart';
import 'package:boveda_personal/features/reports/presentation/views/annual_report_view.dart';
import 'package:boveda_personal/features/reports/presentation/views/expenses_by_category_view.dart';
import 'package:boveda_personal/features/reports/presentation/views/monthly_report_view.dart';
import 'package:boveda_personal/features/reports/presentation/views/patrimony_evolution_view.dart';
import 'package:boveda_personal/features/reports/presentation/views/quarterly_report_view.dart';
import 'package:boveda_personal/features/reports/presentation/views/reports_view.dart';
import 'package:boveda_personal/features/reports/presentation/views/weekly_report_view.dart';
import 'package:boveda_personal/features/settings/presentation/views/about_view.dart';
import 'package:boveda_personal/features/settings/presentation/views/change_password_view.dart';
import 'package:boveda_personal/features/settings/presentation/views/currency_management_view.dart';
import 'package:boveda_personal/features/settings/presentation/views/profile_view.dart';
import 'package:boveda_personal/features/settings/presentation/views/settings_view.dart';
import 'package:boveda_personal/features/settings/presentation/views/update_usd_rate_view.dart';
import 'package:boveda_personal/features/simulator/presentation/views/simulation_result_view.dart';
import 'package:boveda_personal/features/simulator/presentation/views/simulator_view.dart';
import 'package:boveda_personal/features/simulator/domain/simulation_data.dart' as boveda_personal_simulation_data;
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
  static const debts = '/debts';
  static const subscriptions = '/subscriptions';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.debts,
        builder: (_, _) => const DebtsView(),
      ),
      GoRoute(
        path: AppRoutes.subscriptions,
        builder: (_, _) => const SubscriptionsView(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (_, _) => const DashboardView(),
      ),
      GoRoute(
        path: AppRoutes.movement,
        builder: (_, state) {
          final extra = state.extra;
          final Movement? initialMovement = extra is Movement ? extra : null;
          return NewMovementView(initialMovement: initialMovement);
        },
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (_, _) => const MovementsHistoryView(),
      ),
      GoRoute(
        path: '/movements/detail',
        builder: (_, _) => const MovementDetailView(),
      ),
      GoRoute(
        path: '/movements/filters',
        builder: (_, _) => const MovementFiltersView(),
      ),
      GoRoute(
        path: AppRoutes.reports,
        builder: (_, _) => const ReportsView(),
        routes: [
          GoRoute(
            path: 'weekly',
            builder: (_, _) => const WeeklyReportView(),
          ),
          GoRoute(
            path: 'monthly',
            builder: (_, _) => const MonthlyReportView(),
          ),
          GoRoute(
            path: 'quarterly',
            builder: (_, _) => const QuarterlyReportView(),
          ),
          GoRoute(
            path: 'annual',
            builder: (_, _) => const AnnualReportView(),
          ),
          GoRoute(
            path: 'categories',
            builder: (_, _) => const ExpensesByCategoryView(),
          ),
          GoRoute(
            path: 'evolution',
            builder: (_, _) => const PatrimonyEvolutionView(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.simulator,
        builder: (_, _) => const SimulatorView(),
        routes: [
          GoRoute(
            path: 'result',
            builder: (_, state) {
              final extra = state.extra;
              if (extra is! boveda_personal_simulation_data.SimulationData) {
                return const Scaffold(body: Center(child: Text('Error: Datos de simulación no encontrados')));
              }
              return SimulationResultView(data: extra);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.converter,
        builder: (_, _) => const ConverterView(),
      ),
      GoRoute(
        path: '/calculator',
        builder: (_, _) => const CalculatorView(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsView(),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (_, _) => const ProfileView(),
          ),
          GoRoute(
            path: 'about',
            builder: (_, _) => const AboutView(),
          ),
          GoRoute(
            path: 'password',
            builder: (_, _) => const ChangePasswordView(),
          ),
          GoRoute(
            path: 'currencies',
            builder: (_, _) => const CurrencyManagementView(),
          ),
          GoRoute(
            path: 'usd-rate',
            builder: (_, _) => const UpdateUsdRateView(),
          ),
        ],
      ),
    ],
  );
});
