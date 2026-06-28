import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/utils/currency_formatter.dart';
import 'package:boveda_personal/features/debts/presentation/providers/debts_provider.dart';
import 'package:boveda_personal/features/debts/presentation/providers/debts_stats_provider.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebtStatsView extends ConsumerWidget {
  const DebtStatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(debtStatsProvider);
    final debtsAsync = ref.watch(debtsProvider);

    return MainScaffold(
      title: 'Estadísticas de Deudas',
      showBackButton: true,
      showBottomNav: false,
      child: statsAsync.when(
        data: (stats) {
          if (stats.activeCount == 0) {
            return const Center(
              child: Text(
                'No hay deudas activas',
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + MediaQuery.paddingOf(context).bottom),
            children: [
              _TotalsCard(stats: stats),
              const SizedBox(height: 24),
              debtsAsync.when(
                data: (debts) => _ChartSection(
                  debts: debts.where((d) => d.isActive).toList(),
                  totalsRemainingByCurrency: stats.totalsRemainingByCurrency,
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

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.stats});
  final DebtStats stats;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet, color: AppColors.wealth),
              const SizedBox(width: 8),
              Text(
                'Resumen Global',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...stats.totalsOriginalByCurrency.entries.map((e) {
            final currency = e.key;
            final original = e.value;
            final remaining = stats.totalsRemainingByCurrency[currency]!;
            final paidMinor = original.minorUnits - remaining.minorUnits;
            
            final progress = original.minorUnits > 0 ? (paidMinor / original.minorUnits).clamp(0.0, 1.0) : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  Text(
                    'Moneda: $currency',
                    style: const TextStyle(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Deuda Total',
                        style: TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                      Text(
                        CurrencyFormatter.formatAmountNeutral(
                          original.minorUnits / 100,
                          currencyCode: original.currency.code,
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
                        'Pagado',
                        style: TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                      Text(
                        CurrencyFormatter.formatAmountNeutral(
                          paidMinor / 100,
                          currencyCode: original.currency.code,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.wealth,
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
                        'Restante',
                        style: TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                      Text(
                        CurrencyFormatter.formatAmountNeutral(
                          remaining.minorUnits / 100,
                          currencyCode: remaining.currency.code,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.expense,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.surface,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.wealth),
                      minHeight: 8,
                    ),
                  ),
                  const Divider(color: Colors.white10, height: 32),
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
  const _ChartSection({required this.debts, required this.totalsRemainingByCurrency});
  final List<dynamic> debts;
  final Map<String, dynamic> totalsRemainingByCurrency;

  @override
  State<_ChartSection> createState() => _ChartSectionState();
}

class _ChartSectionState extends State<_ChartSection> {
  String? selectedCurrency;
  
  @override
  void initState() {
    super.initState();
    if (widget.totalsRemainingByCurrency.isNotEmpty) {
      selectedCurrency = widget.totalsRemainingByCurrency.keys.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.totalsRemainingByCurrency.isEmpty || selectedCurrency == null) {
      return const SizedBox.shrink();
    }

    final currencies = widget.totalsRemainingByCurrency.keys.toList();
    final debtsInCurrency = widget.debts.where((d) => d.amount.currency.code == selectedCurrency && d.remainingAmount.minorUnits > 0).toList();
    
    final double totalMinor = widget.totalsRemainingByCurrency[selectedCurrency]!.minorUnits.toDouble();
    
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
                'Composición de Deuda',
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
          if (debtsInCurrency.isEmpty || totalMinor == 0)
            const Center(child: Text('Sin datos', style: TextStyle(color: AppColors.onSurfaceVariant)))
          else
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: debtsInCurrency.asMap().entries.map((entry) {
                    final index = entry.key;
                    final debt = entry.value;
                    
                    final pct = (debt.remainingAmount.minorUnits / totalMinor) * 100;
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
            children: debtsInCurrency.asMap().entries.map((entry) {
              final index = entry.key;
              final debt = entry.value;
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
                    debt.name,
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
