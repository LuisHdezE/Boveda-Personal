import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/utils/currency_formatter.dart';
import 'package:boveda_personal/features/subscriptions/presentation/providers/subscriptions_provider.dart';
import 'package:boveda_personal/features/subscriptions/presentation/providers/subscriptions_stats_provider.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionStatsView extends ConsumerWidget {
  const SubscriptionStatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(subscriptionStatsProvider);
    final subsAsync = ref.watch(subscriptionsProvider);

    return MainScaffold(
      title: 'Estadísticas',
      showBackButton: true,
      showBottomNav: false,
      child: statsAsync.when(
        data: (stats) {
          if (stats.activeCount == 0) {
            return const Center(
              child: Text(
                'No hay suscripciones activas',
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + MediaQuery.paddingOf(context).bottom),
            children: [
              _ProjectionsCard(stats: stats),
              const SizedBox(height: 24),
              if (stats.mostExpensiveSubscription != null) ...[
                _MostExpensiveCard(stats: stats),
                const SizedBox(height: 24),
              ],
              _CycleDistributionCard(stats: stats),
              const SizedBox(height: 24),
              subsAsync.when(
                data: (subs) => _ChartSection(
                  subs: subs.where((s) => s.isActive).toList(),
                  totalsMonthlyByCurrency: stats.totalsMonthlyByCurrency,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => const SizedBox.shrink(),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ProjectionsCard extends StatelessWidget {
  const _ProjectionsCard({required this.stats});
  final SubscriptionStats stats;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.wealth),
              const SizedBox(width: 8),
              Text(
                'Proyección de Gastos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...stats.totalsMonthlyByCurrency.entries.map((e) {
            final currency = e.key;
            final monthly = e.value;
            final yearly = stats.totalsYearlyByCurrency[currency]!;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Mensual',
                        style: TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                      Text(
                        CurrencyFormatter.formatAmountNeutral(
                          monthly.minorUnits / 100,
                          currencyCode: monthly.currency.code,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Anual',
                        style: TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                      Text(
                        CurrencyFormatter.formatAmountNeutral(
                          yearly.minorUnits / 100,
                          currencyCode: yearly.currency.code,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.expense,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 24),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MostExpensiveCard extends StatelessWidget {
  const _MostExpensiveCard({required this.stats});
  final SubscriptionStats stats;

  @override
  Widget build(BuildContext context) {
    final sub = stats.mostExpensiveSubscription!;
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'Mayor Gasto Individual',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  sub.name,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${CurrencyFormatter.formatAmountNeutral(sub.amount.minorUnits / 100, currencyCode: sub.amount.currency.code)} / ${sub.billingCycle == 'monthly' ? 'mes' : sub.billingCycle == 'yearly' ? 'año' : sub.billingCycle}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.expense,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CycleDistributionCard extends StatelessWidget {
  const _CycleDistributionCard({required this.stats});
  final SubscriptionStats stats;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month, color: AppColors.information),
              const SizedBox(width: 8),
              Text(
                'Distribución por Ciclo',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...stats.cycleDistribution.entries.map((e) {
            String label = e.key;
            if (label == 'monthly') label = 'Mensuales';
            if (label == 'yearly') label = 'Anuales';
            if (label == 'weekly') label = 'Semanales';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                  Text(
                    '${e.value}',
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
  }
}

class _ChartSection extends StatefulWidget {
  const _ChartSection({required this.subs, required this.totalsMonthlyByCurrency});
  final List<dynamic> subs; // dynamic for quick prototyping, will use Subscription
  final Map<String, dynamic> totalsMonthlyByCurrency;

  @override
  State<_ChartSection> createState() => _ChartSectionState();
}

class _ChartSectionState extends State<_ChartSection> {
  String? selectedCurrency;
  
  @override
  void initState() {
    super.initState();
    if (widget.totalsMonthlyByCurrency.isNotEmpty) {
      selectedCurrency = widget.totalsMonthlyByCurrency.keys.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.totalsMonthlyByCurrency.isEmpty || selectedCurrency == null) {
      return const SizedBox.shrink();
    }

    final currencies = widget.totalsMonthlyByCurrency.keys.toList();
    final subsInCurrency = widget.subs.where((s) => s.amount.currency.code == selectedCurrency).toList();
    
    // Calculate percentages
    final double totalMinor = widget.totalsMonthlyByCurrency[selectedCurrency]!.minorUnits.toDouble();
    
    final List<Color> colors = [
      AppColors.information,
      AppColors.expense,
      AppColors.wealth,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Composición',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (currencies.length > 1)
                DropdownButton<String>(
                  value: selectedCurrency,
                  dropdownColor: AppColors.surfaceHigh,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.onSurfaceVariant),
                  style: const TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold),
                  items: currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedCurrency = val);
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (subsInCurrency.isEmpty)
            const Center(child: Text('Sin datos', style: TextStyle(color: AppColors.onSurfaceVariant)))
          else
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: subsInCurrency.asMap().entries.map((entry) {
                    final index = entry.key;
                    final sub = entry.value;
                    
                    double factor = 1.0;
                    if (sub.billingCycle == 'yearly') factor = 1 / 12;
                    if (sub.billingCycle == 'weekly') factor = 4.33;
                    final monthlyMinor = (sub.amount.minorUnits * factor).round();
                    
                    final pct = (monthlyMinor / totalMinor) * 100;
                    final color = colors[index % colors.length];

                    return PieChartSectionData(
                      color: color,
                      value: pct,
                      title: '${pct.toStringAsFixed(1)}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          const SizedBox(height: 24),
          // Legend
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: subsInCurrency.asMap().entries.map((entry) {
              final index = entry.key;
              final sub = entry.value;
              final color = colors[index % colors.length];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    sub.name,
                    style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
