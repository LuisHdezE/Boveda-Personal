import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/features/reports/presentation/providers/quarterly_report_provider.dart';
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

class _QuarterSelector extends ConsumerWidget {
  const _QuarterSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentQuarter = ref.watch(currentQuarterStartProvider);
    final monthNames = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    final startMonth = monthNames[currentQuarter.month - 1];
    final endMonth = monthNames[currentQuarter.month + 1];
    final quarterNum = (currentQuarter.month - 1) ~/ 3 + 1;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.onSurfaceVariant),
            onPressed: () {
              ref.read(currentQuarterStartProvider.notifier).setQuarter(
                DateTime(currentQuarter.year, currentQuarter.month - 3, 1)
              );
            },
          ),
          Column(
            children: [
              Text(
                '$startMonth - $endMonth ${currentQuarter.year}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Q$quarterNum Performance',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
            onPressed: () {
              ref.read(currentQuarterStartProvider.notifier).setQuarter(
                DateTime(currentQuarter.year, currentQuarter.month + 3, 1)
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryGrid extends ConsumerWidget {
  const _SummaryGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(quarterlyReportProvider);

    return reportAsync.when(
      data: (report) {
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
                            '\$${report.netSavings.toStringAsFixed(2)}',
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
                                'Ahorro Neto',
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
                        Expanded(
                          child: Text(
                            'Promedio Gastos',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.money_off, color: AppColors.expense, size: 18),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '\$${report.averageExpense.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.expense,
                                  fontWeight: FontWeight.w500,
                                ),
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
                        Expanded(
                          child: Text(
                            'Ingresos Totales',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_upward, color: AppColors.income, size: 18),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '\$${report.totalIncome.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.income,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                        Text(
                          'En el trimestre',
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
    },
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (e, st) => Text('Error: $e'),
    );
  }
}

class _ComparativeChart extends ConsumerWidget {
  const _ComparativeChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(quarterlyReportProvider);
    final currentQuarter = ref.watch(currentQuarterStartProvider);
    
    final monthNames = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    final m1 = monthNames[currentQuarter.month - 1].toUpperCase();
    final m2 = monthNames[currentQuarter.month].toUpperCase();
    final m3 = monthNames[currentQuarter.month + 1].toUpperCase();

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
                    m1,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 130, // approximate middle
                  child: Text(
                    m2,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text(
                    m3,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ),
                // Pseudo-lines for the chart
                Positioned.fill(
                  child: reportAsync.when(
                    data: (report) => CustomPaint(
                      painter: _ChartPainter(
                        incomePerMonth: report.incomePerMonth,
                        expensePerMonth: report.expensePerMonth,
                      ),
                    ),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
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
  _ChartPainter({required this.incomePerMonth, required this.expensePerMonth});
  
  final List<double> incomePerMonth;
  final List<double> expensePerMonth;

  @override
  void paint(Canvas canvas, Size size) {
    double maxVal = 0;
    for (var i = 0; i < 3; i++) {
      if (incomePerMonth[i] > maxVal) maxVal = incomePerMonth[i];
      if (expensePerMonth[i] > maxVal) maxVal = expensePerMonth[i];
    }
    if (maxVal == 0) maxVal = 1; // prevent division by zero

    final chartHeight = 115.0; // max Y in the drawing area
    final chartBottom = 125.0;
    
    double getY(double val) {
      return chartBottom - (val / maxVal * chartHeight);
    }
    
    double getX(int index) {
      if (index == 0) return 0;
      if (index == 1) return size.width * 0.5;
      return size.width;
    }

    // Income line (green/tertiary)
    final incomePaint = Paint()
      ..color = AppColors.tertiary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final incomePath = Path()
      ..moveTo(getX(0), getY(incomePerMonth[0]))
      ..lineTo(getX(1), getY(incomePerMonth[1]))
      ..lineTo(getX(2), getY(incomePerMonth[2]));

    // Expense line (red/error)
    final expensePaint = Paint()
      ..color = AppColors.expense
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final expensePath = Path()
      ..moveTo(getX(0), getY(expensePerMonth[0]))
      ..lineTo(getX(1), getY(expensePerMonth[1]))
      ..lineTo(getX(2), getY(expensePerMonth[2]));

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
      ..lineTo(size.width, chartBottom)
      ..lineTo(0, chartBottom)
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
      ..lineTo(size.width, chartBottom)
      ..lineTo(0, chartBottom)
      ..close();

    canvas.drawPath(incomeAreaPath, incomeAreaPaint);
    canvas.drawPath(expenseAreaPath, expenseAreaPaint);
    canvas.drawPath(incomePath, incomePaint);
    canvas.drawPath(expensePath, expensePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MonthlyBreakdown extends ConsumerWidget {
  const _MonthlyBreakdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(quarterlyReportProvider);
    final currentQuarter = ref.watch(currentQuarterStartProvider);
    
    final monthNames = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    final m1 = monthNames[currentQuarter.month - 1];
    final m2 = monthNames[currentQuarter.month];
    final m3 = monthNames[currentQuarter.month + 1];

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
        reportAsync.when(
          data: (report) {
            return Column(
              children: [
                _BreakdownCard(
                  month: m1,
                  budgetPct: 0, // Mock budget for now
                  income: '+\$${report.incomePerMonth[0].toStringAsFixed(2)}',
                  expense: '-\$${report.expensePerMonth[0].toStringAsFixed(2)}',
                ),
                const SizedBox(height: 12),
                _BreakdownCard(
                  month: m2,
                  budgetPct: 0,
                  income: '+\$${report.incomePerMonth[1].toStringAsFixed(2)}',
                  expense: '-\$${report.expensePerMonth[1].toStringAsFixed(2)}',
                ),
                const SizedBox(height: 12),
                _BreakdownCard(
                  month: m3,
                  budgetPct: 0,
                  income: '+\$${report.incomePerMonth[2].toStringAsFixed(2)}',
                  expense: '-\$${report.expensePerMonth[2].toStringAsFixed(2)}',
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox(),
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
