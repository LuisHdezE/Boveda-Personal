import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class PatrimonyEvolutionView extends ConsumerWidget {
  const PatrimonyEvolutionView({super.key});

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
          'Evolución Patrimonial',
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
          _SummaryCard(),
          SizedBox(height: 24),
          _EvolutionChartCard(),
          SizedBox(height: 24),
          _MilestonesList(),
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
            'Año 2023',
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
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
              Text(
                '\$142,500.00',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.tertiary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.trending_up, color: AppColors.tertiary, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '+18.4% este año',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.tertiary,
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
  }
}

class _EvolutionChartCard extends StatelessWidget {
  const _EvolutionChartCard();

  @override
  Widget build(BuildContext context) {
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
            child: Stack(
              children: [
                // Horizontal grid lines
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
                ),
                Positioned(
                  top: 150,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
                ),
                Positioned(
                  top: 200,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _EvolutionChartPainter(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ene', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
              Text('Abr', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
              Text('Jul', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
              Text('Oct', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
              Text('Dic', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EvolutionChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // Smooth upward curve representing patrimony evolution
    path.moveTo(0, size.height * 0.9);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.8, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.2, size.width, size.height * 0.1);

    // Gradient Area
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.secondary.withValues(alpha: 0.3),
          AppColors.secondary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MilestonesList extends StatelessWidget {
  const _MilestonesList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Hitos de Crecimiento',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star, color: AppColors.secondary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Récord de Patrimonio',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.onSurface,
                          ),
                    ),
                    Text(
                      'Alcanzado en Diciembre',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$142,500',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
