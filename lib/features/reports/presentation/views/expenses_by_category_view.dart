import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class ExpensesByCategoryView extends ConsumerWidget {
  const ExpensesByCategoryView({super.key});

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
          'Gastos por Categoría',
          style: TextStyle(
            color: AppColors.secondary,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: const [
          _PeriodSelector(),
          SizedBox(height: 24),
          _ChartSection(),
          SizedBox(height: 24),
          _CategoryList(),
          SizedBox(height: 40),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      borderRadius: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
          Text(
            'Octubre 2023',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurface,
                ),
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

class _ChartSection extends StatelessWidget {
  const _ChartSection();

  @override
  Widget build(BuildContext context) {
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
          Center(
            child: SizedBox(
              width: 224, // 56 in tailwind
              height: 224,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Donut Chart
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
                      painter: _DonutChartPainter(),
                    ),
                  ),
                  // Inner hole
                  Container(
                    width: 160, // Smaller than 224
                    height: 160,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Gastado',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$4,250.00',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.bold,
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
  }
}

class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Conic gradient equivalent
    // 0% 45% Gold (secondary)
    // 45% 70% Red (error)
    // 70% 85% Light Blue (onSurface)
    // 85% 95% Green (tertiary)
    // 95% 100% Grey (outline)

    void drawSegment(double startPercent, double endPercent, Color color) {
      final startAngle = startPercent * 2 * math.pi - math.pi / 2;
      final sweepAngle = (endPercent - startPercent) * 2 * math.pi;
      
      paint.color = color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
    }

    drawSegment(0.0, 0.45, AppColors.secondary);
    drawSegment(0.45, 0.70, AppColors.error);
    drawSegment(0.70, 0.85, AppColors.onSurface);
    drawSegment(0.85, 0.95, AppColors.tertiary);
    drawSegment(0.95, 1.0, AppColors.outline);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CategoryList extends StatelessWidget {
  const _CategoryList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CategoryItem(
          name: 'Alimentación',
          percentage: '45% del total',
          amount: '-\$1,912.50',
          icon: Icons.restaurant,
          color: AppColors.secondary,
        ),
        const SizedBox(height: 12),
        _CategoryItem(
          name: 'Transporte',
          percentage: '25% del total',
          amount: '-\$1,062.50',
          icon: Icons.directions_car,
          color: AppColors.error,
        ),
        const SizedBox(height: 12),
        _CategoryItem(
          name: 'Servicios',
          percentage: '15% del total',
          amount: '-\$637.50',
          icon: Icons.bolt,
          color: AppColors.onSurface,
        ),
        const SizedBox(height: 12),
        _CategoryItem(
          name: 'Compras',
          percentage: '10% del total',
          amount: '-\$425.00',
          icon: Icons.shopping_bag,
          color: AppColors.tertiary,
        ),
        const SizedBox(height: 12),
        _CategoryItem(
          name: 'Otros',
          percentage: '5% del total',
          amount: '-\$212.50',
          icon: Icons.category,
          color: AppColors.outline,
        ),
      ],
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
      onTap: () {},
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
