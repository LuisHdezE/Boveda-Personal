import 'dart:math';
import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/features/simulator/domain/simulation_data.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SimulationResultView extends ConsumerWidget {
  const SimulationResultView({super.key, required this.data});
  
  final SimulationData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        children: [
          _HeroCard(data: data),
          _SummaryGrid(data: data),
          const SizedBox(height: 24),
          _MonthlyBreakdown(data: data),
          const SizedBox(height: 24),
          const _Actions(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.data});
  final SimulationData data;

  @override
  Widget build(BuildContext context) {
    final percentage = data.totalSaved > 0 
      ? (data.estimatedInterests / data.totalSaved) * 100 
      : 0.0;
      
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
                'Saldo Final Proyectado (${data.years} años)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '${data.currency != 'USD' ? '\$' : 'USD '}${data.finalBalance.toStringAsFixed(2)}',
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
                      '+${percentage.toStringAsFixed(1)}% vs Ahorro Simple',
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

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.data});
  final SimulationData data;

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
                  '${data.currency != 'USD' ? '\$' : 'USD '}${data.totalSaved.toStringAsFixed(2)}',
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
                  '+${data.currency != 'USD' ? '\$' : 'USD '}${data.estimatedInterests.toStringAsFixed(2)}',
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



class _MonthlyBreakdown extends StatelessWidget {
  const _MonthlyBreakdown({required this.data});
  final SimulationData data;

  @override
  Widget build(BuildContext context) {
    final cur = data.currency != 'USD' ? '\$' : 'USD ';
    
    final int months = data.years * 12;
    final List<int> milestones = [];
    if (months > 0) milestones.add(min(12, months));
    if (months > 24) milestones.add(months ~/ 2);
    if (months > 12) milestones.add(months);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Hitos de la Proyección',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
        ),
        const SizedBox(height: 12),
        ...milestones.map((month) {
          final balance = data.balanceAtMonth(month);
          final interest = data.interestAtMonth(month);
          final label = month % 12 == 0 ? 'Año ${month ~/ 12}' : 'Mes $month';
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _BreakdownItem(
              month: label,
              aportacion: '+ $cur${data.monthlySavings.toStringAsFixed(2)} mensual',
              amount: '$cur${balance.toStringAsFixed(2)}',
              interest: '+ $cur${interest.toStringAsFixed(2)} int.',
            ),
          );
        }),
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
          onPressed: () => context.pop(),
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
