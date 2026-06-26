import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthlyReportView extends ConsumerWidget {
  const MonthlyReportView({super.key});

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
          'Reporte Mensual',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: const [
          _MonthSelector(),
          SizedBox(height: 24),
          _ChartSection(),
        ],
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector();

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
          ),
          Text(
            'Octubre 2023',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evolución Mensual',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 192, // h-48 in tailwind
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // Background gradient matching chart-area from the template
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.secondary.withValues(alpha: 0.2),
                  AppColors.secondary.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Mockup Grid Lines
                Positioned(
                  top: 48,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                Positioned(
                  top: 96,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                Positioned(
                  top: 144,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.05),
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
