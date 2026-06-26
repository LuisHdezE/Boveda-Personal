import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          onPressed: () {},
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
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: const [
          SizedBox(height: 12),
          _DateRangeSelector(),
          SizedBox(height: 24),
          _ChartSection(),
          SizedBox(height: 24),
          _SummaryCards(),
        ],
      ),
    );
  }
}

class _DateRangeSelector extends StatelessWidget {
  const _DateRangeSelector();

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
            ),
            Column(
              children: [
                Text(
                  '14 Oct - 20 Oct, 2023',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                ),
                Text(
                  'Semana Actual',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
              onPressed: null, // Disabled in mockup
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        borderRadius: 24,
        child: Stack(
          children: [
            // Subtle glow
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
                          '\$4,250.00',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.wealth,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.wealth.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.trending_up, color: AppColors.wealth, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '+12%',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.wealth,
                                ),
                          ),
                        ],
                      ),
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
                      _ChartBar(label: 'L', heightPct: 0.3, isHighlighted: false),
                      _ChartBar(label: 'M', heightPct: 0.45, isHighlighted: false),
                      _ChartBar(label: 'M', heightPct: 0.2, isHighlighted: false),
                      _ChartBar(label: 'J', heightPct: 0.6, isHighlighted: false),
                      _ChartBar(label: 'V', heightPct: 0.85, isHighlighted: true),
                      _ChartBar(label: 'S', heightPct: 0.15, isHighlighted: false, isDimmed: true),
                      _ChartBar(label: 'D', heightPct: 0.1, isHighlighted: false, isDimmed: true),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

class _SummaryCards extends StatelessWidget {
  const _SummaryCards();

  @override
  Widget build(BuildContext context) {
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
                  value: '\$12,850.00',
                  valueColor: AppColors.income,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MetricCard(
                  icon: Icons.north_east,
                  iconColor: AppColors.expense,
                  label: 'Total Gastos',
                  value: '-\$8,600.00',
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
                Row(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Neto de la Semana',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppColors.onSurface,
                              ),
                        ),
                        Text(
                          'Balance final disponible',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.wealth.withValues(alpha: 0.8),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '+\$4,250',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.wealth,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
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
