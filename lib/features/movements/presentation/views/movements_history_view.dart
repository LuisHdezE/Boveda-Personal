import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/presentation/providers.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/dashboard/presentation/providers.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MovementsHistoryView extends ConsumerWidget {
  const MovementsHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movementsAsync = ref.watch(movementsProvider);

    return MainScaffold(
      title: 'Movimientos',
      showBackButton: true,
      showBottomNav: false,
      child: ListView(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.paddingOf(context).bottom),
        children: [
          const _SearchAndFilterSection(),
          const SizedBox(height: 24),
          const _TimeSegmentationChips(),
          const SizedBox(height: 24),
          movementsAsync.when(
            data: (movements) => _TransactionsList(movements: movements),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
          const SizedBox(height: 80), // Padding for bottom nav
        ],
      ),
    );
  }
}

class _SearchAndFilterSection extends StatelessWidget {
  const _SearchAndFilterSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            borderRadius: 12,
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar movimientos...',
                        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.transparent,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GlassCard(
          padding: EdgeInsets.zero,
          borderRadius: 12,
          onTap: () => context.push('/movements/filters'),
          child: const SizedBox(
            height: 56,
            width: 56,
            child: Icon(Icons.tune, color: AppColors.onSurface),
          ),
        ),
      ],
    );
  }
}

class _TimeSegmentationChips extends StatelessWidget {
  const _TimeSegmentationChips();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _TimeChip(label: 'Día', isSelected: false, onTap: () {}),
          const SizedBox(width: 8),
          _TimeChip(label: 'Semana', isSelected: false, onTap: () {}),
          const SizedBox(width: 8),
          _TimeChip(label: 'Mes', isSelected: true, onTap: () {}),
          const SizedBox(width: 8),
          _TimeChip(label: 'Año', isSelected: false, onTap: () {}),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.wealth : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white.withValues(alpha: 0.1),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.wealth.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? Colors.black : AppColors.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}

class _TransactionsList extends StatelessWidget {
  const _TransactionsList({required this.movements});

  final List<Movement> movements;

  @override
  Widget build(BuildContext context) {
    if (movements.isEmpty) {
      return Center(
        child: Text(
          'No hay movimientos para mostrar.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      );
    }

    // Group movements by date (just day)
    final grouped = <String, List<Movement>>{};
    for (final m in movements) {
      final dateStr = DateFormat('dd MMMM yyyy', 'es_AR').format(m.occurredAt).toUpperCase();
      grouped.putIfAbsent(dateStr, () => []).add(m);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _DateGroup(
            date: entry.key,
            items: entry.value.map((m) {
              final isIncome = m.type == MovementType.income;
              return _TransactionItem(
                movement: m,
                icon: isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                title: m.note ?? (isIncome ? 'Ingreso' : 'Gasto'),
                category: 'Movimiento', // TODO: categories
                amount: '${isIncome ? '+' : '-'}\$${(m.amount.minorUnits / 100).toStringAsFixed(2)}',
                isIncome: isIncome,
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _DateGroup extends StatelessWidget {
  const _DateGroup({
    required this.date,
    required this.items,
  });

  final String date;
  final List<_TransactionItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            date,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: EdgeInsets.zero,
          borderRadius: 16,
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  entry.value,
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _TransactionItem extends ConsumerWidget {
  const _TransactionItem({
    required this.movement,
    required this.icon,
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
  });

  final Movement movement;
  final IconData icon;
  final String title;
  final String category;
  final String amount;
  final bool isIncome;

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.onSurface),
              title: const Text('Editar', style: TextStyle(color: AppColors.onSurface)),
              onTap: () {
                Navigator.pop(ctx);
                context.push('/movements/new', extra: movement);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.expense),
              title: const Text('Eliminar', style: TextStyle(color: AppColors.expense)),
              onTap: () async {
                Navigator.pop(ctx);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (dCtx) => AlertDialog(
                    backgroundColor: AppColors.surfaceHigh,
                    title: const Text('¿Eliminar movimiento?', style: TextStyle(color: AppColors.onSurface)),
                    content: const Text('Esta acción no se puede deshacer.', style: TextStyle(color: AppColors.onSurfaceVariant)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dCtx, false),
                        child: const Text('Cancelar', style: TextStyle(color: AppColors.onSurfaceVariant)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(dCtx, true),
                        child: const Text('Eliminar', style: TextStyle(color: AppColors.expense)),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true) {
                  await ref.read(movementRepositoryProvider).delete(movement.id);
                  ref.invalidate(recentMovementsProvider);
                  ref.invalidate(dashboardSummaryProvider);
                  ref.invalidate(accountBalancesProvider);
                  ref.invalidate(movementsProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Movimiento eliminado')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => context.push('/movements/detail'),
      onLongPress: () => _showOptions(context, ref),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: const BoxDecoration(
                color: AppColors.surfaceHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isIncome ? AppColors.income : AppColors.onSurfaceVariant,
              ),
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
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isIncome ? AppColors.income : AppColors.onSurface,
                    fontSize: 16,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
