import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';

class MovementDetailView extends StatelessWidget {
  const MovementDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Detalle',
      showBackButton: true,
      showBottomNav: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero Section
                    const SizedBox(height: 16),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.expense.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.expense.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.expense.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.restaurant, color: AppColors.expense, size: 32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '-\$85.50',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppColors.expense,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cena Restaurante',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 32),

                    // Details Card
                    GlassCard(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Column(
                        children: [
                          _DetailRow(
                            icon: Icons.calendar_today,
                            label: 'Fecha',
                            trailing: Text(
                              '24 Oct 2023, 20:30',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.onSurface,
                                  ),
                            ),
                          ),
                          const Divider(height: 1, color: Colors.white10),
                          _DetailRow(
                            icon: Icons.category,
                            label: 'Categoría',
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceHigh,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Text(
                                'Alimentación',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                              ),
                            ),
                          ),
                          const Divider(height: 1, color: Colors.white10),
                          _DetailRow(
                            icon: Icons.payments,
                            label: 'Moneda',
                            trailing: Text(
                              'USD (Tipo 1.0)',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.onSurface,
                                  ),
                            ),
                          ),
                          const Divider(height: 1, color: Colors.white10),
                          _DetailRow(
                            icon: Icons.notes,
                            label: 'Nota',
                            crossAxisAlignment: CrossAxisAlignment.start,
                            trailing: Expanded(
                              child: Text(
                                'Cena de negocios con cliente potencial.',
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Acciones Inferiores
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: AppColors.onSurface, size: 20),
                    label: Text(
                      'Editar',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.onSurface,
                          ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete, color: AppColors.expense, size: 20),
                    label: Text(
                      'Eliminar',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.expense,
                          ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.expense.withValues(alpha: 0.1),
                      side: BorderSide(color: AppColors.expense.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.trailing,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final IconData icon;
  final String label;
  final Widget trailing;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          if (crossAxisAlignment == CrossAxisAlignment.center) const Spacer(),
          if (crossAxisAlignment == CrossAxisAlignment.start) const SizedBox(width: 16),
          trailing,
        ],
      ),
    );
  }
}
