import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovementsHistoryView extends ConsumerWidget {
  const MovementsHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainScaffold(
      title: 'Bóveda Personal',
      showBottomNav: true,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: const [
          _SearchAndFilterSection(),
          SizedBox(height: 24),
          _TimeSegmentationChips(),
          SizedBox(height: 24),
          _TransactionsList(),
          SizedBox(height: 80), // Padding for bottom nav
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
  const _TransactionsList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _DateGroup(
          date: '24 OCTUBRE 2023',
          items: [
            _TransactionItem(
              icon: Icons.restaurant,
              title: 'Restaurante El Ciervo',
              category: 'Alimentación',
              amount: '-\$85.50',
              isIncome: false,
            ),
            _TransactionItem(
              icon: Icons.local_taxi,
              title: 'Uber Trip',
              category: 'Transporte',
              amount: '-\$18.20',
              isIncome: false,
            ),
          ],
        ),
        const SizedBox(height: 24),
        const _DateGroup(
          date: '23 OCTUBRE 2023',
          items: [
            _TransactionItem(
              icon: Icons.account_balance,
              title: 'Nómina Octubre',
              category: 'Ingresos',
              amount: '+\$3,450.00',
              isIncome: true,
            ),
            _TransactionItem(
              icon: Icons.shopping_cart,
              title: 'Supermercado',
              category: 'Compras',
              amount: '-\$124.90',
              isIncome: false,
            ),
          ],
        ),
      ],
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

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({
    required this.icon,
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
  });

  final IconData icon;
  final String title;
  final String category;
  final String amount;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/movements/detail'),
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
