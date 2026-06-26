import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnnualReportView extends ConsumerWidget {
  const AnnualReportView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainScaffold(
      title: 'Reporte Anual',
      showBottomNav: true,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: const [
          _PeriodSelector(),
          SizedBox(height: 24),
          _AnnualSummary(),
          SizedBox(height: 24),
          _AnnualChart(),
          SizedBox(height: 24),
          _MilestonesGrid(),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                'PERIODO',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 2,
                    ),
              ),
              Text(
                '2023',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _AnnualSummary extends StatelessWidget {
  const _AnnualSummary();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.wealth.withValues(alpha: 0.1),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                'Patrimonio Final Anual',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '\$142,500',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.wealth,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    '.00',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.wealth.withValues(alpha: 0.6),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.income.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.income.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up, color: AppColors.income, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '+18.4% vs 2022',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.income,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnnualChart extends StatelessWidget {
  const _AnnualChart();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Flujo Mensual',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
              const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(color: AppColors.income, label: 'Ingresos'),
              const SizedBox(width: 16),
              _LegendItem(color: AppColors.expense, label: 'Gastos'),
              const SizedBox(width: 16),
              _LegendItem(color: AppColors.wealth, label: 'Ahorro'),
            ],
          ),
          const SizedBox(height: 24),
          // Chart placeholder
          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _ChartColumn(label: 'E', inc: 60, exp: 40, sav: 20),
                _ChartColumn(label: 'F', inc: 65, exp: 45, sav: 20),
                _ChartColumn(label: 'M', inc: 70, exp: 35, sav: 35),
                _ChartColumn(label: 'A', inc: 60, exp: 50, sav: 10),
                _ChartColumn(label: 'M', inc: 80, exp: 40, sav: 40),
                _ChartColumn(label: 'J', inc: 65, exp: 45, sav: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _ChartColumn extends StatelessWidget {
  const _ChartColumn({
    required this.label,
    required this.inc,
    required this.exp,
    required this.sav,
  });

  final String label;
  final double inc;
  final double exp;
  final double sav;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Bar(color: AppColors.income, heightPct: inc),
              const SizedBox(width: 2),
              _Bar(color: AppColors.expense, heightPct: exp),
              const SizedBox(width: 2),
              _Bar(color: AppColors.wealth, heightPct: sav),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.color, required this.heightPct});

  final Color color;
  final double heightPct;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: (160 * (heightPct / 100)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color,
            color.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
      ),
    );
  }
}

class _MilestonesGrid extends StatelessWidget {
  const _MilestonesGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hitos del Año',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.onSurface,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _MilestoneCard(
                icon: Icons.emoji_events,
                iconColor: AppColors.wealth,
                title: 'Mayor Ahorro',
                value: 'Mayo',
                subtitle: '\$4,200',
                subtitleColor: AppColors.wealth,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _MilestoneCard(
                icon: Icons.home,
                iconColor: AppColors.expense,
                title: 'Gasto Dominante',
                value: 'Vivienda',
                subtitle: '35% del total',
                subtitleColor: AppColors.expense,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.income.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.show_chart, color: AppColors.income),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingreso Anual',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                    Text(
                      '\$85,000',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.onSurface,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+12.5%',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.income,
                        ),
                  ),
                  Text(
                    'vs 2022',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.subtitleColor,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: subtitleColor,
                ),
          ),
        ],
      ),
    );
  }
}
