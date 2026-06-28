import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/features/reports/presentation/providers/monthly_report_provider.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MonthlyReportView extends ConsumerWidget {
  const MonthlyReportView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(monthlyReportProvider);
    final currentMonth = ref.watch(currentMonthStartProvider);
    final monthNames = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    final currentMonthStr = '${monthNames[currentMonth.month - 1]} ${currentMonth.year}';

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
          'Reporte Mensual',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(
            left: 20, 
            right: 20, 
            top: 24, 
            bottom: MediaQuery.of(context).padding.bottom + 40
          ),
          children: [
            _MonthSelector(currentMonthStr: currentMonthStr),
            const SizedBox(height: 24),
            summaryAsync.when(
              data: (summary) {
                final incomeAmount = summary.totalIncome;
                final expenseAmount = summary.totalExpense;
                final savingsAmount = summary.netSavings;
  
                return Column(
                  children: [
                    _ReportCard(
                      title: 'Ingresos',
                      amount: '\$${incomeAmount.toStringAsFixed(2)}',
                      color: AppColors.income,
                      icon: Icons.arrow_upward,
                    ),
                    const SizedBox(height: 12),
                    _ReportCard(
                      title: 'Gastos',
                      amount: '\$${expenseAmount.toStringAsFixed(2)}',
                      color: AppColors.expense,
                      icon: Icons.arrow_downward,
                    ),
                    const SizedBox(height: 12),
                    _ReportCard(
                      title: 'Ahorro',
                      amount: '\$${savingsAmount.toStringAsFixed(2)}',
                      color: AppColors.onSurface,
                      icon: Icons.savings,
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthSelector extends ConsumerWidget {
  const _MonthSelector({required this.currentMonthStr});
  
  final String currentMonthStr;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMonth = ref.watch(currentMonthStartProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.onSurfaceVariant),
            onPressed: () {
              ref.read(currentMonthStartProvider.notifier).setDate(
                DateTime(currentMonth.year, currentMonth.month - 1, 1)
              );
            },
          ),
          Text(
            currentMonthStr,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
            onPressed: () {
              ref.read(currentMonthStartProvider.notifier).setDate(
                DateTime(currentMonth.year, currentMonth.month + 1, 1)
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String title;
  final String amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                amount,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
