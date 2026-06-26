import 'package:boveda_personal/app/router/app_router.dart';
import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _loadingController;
  late Animation<Offset> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _loadingAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(3.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    // Auto navigate to login after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Glow
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.wealth.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          // Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon Container
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceLow.withValues(alpha: 0.3),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.wealth.withValues(alpha: 0.1),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.wealth.withValues(alpha: 0.2)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.wealth.withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.lock_outline,
                            size: 64,
                            color: AppColors.wealth,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Bóveda Personal',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppColors.wealth,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Secure. Private. Essential.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Decorative Loading/Transition Line
          Positioned(
            bottom: 96,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: Container(
                  width: 192,
                  height: 1,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                  child: SlideTransition(
                    position: _loadingAnimation,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 64, // 1/3 of 192
                        height: 1,
                        decoration: BoxDecoration(
                          color: AppColors.wealth,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
