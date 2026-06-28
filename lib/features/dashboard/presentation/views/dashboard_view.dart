import 'package:boveda_personal/app/router/app_router.dart';
import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/dashboard/presentation/providers.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
import 'package:boveda_personal/shared/presentation/widgets/expandable_fab.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:boveda_personal/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainScaffold(
      title: 'Bóveda Personal',
      floatingActionButton: ExpandableFab(
        distance: 72.0,
        children: [
          FloatingActionButton.small(
            heroTag: 'calc_fab',
            backgroundColor: AppColors.surfaceHigh,
            onPressed: () => context.push('/calculator'),
            child: const Icon(Icons.calculate_outlined, color: AppColors.wealth),
          ),
          FloatingActionButton.small(
            heroTag: 'conv_fab',
            backgroundColor: AppColors.surfaceHigh,
            onPressed: () => context.push('/converter'),
            child: const Icon(Icons.currency_exchange_outlined, color: AppColors.wealth),
          ),
          FloatingActionButton.small(
            heroTag: 'sim_fab',
            backgroundColor: AppColors.surfaceHigh,
            onPressed: () => context.push('/simulator'),
            child: const Icon(Icons.analytics_outlined, color: AppColors.wealth),
          ),
          FloatingActionButton.small(
            heroTag: 'debts_fab',
            backgroundColor: AppColors.surfaceHigh,
            onPressed: () => context.push('/debts'),
            child: const Icon(Icons.money_off_outlined, color: AppColors.wealth),
          ),
          FloatingActionButton.small(
            heroTag: 'subs_fab',
            backgroundColor: AppColors.surfaceHigh,
            onPressed: () => context.push('/subscriptions'),
            child: const Icon(Icons.event_repeat_outlined, color: AppColors.wealth),
          ),
        ],
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: const [
          _BalanceCard(),
          SizedBox(height: 24),
          _SummaryRow(),
          SizedBox(height: 24),
          _ChartSection(),
          SizedBox(height: 24),
          _RecentMovementsSection(),
          SizedBox(height: 120), // Padding for bottom nav bar
        ],
      ),
    );
  }
}

class _BalanceCard extends ConsumerStatefulWidget {
  const _BalanceCard();

