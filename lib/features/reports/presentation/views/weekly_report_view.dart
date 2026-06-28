import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:boveda_personal/features/reports/presentation/providers/weekly_report_provider.dart';

class WeeklyReportView extends ConsumerWidget {
  const WeeklyReportView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Reporte Semanal',
          style: TextStyle(
            color: AppColors.wealth,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 40),
          children: const [
            SizedBox(height: 12),
            _DateRangeSelector(),
            SizedBox(height: 24),
            _ChartSection(),
            SizedBox(height: 24),
            _SummaryCards(),
          ],
        ),
      ),
    );
  }
}

class _DateRangeSelector extends ConsumerWidget {
  const _DateRangeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startOfWeek = ref.watch(currentWeekStartProvider);
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    final dateFormat = DateFormat('d MMM', 'es');
    final yearFormat = DateFormat('yyyy', 'es');
    
    final dateString = '${dateFormat.format(startOfWeek)} - ${dateFormat.format(endOfWeek)}, ${yearFormat.format(endOfWeek)}';
    
    final now = DateTime.now();
    final currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    final isCurrentWeek = startOfWeek.year == currentWeekStart.year && 
                          startOfWeek.month == currentWeekStart.month && 
                          startOfWeek.day == currentWeekStart.day;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.onSurfaceVariant),
              onPressed: () {
                ref.read(currentWeekStartProvider.notifier).setDate(startOfWeek.subtract(const Duration(days: 7)));
              },
            ),
            Column(
              children: [
                Text(
                  dateString,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                ),
                Text(
                  isCurrentWeek ? 'Semana Actual' : 'Semana Pasada',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.chevron_right, color: isCurrentWeek ? AppColors.onSurfaceVariant.withValues(alpha: 0.3) : AppColors.onSurfaceVariant),
              onPressed: isCurrentWeek ? null : () {
                ref.read(currentWeekStartProvider.notifier).setDate(startOfWeek.add(const Duration(days: 7)));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartSection extends ConsumerWidget {
  const _ChartSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(weeklyReportProvider);
    
    return reportAsync.when(
      data: (data) {
        final symbol = data.displayCurrencyCode == 'USD' ? 'USD ' : '\$';
        final maxSavings = data.dailyNetSavings.fold(0.0, (m, v) => v > m ? v : m);
        final hasData = maxSavings > 0;
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            borderRadius: 24,
            child: Stack(
              children: [
                Positioned(
                  top: -40,
                  right: -40,
                  child: Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.wealth.withValues(alpha: 0.1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.wealth.withValues(alpha: 0.1),
                          blurRadius: 40,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AHORRO SEMANAL',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    letterSpacing: 1.5,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$symbol${data.netSavings.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppColors.wealth,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (int i = 0; i < 7; i++)
                            _ChartBar(
                              label: ['L', 'M', 'M', 'J', 'V', 'S', 'D'][i],
                              heightPct: hasData ? (data.dailyNetSavings[i] > 0 ? data.dailyNetSavings[i] / maxSavings : 0.05) : 0.05,
                              isHighlighted: hasData && data.dailyNetSavings[i] == maxSavings,
                              isDimmed: !hasData || data.dailyNetSavings[i] <= 0,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({
    required this.label,
    required this.heightPct,
    required this.isHighlighted,
    this.isDimmed = false,
  });

  final String label;
  final double heightPct;
  final bool isHighlighted;
  final bool isDimmed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 32,
          height: 140 * heightPct,
          decoration: BoxDecoration(
            color: AppColors.wealth.withValues(alpha: isDimmed ? 0.4 : 1.0),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: AppColors.wealth.withValues(alpha: 0.4),
                      blurRadius: 15,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isHighlighted ? AppColors.wealth : AppColors.onSurfaceVariant,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ],
    );
  }
}

class _SummaryCards extends ConsumerWidget {
  const _SummaryCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(weeklyReportProvider);
    
    return reportAsync.when(
      data: (data) {
        final symbol = data.displayCurrencyCode == 'USD' ? 'USD ' : '\$';
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumen Financiero',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      icon: Icons.south_west,
                      iconColor: AppColors.income,
                      label: 'Total Ingresos',
                      value: '+$symbol${data.totalIncome.toStringAsFixed(2)}',
                      valueColor: AppColors.income,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _MetricCard(
                      icon: Icons.north_east,
                      iconColor: AppColors.expense,
                      label: 'Total Gastos',
                      value: '-$symbol${data.totalExpense.toStringAsFixed(2)}',
                      valueColor: AppColors.expense,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GlassCard(
                padding: const EdgeInsets.all(20),
                backgroundColor: AppColors.wealth.withValues(alpha: 0.1),
                borderColor: AppColors.wealth.withValues(alpha: 0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.wealth.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.wealth.withValues(alpha: 0.3)),
                            ),
                            child: const Icon(Icons.account_balance_wallet, color: AppColors.wealth),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Neto de la Semana',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                        color: AppColors.onSurface,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Balance final disponible',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: AppColors.wealth.withValues(alpha: 0.8),
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${data.netSavings >= 0 ? '+' : ''}$symbol${data.netSavings.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.wealth,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: valueColor,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
