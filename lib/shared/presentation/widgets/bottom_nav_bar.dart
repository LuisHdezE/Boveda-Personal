import 'dart:ui';
import 'package:boveda_personal/app/router/app_router.dart';
import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.movement)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.history)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.reports)) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
        break;
      case 1:
        context.go(AppRoutes.history);
        break;
      case 2:
        context.go(AppRoutes.movement);
        break;
      case 3:
        context.go(AppRoutes.reports);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceLowest.withValues(alpha: 0.8),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (idx) => _onItemTapped(idx, context),
            backgroundColor: Colors.transparent,
            indicatorColor: AppColors.wealth.withValues(alpha: 0.2),
            elevation: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home, color: AppColors.wealth),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history, color: AppColors.wealth),
                label: 'Históricos',
              ),
              NavigationDestination(
                icon: Icon(Icons.add_circle_outline),
                selectedIcon: Icon(Icons.add_circle, color: AppColors.wealth),
                label: 'Nuevo',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart, color: AppColors.wealth),
                label: 'Reportes',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
