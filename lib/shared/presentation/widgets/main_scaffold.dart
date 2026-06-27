import 'package:boveda_personal/app/router/app_router.dart';
import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.child,
    this.showBottomNav = true,
    this.title = 'Bóveda Personal',
    this.showBackButton = false,
    this.floatingActionButton,
  });

  final Widget child;
  final bool showBottomNav;
  final String title;
  final bool showBackButton;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // For glassmorphism over bottom nav
      appBar: AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.wealth,
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.dashboard);
                  }
                },
              )
            : IconButton(
                icon: const Icon(Icons.menu, color: AppColors.onSurfaceVariant),
                onPressed: () => context.push(AppRoutes.settings),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                context.push('/settings/profile');
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.surfaceHigh,
                child: Icon(Icons.person, size: 20, color: AppColors.outline),
              ),
            ),
          )
        ],
      ),
      body: child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNav ? const BottomNavBar() : null,
    );
  }
}
