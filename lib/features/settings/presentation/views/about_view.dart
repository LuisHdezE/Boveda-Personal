import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Acerca de',
      showBackButton: true,
      showBottomNav: false,
      child: Stack(
        children: [
          // Ambient Glow
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 2 - 128,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.wealth.withValues(alpha: 0.1),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            children: [
              // Logo & App Info Section
              Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.wealth.withValues(alpha: 0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.wealth.withValues(alpha: 0.15),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.account_balance_wallet,
                      size: 48,
                      color: AppColors.wealth,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Bóveda Personal',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'VERSIÓN 1.0.0',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.wealth,
                          letterSpacing: 2.0,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Una solución elegante y segura para la gestión financiera offline. Diseñada para mantener la privacidad total de tus datos utilizando almacenamiento local SQLite de alto rendimiento.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              // Links Section
              _AboutLink(
                icon: Icons.gavel,
                title: 'Términos y Condiciones',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _AboutLink(
                icon: Icons.shield_outlined,
                title: 'Política de Privacidad',
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _AboutLink(
                icon: Icons.info_outline,
                title: 'Créditos y Licencias',
                onTap: () {},
              ),
              const SizedBox(height: 48),
              // Footer Logo
              const Center(
                child: Opacity(
                  opacity: 0.5,
                  child: Icon(
                    Icons.offline_bolt,
                    color: AppColors.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutLink extends StatelessWidget {
  const _AboutLink({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.wealth.withValues(alpha: 0.7)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
