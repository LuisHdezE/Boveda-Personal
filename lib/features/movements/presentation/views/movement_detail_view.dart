import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/categories/presentation/providers.dart';
import 'package:boveda_personal/features/dashboard/presentation/providers.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/presentation/providers.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:boveda_personal/core/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovementDetailView extends ConsumerWidget {
  const MovementDetailView({super.key, required this.movement});
  final Movement movement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider(null));
    final categoryName = categoriesAsync.maybeWhen(
      data: (cats) {
        if (movement.categoryId == null) return 'Sin categoría';
        return cats.firstWhere((c) => c.id == movement.categoryId, orElse: () => cats.first).name;
      },
      orElse: () => 'Cargando...',
    );

    final isExpense = !movement.isCredit;
    final color = isExpense ? AppColors.expense : AppColors.income;
    
    // Formatting date
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    final date = movement.occurredAt;
    final dateStr = '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    final amountValue = isExpense ? -(movement.amount.minorUnits / 100) : (movement.amount.minorUnits / 100);
    final formattedAmount = CurrencyFormatter.formatAmount(amountValue, currencyCode: movement.amount.currency.code);

    return MainScaffold(
      title: 'Detalle',
      showBackButton: true,
      showBottomNav: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 24, 20, 24 + MediaQuery.paddingOf(context).bottom),
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
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: color.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          isExpense ? Icons.arrow_downward : Icons.arrow_upward, 
                          color: color, 
                          size: 32
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      formattedAmount,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      categoryName,
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
                              dateStr,
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
                                categoryName,
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
                              movement.amount.currency.code,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.onSurface,
                                  ),
                            ),
                          ),
                          if (movement.note != null && movement.note!.isNotEmpty) ...[
                            const Divider(height: 1, color: Colors.white10),
                            _DetailRow(
                              icon: Icons.notes,
                              label: 'Nota',
                              crossAxisAlignment: CrossAxisAlignment.start,
                              trailing: Text(
                                movement.note!,
                                textAlign: TextAlign.right,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                              ),
                            ),
                          ]
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
                    onPressed: () {
                      context.push('/movements/new', extra: movement);
                    },
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
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar movimiento'),
                          content: const Text('¿Estás seguro de que deseas eliminar este movimiento?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Eliminar', style: TextStyle(color: AppColors.expense)),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirmed == true) {
                        final success = await ref.read(deleteMovementProvider.notifier).delete(movement);
                        if (success) {
                          ref.invalidate(movementsProvider);
                          ref.invalidate(recentMovementsProvider);
                          ref.invalidate(dashboardSummaryProvider);
                          ref.invalidate(accountBalancesProvider);
                          if (context.mounted) {
                            context.pop(); // Go back to previous screen
                          }
                        } else {
                          if (context.mounted) {
                            final errorState = ref.read(deleteMovementProvider).error;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(errorState?.toString().replaceAll('Exception: ', '') ?? 'Error al eliminar')),
                            );
                          }
                        }
                      }
                    },
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
          const SizedBox(width: 16),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: trailing,
            ),
          ),
        ],
      ),
    );
  }
}
