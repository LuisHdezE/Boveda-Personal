import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/features/reports/presentation/providers/patrimony_evolution_provider.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _monthNames = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

class PatrimonyEvolutionView extends ConsumerWidget {
  const PatrimonyEvolutionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedYear = ref.watch(patrimonyYearProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Evolución Patrimonial',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _YearSelector(selectedYear: selectedYear),
          const SizedBox(height: 24),
          const _SummaryCard(),
          const SizedBox(height: 24),
          const _EvolutionChartCard(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _YearSelector extends ConsumerWidget {
  const _YearSelector({required this.selectedYear});
  final int selectedYear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentYear = DateTime.now().year;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.onSurfaceVariant),
            onPressed: () => ref.read(patrimonyYearProvider.notifier).setYear(selectedYear - 1),
          ),
          Text(
            'Año $selectedYear',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.onSurface),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: selectedYear >= currentYear
                  ? AppColors.onSurfaceVariant.withValues(alpha: 0.3)
                  : AppColors.onSurfaceVariant,
            ),
            onPressed: selectedYear >= currentYear
                ? null
                : () => ref.read(patrimonyYearProvider.notifier).setYear(selectedYear + 1),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends ConsumerWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(patrimonyEvolutionHistoryProvider);

    return reportAsync.when(
      loading: () => const GlassCard(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => GlassCard(
        padding: const EdgeInsets.all(24),
        child: Text('Error: $e'),
      ),
      data: (report) {
        final isPositive = report.growthPercentage >= 0;
        final growthText = '${isPositive ? '+' : ''}${report.growthPercentage.toStringAsFixed(1)}% este año';

        return GlassCard(
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.15),
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
                  Text(
                    'Patrimonio Actual',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${report.displayCurrencyCode} ${report.currentPatrimony.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPositive
                              ? AppColors.income.withValues(alpha: 0.1)
                              : AppColors.expense.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isPositive
                                ? AppColors.income.withValues(alpha: 0.3)
                                : AppColors.expense.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isPositive ? Icons.trending_up : Icons.trending_down,
                              color: isPositive ? AppColors.income : AppColors.expense,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              growthText,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: isPositive ? AppColors.income : AppColors.expense,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EvolutionChartCard extends ConsumerWidget {
  const _EvolutionChartCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(patrimonyEvolutionHistoryProvider);

    return reportAsync.when(
      loading: () => const GlassCard(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => GlassCard(
        padding: const EdgeInsets.all(24),
        child: Text('Error: $e'),
      ),
      data: (report) {
        if (report.points.isEmpty) {
          return GlassCard(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.show_chart, size: 48, color: AppColors.onSurfaceVariant),
                  const SizedBox(height: 8),
                  Text(
                    'Sin datos para este año',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        final spots = report.points
            .map((p) => FlSpot((p.month - 1).toDouble(), p.balance))
            .toList();

        double minY = report.points.map((p) => p.balance).reduce((a, b) => a < b ? a : b);
        double maxY = report.points.map((p) => p.balance).reduce((a, b) => a > b ? a : b);
        if (minY == maxY) { minY -= 100; maxY += 100; }
        final diff = maxY - minY;
        minY -= diff * 0.15;
        maxY += diff * 0.15;

        return GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Curva de Crecimiento',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                        ),
                  ),
                  const Icon(Icons.show_chart, color: AppColors.secondary),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => const FlLine(
                        color: Colors.white10,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= 12) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _monthNames[idx],
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
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value >= 1000
                                  ? '${(value / 1000).toStringAsFixed(1)}k'
                                  : value.toStringAsFixed(0),
                              style: const TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (report.points.length - 1).toDouble(),
                    minY: minY,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: AppColors.secondary,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                            radius: 3,
                            color: AppColors.secondary,
                            strokeColor: AppColors.background,
                            strokeWidth: 1.5,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.secondary.withValues(alpha: 0.3),
                              AppColors.secondary.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
