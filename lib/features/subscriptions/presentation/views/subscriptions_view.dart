import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/utils/currency_formatter.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/subscriptions/presentation/providers/subscriptions_provider.dart';
import 'package:boveda_personal/features/subscriptions/presentation/providers/subscriptions_stats_provider.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SubscriptionsView extends ConsumerWidget {
  const SubscriptionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionsAsync = ref.watch(subscriptionsProvider);
    final statsAsync = ref.watch(subscriptionStatsProvider);

    return MainScaffold(
      title: 'Suscripciones',
      showBackButton: true,
      showBottomNav: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.pie_chart, color: AppColors.onSurface),
          onPressed: () {
            context.push('/subscriptions/stats');
          },
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/subscriptions/new');
        },
        backgroundColor: AppColors.wealth,
        child: const Icon(Icons.add, color: AppColors.surfaceHighest),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: statsAsync.when(
                data: (stats) {
                  return GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resumen Mensual (Aprox)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (stats.totalsMonthlyByCurrency.isEmpty)
                          const Text(
                            'No hay suscripciones activas',
                            style: TextStyle(color: AppColors.onSurfaceVariant),
                          )
                        else
                          ...stats.totalsMonthlyByCurrency.entries.map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total en ${e.key}',
                                    style: const TextStyle(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.formatAmountNeutral(e.value.minorUnits / 100, currencyCode: e.value.currency.code),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Text('Error: $err'),
              ),
            ),
          ),
          subscriptionsAsync.when(
            data: (subscriptions) {
              if (subscriptions.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No tienes suscripciones',
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final sub = subscriptions[index];
                  final now = DateTime.now();
                  final isPaidThisMonth =
                      sub.lastPaymentDate != null &&
                      sub.lastPaymentDate!.year == now.year &&
                      sub.lastPaymentDate!.month == now.month;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: GlassCard(
                      child: ListTile(
                        title: Text(
                          sub.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onSurface,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${CurrencyFormatter.formatAmountNeutral(sub.amount.minorUnits / 100, currencyCode: sub.amount.currency.code)} / ${sub.billingCycle}',
                            ),
                            Text(
                              'Próximo cobro: ${sub.nextBillingDate.day}/${sub.nextBillingDate.month}/${sub.nextBillingDate.year}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                color: AppColors.onSurfaceVariant,
                              ),
                              onSelected: (value) async {
                                if (value == 'edit') {
                                  context.push('/subscriptions/edit', extra: sub);
                                } else if (value == 'delete') {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Eliminar suscripción'),
                                      content: const Text('¿Estás seguro de que deseas eliminar esta suscripción? (No se eliminarán los movimientos ya registrados).'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: const Text('Eliminar', style: TextStyle(color: AppColors.expense)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await ref.read(subscriptionsProvider.notifier).deleteSubscription(sub.id);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Suscripción eliminada')),
                                      );
                                    }
                                  }
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: AppColors.onSurface),
                                      SizedBox(width: 8),
                                      Text('Editar'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: AppColors.expense),
                                      SizedBox(width: 8),
                                      Text('Eliminar', style: TextStyle(color: AppColors.expense)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: isPaidThisMonth
                                  ? null
                                  : () async {
                                      final accountRepo = ref.read(accountRepositoryProvider);
                                      final allAccounts = await accountRepo.list(activeOnly: true);
                                      final accounts = allAccounts.where((a) => a.currency.code == sub.amount.currency.code).toList();
                                      
                                      if (accounts.isEmpty && context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('No hay cuentas activas en la moneda de la suscripción.')),
                                        );
                                        return;
                                      }
                                        final selectedAccountId =
                                            await showDialog<String>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Pagar Suscripción',
                                                  ),
                                                  content: SizedBox(
                                                    width: double.maxFinite,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          accounts.length,
                                                      itemBuilder:
                                                          (context, i) {
                                                            final account = accounts[i];
                                                            return ListTile(
                                                              title: Text(
                                                                account.name,
                                                              ),
                                                              onTap: () {
                                                                Navigator.of(
                                                                  context,
                                                                ).pop(
                                                                  account.id,
                                                                );
                                                              },
                                                            );
                                                          },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );

                                        if (selectedAccountId != null) {
                                          try {
                                            await ref
                                                .read(
                                                  subscriptionsProvider
                                                      .notifier,
                                                )
                                                .paySubscription(
                                                  sub,
                                                  selectedAccountId,
                                                );
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${sub.name} pagada!',
                                                  ),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(e.toString().replaceAll('Exception: ', '')),
                                                ),
                                              );
                                            }
                                          }
                                        }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isPaidThisMonth
                                    ? AppColors.surface
                                    : AppColors.wealth,
                                foregroundColor: isPaidThisMonth
                                    ? AppColors.onSurfaceVariant
                                    : AppColors.surfaceHighest,
                              ),
                              child: Text(isPaidThisMonth ? 'Pagado' : 'Pagar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }, childCount: subscriptions.length),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) =>
                SliverFillRemaining(child: Center(child: Text('Error: $err'))),
          ),
        ],
      ),
    );
  }
}
