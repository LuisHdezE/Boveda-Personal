import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReportsView extends ConsumerWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainScaffold(
      title: 'Reportes',
      showBottomNav: false,
      showBackButton: true,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: const [
          Text(
            'Analíticas y Resúmenes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          SizedBox(height: 16),
          _ReportMenuCard(
            icon: Icons.calendar_view_week,
            title: 'Reporte Semanal',
            subtitle: 'Evolución de ingresos y gastos en la semana',
            iconColor: AppColors.income,
            route: '/reports/weekly',
          ),
          SizedBox(height: 12),
          _ReportMenuCard(
            icon: Icons.calendar_month,
            title: 'Reporte Mensual',
            subtitle: 'Flujo detallado mes a mes',
            iconColor: AppColors.expense,
            route: '/reports/monthly',
          ),
          SizedBox(height: 12),
          _ReportMenuCard(
            icon: Icons.pie_chart,
            title: 'Reporte Trimestral',
            subtitle: 'Análisis de los últimos 3 meses',
            iconColor: AppColors.wealth,
            route: '/reports/quarterly',
          ),
          SizedBox(height: 12),
          _ReportMenuCard(
            icon: Icons.insert_chart,
            title: 'Reporte Anual',
            subtitle: 'Resumen consolidado del año',
            iconColor: AppColors.income,
            route: '/reports/annual',
          ),
          SizedBox(height: 24),
          Text(
            'Análisis Detallado',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          SizedBox(height: 16),
          _ReportMenuCard(
            icon: Icons.category,
            title: 'Gastos por Categoría',
            subtitle: 'Distribución de tus gastos',
            iconColor: AppColors.expense,
            route: '/reports/categories',
          ),
          SizedBox(height: 12),
          _ReportMenuCard(
            icon: Icons.timeline,
            title: 'Evolución Patrimonial',
            subtitle: 'Crecimiento de tus ahorros en el tiempo',
            iconColor: AppColors.wealth,
            route: '/reports/evolution',
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ReportMenuCard extends StatelessWidget {
  const _ReportMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: () => context.push(route),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}
