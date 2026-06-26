import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuarterlyReportView extends ConsumerWidget {
  const QuarterlyReportView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainScaffold(
      title: 'Reporte Trimestral',
      showBottomNav: true,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: const [
          _QuarterSelector(),
          SizedBox(height: 24),
          _SummaryGrid(),
          SizedBox(height: 24),
          _ComparativeChart(),
          SizedBox(height: 24),
          _MonthlyBreakdown(),
          SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _QuarterSelector extends StatelessWidget {
  const _QuarterSelector();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
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
                'Ene - Mar 2024',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Q1 Performance',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
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

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Total Savings
        GlassCard(
          padding: const EdgeInsets.all(16),
          height: 128,
          child: Stack(
            children: [
              Positioned(
                top: -16,
                right: -16,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        blurRadius: 40,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AHORRO TOTAL DEL TRIMESTRE',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                              letterSpacing: 1.5,
                            ),
                      ),
                      const Icon(Icons.savings, color: AppColors.secondary),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$12,450.00',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.trending_up, color: AppColors.income, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '+15% vs Q4',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.income,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(12),
                height: 112,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Promedio Gastos',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                        const Icon(Icons.money_off, color: AppColors.expense, size: 18),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\$3,120',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.expense,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          '/ mes',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(12),
                height: 112,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Crecimiento',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                        const Icon(Icons.account_balance, color: AppColors.tertiary, size: 18),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '+4.2%',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.tertiary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        Text(
                          'Patrimonial',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ComparativeChart extends StatelessWidget {
  const _ComparativeChart();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Ingresos vs Gastos',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.tertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Ing',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.expense,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Gto',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Chart placeholder
          SizedBox(
            height: 150,
            child: Stack(
              children: [
                // Horizontal grid lines
                Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
                ),
                Positioned(
                  top: 75,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
                ),
                Positioned(
                  top: 125,
                  left: 0,
                  right: 0,
                  child: Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
                ),
                // X-Axis labels
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Text(
                    'ENE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 130, // approximate middle
                  child: Text(
                    'FEB',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text(
                    'MAR',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ),
                // Pseudo-lines for the chart
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ChartPainter(),
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

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Income line (green/tertiary)
    final incomePaint = Paint()
      ..color = AppColors.tertiary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final incomePath = Path()
      ..moveTo(0, 60)
      ..quadraticBezierTo(size.width * 0.16, 60, size.width * 0.33, 40)
      ..quadraticBezierTo(size.width * 0.5, 45, size.width * 0.66, 50)
      ..quadraticBezierTo(size.width * 0.83, 20, size.width, 25);

    // Expense line (red/error)
    final expensePaint = Paint()
      ..color = AppColors.expense
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final expensePath = Path()
      ..moveTo(0, 90)
      ..quadraticBezierTo(size.width * 0.16, 90, size.width * 0.33, 80)
      ..quadraticBezierTo(size.width * 0.5, 85, size.width * 0.66, 90)
      ..quadraticBezierTo(size.width * 0.83, 70, size.width, 75);

    // Gradients
    final incomeGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.tertiary.withValues(alpha: 0.3),
        AppColors.tertiary.withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    final incomeAreaPaint = Paint()
      ..shader = incomeGradient
      ..style = PaintingStyle.fill;

    final incomeAreaPath = Path.from(incomePath)
      ..lineTo(size.width, 125)
      ..lineTo(0, 125)
      ..close();

    final expenseGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.expense.withValues(alpha: 0.3),
        AppColors.expense.withValues(alpha: 0.0),
      ],
    ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    final expenseAreaPaint = Paint()
      ..shader = expenseGradient
      ..style = PaintingStyle.fill;

    final expenseAreaPath = Path.from(expensePath)
      ..lineTo(size.width, 125)
      ..lineTo(0, 125)
      ..close();

    canvas.drawPath(incomeAreaPath, incomeAreaPaint);
    canvas.drawPath(expenseAreaPath, expenseAreaPaint);
    canvas.drawPath(incomePath, incomePaint);
    canvas.drawPath(expensePath, expensePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MonthlyBreakdown extends StatelessWidget {
  const _MonthlyBreakdown();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Desglose Mensual',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
        ),
        const SizedBox(height: 12),
        _BreakdownCard(
          month: 'Enero',
          budgetPct: 85,
          income: '+\$5,200',
          expense: '-\$3,400',
        ),
        const SizedBox(height: 12),
        _BreakdownCard(
          month: 'Febrero',
          budgetPct: 92,
          income: '+\$4,800',
          expense: '-\$3,100',
        ),
        const SizedBox(height: 12),
        _BreakdownCard(
          month: 'Marzo',
          budgetPct: 78,
          income: '+\$5,500',
          expense: '-\$2,860',
        ),
      ],
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({
    required this.month,
    required this.budgetPct,
    required this.income,
    required this.expense,
  });

  final String month;
  final int budgetPct;
  final String income;
  final String expense;

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
                month,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                'Presupuesto: $budgetPct%',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: budgetPct / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                income,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.income,
                    ),
              ),
              Text(
                expense,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.expense,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
