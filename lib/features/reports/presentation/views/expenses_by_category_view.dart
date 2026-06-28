import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/features/reports/presentation/providers/category_expenses_provider.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class ExpensesByCategoryView extends ConsumerWidget {
  const ExpensesByCategoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMonth = ref.watch(expenseMonthStartProvider);

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
          'Gastos por Categoría',
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
          _PeriodSelector(selectedMonth: selectedMonth),
          const SizedBox(height: 24),
          const _ChartSection(),
          const SizedBox(height: 24),
          const _CategoryList(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _PeriodSelector extends ConsumerWidget {
  const _PeriodSelector({required this.selectedMonth});
  final DateTime selectedMonth;

  static const _monthNames = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = '${_monthNames[selectedMonth.month - 1]} ${selectedMonth.year}';
    final now = DateTime.now();
    final isCurrentMonth = selectedMonth.year == now.year && selectedMonth.month == now.month;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.onSurfaceVariant),
            onPressed: () {
              final prev = DateTime(selectedMonth.year, selectedMonth.month - 1, 1);
              ref.read(expenseMonthStartProvider.notifier).setDate(prev);
            },
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.onSurface),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: isCurrentMonth ? AppColors.onSurfaceVariant.withValues(alpha: 0.3) : AppColors.onSurfaceVariant,
            ),
            onPressed: isCurrentMonth
                ? null
                : () {
                    final next = DateTime(selectedMonth.year, selectedMonth.month + 1, 1);
                    ref.read(expenseMonthStartProvider.notifier).setDate(next);
                  },
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
    final reportAsync = ref.watch(categoryExpensesProvider);

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
        final currCode = report.displayCurrencyCode;
        final total = report.totalExpense;
        final categories = report.categories;

        return GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Distribución Mensual',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 16),
              if (total == 0)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.onSurfaceVariant),
                        SizedBox(height: 8),
                        Text('Sin gastos registrados este mes', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                )
              else
                Center(
                  child: SizedBox(
                    width: 224,
                    height: 224,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withValues(alpha: 0.15),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: CustomPaint(
                            painter: _DonutChartPainter(categories: categories),
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 150,
                          decoration: const BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            shape: BoxShape.circle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    '-${total.toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: AppColors.expense,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ),
                              Text(
                                currCode,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                              ),
                            ],
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

// Palette of colors to assign to categories
const _categoryColors = [
  AppColors.secondary,
  AppColors.expense,
  AppColors.income,
  AppColors.tertiary,
  AppColors.wealth,
  Color(0xFF7986CB),
  Color(0xFF4FC3F7),
  Color(0xFFFF8A65),
];

class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter({required this.categories});
  final List categories;

  @override
  void paint(Canvas canvas, Size size) {
    if (categories.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()..style = PaintingStyle.fill;

    double startPercent = 0.0;
    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];
      final endPercent = startPercent + (cat.percentage as double);
      final startAngle = startPercent * 2 * math.pi - math.pi / 2;
      final sweepAngle = (endPercent - startPercent) * 2 * math.pi;
      paint.color = _categoryColors[i % _categoryColors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startPercent = endPercent;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) => oldDelegate.categories != categories;
}

class _CategoryList extends ConsumerWidget {
  const _CategoryList();

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'restaurant': return Icons.restaurant;
      case 'directions_car': return Icons.directions_car;
      case 'favorite': return Icons.favorite;
      case 'movie': return Icons.movie;
      case 'home': return Icons.home;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'bolt': return Icons.bolt;
      case 'health_and_safety': return Icons.health_and_safety;
      case 'school': return Icons.school;
      case 'sports': return Icons.sports;
      case 'flight': return Icons.flight;
      case 'devices': return Icons.devices;
      default: return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(categoryExpensesProvider);

    return reportAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (report) {
        if (report.categories.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            for (int i = 0; i < report.categories.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _CategoryItem(
                name: report.categories[i].category.name,
                percentage: '${(report.categories[i].percentage * 100).toStringAsFixed(1)}% del total',
                amount: '-${report.categories[i].amount.toStringAsFixed(2)} ${report.displayCurrencyCode}',
                icon: _getIcon(report.categories[i].category.icon),
                color: _categoryColors[i % _categoryColors.length],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.name,
    required this.percentage,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String name;
  final String percentage;
  final String amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.onSurface,
                      ),
                ),
                Text(
                  percentage,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.expense,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