  @override
  ConsumerState<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends ConsumerState<_BalanceCard> {
  @override
  Widget build(BuildContext context) {
    final balancesAsync = ref.watch(accountBalancesProvider);
    final settingsAsync = ref.watch(appSettingsProvider);
    final currenciesAsync = ref.watch(calculatorCurrenciesProvider);
    final _showInSecondary = ref.watch(showInSecondaryProvider);

    return GlassCard(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.wealth.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SALDO TOTAL',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 2,
                          ),
                    ),
                    InkWell(
                      onTap: () {
                        ref.read(showInSecondaryProvider.notifier).toggle();
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.wealth.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Icon(
                          Icons.swap_horiz,
                          color: AppColors.wealth,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Dynamic Balance Calculation
                Builder(builder: (context) {
                  if (balancesAsync.isLoading || settingsAsync.isLoading || currenciesAsync.isLoading) {
                    return const CircularProgressIndicator(strokeWidth: 2);
                  }

                  final balances = balancesAsync.asData?.value ?? [];
                  final settings = settingsAsync.asData?.value;
                  final currencies = currenciesAsync.asData?.value ?? [];

                  if (settings == null || currencies.isEmpty) {
                    return Text('...', style: Theme.of(context).textTheme.displayLarge);
                  }

                  double totalUsd = 0.0;

                  for (final b in balances) {
                    final currInfo = currencies.firstWhere(
                      (c) => c.currency.code == b.currency.code,
                      orElse: () => currencies.first,
                    );
                    final unitsPerUsd = currInfo.unitsPerUsd.toDouble();
                    final amount = b.balance.minorUnits / 100.0;
                    if (unitsPerUsd > 0) {
                      totalUsd += amount / unitsPerUsd;
                    }
                  }

                  String displayCode = 'USD';
                  double displayAmount = totalUsd;

                  if (_showInSecondary) {
                    displayCode = settings.secondaryCurrencyCode ?? 'CUP';
                    final targetCurrInfo = currencies.firstWhere(
                      (c) => c.currency.code == displayCode,
                      orElse: () => currencies.first,
                    );
                    displayAmount = totalUsd * targetCurrInfo.unitsPerUsd.toDouble();
                  }

                  final formattedBalance = CurrencyFormatter.formatAmountNeutral(displayAmount, currencyCode: displayCode);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          formattedBalance,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: AppColors.wealth,
                              ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 24),
                balancesAsync.when(
                  data: (balances) {
                    if (balances.isEmpty) {
                      return Text('No hay cuentas configuradas.', style: Theme.of(context).textTheme.bodyMedium);
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: balances.map((b) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: _CurrencyBalance(
                              currency: b.currency.code,
                              amount: '\$${(b.balance.minorUnits / 100).toStringAsFixed(2)}',
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const Text('Error cargando saldos'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyBalance extends StatelessWidget {
  const _CurrencyBalance({
    required this.currency,
    required this.amount,
  });

  final String currency;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          currency,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
        const SizedBox(width: 8),
        Text(
          amount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _SummaryRow extends ConsumerWidget {
  const _SummaryRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final showInSecondary = ref.watch(showInSecondaryProvider);
    final settings = ref.watch(appSettingsProvider).value;
    
    return summaryAsync.when(
      data: (summary) {
        final incomeAmount = summary.income / 100;
        final expenseAmount = summary.expense / 100;
        final savingsAmount = incomeAmount - expenseAmount;
        return Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.arrow_upward,
                iconColor: AppColors.income,
                title: 'Ingresos',
                amount: CurrencyFormatter.formatAmount(incomeAmount, currencyCode: showInSecondary ? settings?.secondaryCurrencyCode : 'USD'),
                amountColor: AppColors.income,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryCard(
                icon: Icons.arrow_downward,
                iconColor: AppColors.expense,
                title: 'Gastos',
                amount: CurrencyFormatter.formatAmount(-expenseAmount, currencyCode: showInSecondary ? settings?.secondaryCurrencyCode : 'USD'),
                amountColor: AppColors.expense,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _SummaryCard(
                icon: Icons.savings,
                iconColor: AppColors.onSurface,
                title: 'Ahorro',
                amount: CurrencyFormatter.formatAmountNeutral(savingsAmount, currencyCode: showInSecondary ? settings?.secondaryCurrencyCode : 'USD'),
                amountColor: AppColors.onSurface,
                onTap: () {},
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.amount,
    required this.amountColor,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String amount;
  final Color amountColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _ChartSection extends ConsumerWidget {
  const _ChartSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wealthAsync = ref.watch(wealthEvolutionProvider);
    final showInSecondary = ref.watch(showInSecondaryProvider);
    final settingsAsync = ref.watch(appSettingsProvider);

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Evolución del Patrimonio',
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '30 Días',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          Container(
            height: 160,
            width: double.infinity,
            padding: const EdgeInsets.only(right: 20, left: 10, top: 20, bottom: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.wealth.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
            child: wealthAsync.when(
              data: (points) {
                if (points.isEmpty) return const SizedBox.shrink();

                final spots = points.asMap().entries.map((e) {
                  return FlSpot(e.key.toDouble(), e.value.balance);
                }).toList();
                
                double minY = points.map((p) => p.balance).reduce((a, b) => a < b ? a : b);
                double maxY = points.map((p) => p.balance).reduce((a, b) => a > b ? a : b);
                if (minY == maxY) {
                   minY -= 100;
                   maxY += 100;
                }
                final diff = maxY - minY;
                minY -= diff * 0.2;
                maxY += diff * 0.2;

                return LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          interval: 7,
                          getTitlesWidget: (value, meta) {
                            if (value == meta.min || value == meta.max || value.toInt() >= points.length) {
                              return const SizedBox.shrink();
                            }
                            final date = points[value.toInt()].date;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${date.day} ${_getShortMonth(date.month)}',
                                style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            if (value == meta.min || value == meta.max) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                CurrencyFormatter.formatAmountNeutral(
                                  value,
                                  currencyCode: showInSecondary ? settingsAsync.value?.secondaryCurrencyCode : 'USD',
                                ),
                                style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 29,
                    minY: minY,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: AppColors.wealth,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.wealth.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => AppColors.surfaceHigh,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final date = points[spot.x.toInt()].date;
                            final val = CurrencyFormatter.formatAmountNeutral(
                              spot.y, 
                              currencyCode: showInSecondary ? settingsAsync.value?.secondaryCurrencyCode : 'USD'
                            );
                            return LineTooltipItem(
                              '${date.day}/${date.month}\n$val',
                              const TextStyle(color: AppColors.onSurface, fontSize: 12),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentMovementsSection extends ConsumerWidget {
  const _RecentMovementsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentMovementsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Movimientos Recientes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.history),
              child: Text(
                'Ver todos',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.wealth,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        recentAsync.when(
          data: (movements) {
            if (movements.isEmpty) {
              return Center(
                child: Text('No hay movimientos recientes', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
              );
            }
            return Column(
              children: movements.map((m) {
                final isExpense = m.type == MovementType.expense;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _MovementTile(
                    icon: isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                    title: m.note ?? (isExpense ? 'Gasto' : 'Ingreso'),
                    category: 'Movimiento', // TODO: Fetch category name
                    amount: CurrencyFormatter.formatAmount(isExpense ? -(m.amount.minorUnits / 100) : (m.amount.minorUnits / 100), currencyCode: m.amount.currency.code),
                    isExpense: isExpense,
                    movement: m,
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        ),
      ],
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({
    required this.icon,
    required this.title,
    required this.category,
    required this.amount,
    required this.isExpense,
    required this.movement,
  });

  final IconData icon;
  final String title;
  final String category;
  final String amount;
  final bool isExpense;
  final Movement movement;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      onTap: () => context.push('/movements/detail', extra: movement),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Icon(
              icon,
              color: AppColors.onSurfaceVariant,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  category,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${movement.occurredAt.day} ${_getShortMonth(movement.occurredAt.month)} ${movement.occurredAt.year}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isExpense ? AppColors.expense : AppColors.income,
                ),
          ),
        ],
      ),
    );
  }
}

String _getShortMonth(int month) {
  const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
  if (month >= 1 && month <= 12) return months[month - 1];
  return '';
}
