import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
import 'package:boveda_personal/features/dashboard/presentation/providers.dart';
import 'package:boveda_personal/features/movements/presentation/providers.dart';

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
              Consumer(
                builder: (context, ref, _) {
                  final settingsAsync = ref.watch(appSettingsProvider);
                  return settingsAsync.when(
                    data: (settings) {
                      final secCode = settings?.secondaryCurrencyCode ?? 'CUP';
                      return _SettingsItem(
                        icon: Icons.currency_exchange,
                        title: 'Moneda secundaria',
                        subtitle: secCode,
                        subtitleColor: AppColors.wealth,
                        onTap: () => _showSecondaryCurrencyPicker(context, ref),
                      );
                    },
                    loading: () => const _SettingsItem(
                      icon: Icons.currency_exchange,
                      title: 'Moneda secundaria',
                      subtitle: 'Cargando...',
                    ),
                    error: (_, __) => const SizedBox(),
                  );
                },
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

  void _showSecondaryCurrencyPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceHigh,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final currenciesAsync = ref.watch(calculatorCurrenciesProvider);
            return currenciesAsync.when(
              data: (currencies) {
                // Ignore USD for secondary currency
                final list = currencies.where((c) => c.currency.code != 'USD' && c.isActive).toList();
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Seleccionar Moneda Secundaria',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.onSurface,
                              ),
                        ),
                      ),
                      const Divider(color: Colors.white10),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final currency = list[index];
                            return ListTile(
                              leading: Text(
                                currency.symbol,
                                style: const TextStyle(fontSize: 20, color: AppColors.wealth),
                              ),
                              title: Text(currency.name, style: const TextStyle(color: AppColors.onSurface)),
                              subtitle: Text(currency.currency.code, style: const TextStyle(color: AppColors.onSurfaceVariant)),
                              onTap: () async {
                                  final settings = await ref.read(appSettingsProvider.future);
                                  if (settings != null) {
                                    final newSettings = settings.copyWith(secondaryCurrencyCode: currency.currency.code);
                                    await ref.read(settingsRepositoryProvider).save(newSettings);
                                    
                                    // Update the secondary account in the database
                                    final accountRepo = ref.read(accountRepositoryProvider);
                                    final accounts = await accountRepo.list();
                                    final secondaryAccount = accounts.firstWhere((a) => a.currency.code != 'USD', orElse: () => accounts.last);
                                    
                                    if (secondaryAccount.currency.code != currency.currency.code) {
                                      await accountRepo.updateCurrency(
                                        secondaryAccount.id,
                                        currencyCode: currency.currency.code,
                                        currencyScale: currency.currency.scale,
                                      );
                                    }

                                    ref.invalidate(appSettingsProvider);
                                    ref.invalidate(accountBalancesProvider);
                                    ref.invalidate(dashboardSummaryProvider);
                                    ref.invalidate(movementsProvider);
                                  }
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              )),
              error: (_, __) => const Center(child: Text('Error al cargar monedas', style: TextStyle(color: Colors.red))),
            );
          },
        );
      },
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
