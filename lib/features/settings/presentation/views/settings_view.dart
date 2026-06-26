import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainScaffold(
      title: 'Configuración',
      showBackButton: true,
      showBottomNav: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          Text(
            'Gestiona tus preferencias y seguridad.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          _SettingsGroup(
            title: 'CUENTA',
            children: [
              _SettingsItem(
                icon: Icons.person_outline,
                title: 'Perfil',
                subtitle: 'Información personal',
                onTap: () => context.push('/settings/profile'),
              ),
              _SettingsItem(
                icon: Icons.key_outlined,
                title: 'Cambio de contraseña',
                subtitle: 'Actualizar credenciales',
                onTap: () => context.push('/settings/password'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsGroup(
            title: 'PREFERENCIAS',
            children: [
              _SettingsItem(
                icon: Icons.payments_outlined,
                title: 'Moneda principal',
                subtitle: 'USD (\$)',
                subtitleColor: AppColors.wealth,
                onTap: () => context.push('/settings/currencies'),
              ),
              _SettingsItem(
                icon: Icons.language_outlined,
                title: 'Idioma',
                subtitle: 'Español',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsGroup(
            title: 'SEGURIDAD',
            children: [
              _SettingsItem(
                icon: Icons.fingerprint,
                iconColor: AppColors.wealth,
                title: 'Biometría',
                subtitle: 'Usar Face ID / Touch ID',
                trailing: Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: AppColors.wealth,
                ),
              ),
              _SettingsItem(
                icon: Icons.lock_clock_outlined,
                title: 'Bloqueo automático',
                subtitle: 'Inmediato',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsGroup(
            title: 'ACERCA DE',
            children: [
              _SettingsItem(
                icon: Icons.info_outline,
                title: 'Acerca de',
                subtitle: 'Versión 2.4.1',
                onTap: () => context.push('/settings/about'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: AppColors.expense),
              label: Text(
                'Cerrar Sesión',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.expense,
                    ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.expense.withValues(alpha: 0.2)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.wealth,
                  letterSpacing: 1.5,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    this.iconColor,
    required this.title,
    required this.subtitle,
    this.subtitleColor,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final Color? subtitleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: subtitleColor ?? AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (onTap != null)
            const Icon(
              Icons.chevron_right,
              color: AppColors.onSurfaceVariant,
            ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: content,
      );
    }

    return content;
  }
}
