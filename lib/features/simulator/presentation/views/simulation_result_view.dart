import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimulationResultView extends ConsumerWidget {
  const SimulationResultView({super.key});

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
          'Resultado de Simulación',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [SizedBox(width: 48)], // Spacer for centering
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: const [
          _HeroCard(),
          SizedBox(height: 24),
          _ChartCard(),
          SizedBox(height: 24),
          _SummaryGrid(),
          SizedBox(height: 24),
          _GoalCard(),
          SizedBox(height: 24),
          _MonthlyBreakdown(),
          SizedBox(height: 24),
          _Actions(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Background blurs
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.secondary.withValues(alpha: 0.2), blurRadius: 40, spreadRadius: 20),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.secondary.withValues(alpha: 0.1), blurRadius: 40, spreadRadius: 20),
                ],
              ),
            ),
          ),
          // Content
          Column(
            children: [
              Text(
                'Saldo Final Proyectado (5 años)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$145,250.00',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up, color: AppColors.tertiary, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '+24.5% vs Ahorro Simple',
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
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Crecimiento del Patrimonio',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
              Text(
                'Mensual',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 192, // 48 tailwind
            width: double.infinity,
            child: CustomPaint(
              painter: _SimulationChartPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimulationChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.secondary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // Line equivalent to SVG: d="M0 150 L0 120 C 50 110, 100 130, 150 100 C 200 70, 250 90, 300 50 C 350 10, 380 30, 400 20"
    // Since viewbox is 400x150, we scale it to size.
    final scaleX = size.width / 400;
    final scaleY = size.height / 150;

    path.moveTo(0 * scaleX, 120 * scaleY);
    path.cubicTo(50 * scaleX, 110 * scaleY, 100 * scaleX, 130 * scaleY, 150 * scaleX, 100 * scaleY);
    path.cubicTo(200 * scaleX, 70 * scaleY, 250 * scaleX, 90 * scaleY, 300 * scaleX, 50 * scaleY);
    path.cubicTo(350 * scaleX, 10 * scaleY, 380 * scaleX, 30 * scaleY, 400 * scaleX, 20 * scaleY);

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
      ..lineTo(400 * scaleX, 150 * scaleY)
      ..lineTo(0 * scaleX, 150 * scaleY)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.savings, color: AppColors.onSurfaceVariant),
                const SizedBox(height: 8),
                Text(
                  'Total Ahorrado',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$116,666.66',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.show_chart, color: AppColors.tertiary),
                const SizedBox(height: 8),
                Text(
                  'Intereses Estimados',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '+\$28,583.34',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.tertiary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flag, color: AppColors.secondary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meta Alcanzada',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.onSurface,
                        ),
                  ),
                  Text(
                    'Objetivo: \$150,000',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            '96%',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyBreakdown extends StatelessWidget {
  const _MonthlyBreakdown();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Desglose (Próximos meses)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
        ),
        const SizedBox(height: 12),
        _BreakdownItem(
          month: 'Mes 1',
          aportacion: '+ \$2,420.00 aportación',
          amount: '\$2,420.00',
          interest: '+ \$0.00 int.',
        ),
        const SizedBox(height: 8),
        _BreakdownItem(
          month: 'Mes 2',
          aportacion: '+ \$2,420.00 aportación',
          amount: '\$4,860.15',
          interest: '+ \$20.15 int.',
        ),
        const SizedBox(height: 8),
        _BreakdownItem(
          month: 'Mes 3',
          aportacion: '+ \$2,420.00 aportación',
          amount: '\$7,320.65',
          interest: '+ \$40.50 int.',
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.secondary,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Ver proyección completa'),
          ),
        ),
      ],
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  const _BreakdownItem({
    required this.month,
    required this.aportacion,
    required this.amount,
    required this.interest,
  });

  final String month;
  final String aportacion;
  final String amount;
  final String interest;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                month,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
              Text(
                aportacion,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
              Text(
                interest,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.tertiary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            shadowColor: AppColors.secondary.withValues(alpha: 0.3),
          ),
          child: Text(
            'Guardar Resultado',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            foregroundColor: AppColors.onSurface,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            elevation: 0,
          ),
          child: Text(
            'Nueva Simulación',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
        ),
      ],
    );
  }
}
