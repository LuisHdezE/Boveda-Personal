import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/categories/domain/entities/category.dart';
import 'package:boveda_personal/features/categories/presentation/providers.dart';
import 'package:boveda_personal/features/categories/presentation/widgets/category_picker_sheet.dart';
import 'package:boveda_personal/features/dashboard/presentation/providers.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/presentation/providers.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NewMovementView extends ConsumerStatefulWidget {
  const NewMovementView({super.key, this.initialMovement});
  
  final Movement? initialMovement;

  @override
  ConsumerState<NewMovementView> createState() => _NewMovementViewState();
}

class _NewMovementViewState extends ConsumerState<NewMovementView> {
  bool _isExpense = true;
  bool _isUsd = false; // Add state to toggle currency
  Category? _selectedCategory;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initial = widget.initialMovement;
    if (initial != null) {
      _isExpense = initial.type == MovementType.expense;
      _isUsd = initial.amount.currency.code == 'USD';
      _amountController.text = (initial.amount.minorUnits / 100).toString();
      _noteController.text = initial.note ?? '';
      // We don't have the category object loaded right away, but we can set the ID in another way
      // or we can wait for categories to load if we need it. 
      // For now, _selectedCategory might be tricky because we only have categoryId.
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onSave() async {
    final amountText = _amountController.text;
    if (amountText.isEmpty) return;

    final balances = ref.read(accountBalancesProvider).value;
    if (balances == null || balances.isEmpty) return;

    final currencyCode = _isUsd ? 'USD' : 'CUP';
    final account = balances.firstWhere(
      (b) => b.currency.code == currencyCode,
      orElse: () => balances.first,
    );

    final amountMinor = (double.parse(amountText) * 100).toInt();
    final now = DateTime.now();

    final movement = Movement(
      id: widget.initialMovement?.id ?? ref.read(idGeneratorProvider).next(),
      accountId: account.accountId,
      categoryId: _selectedCategory?.id ?? widget.initialMovement?.categoryId,
      type: _isExpense ? MovementType.expense : MovementType.income,
      amount: Money(minorUnits: amountMinor, currency: account.currency),
      occurredAt: widget.initialMovement?.occurredAt ?? now,
      note: _noteController.text.isEmpty ? null : _noteController.text,
      createdAt: widget.initialMovement?.createdAt ?? now,
      updatedAt: now,
    );

    bool success;
    if (widget.initialMovement != null) {
      await ref.read(movementRepositoryProvider).update(movement);
      success = true;
    } else {
      success = await ref.read(createMovementProvider.notifier).create(movement);
    }
    
    if (success && mounted) {
      ref.invalidate(recentMovementsProvider);
      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(accountBalancesProvider);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.initialMovement != null ? 'Movimiento actualizado' : 'Movimiento registrado con éxito')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: widget.initialMovement != null ? 'Editar Movimiento' : 'Nuevo Movimiento',
      showBackButton: true,
      showBottomNav: false, // The HTML has the nav bar but the bottom is obscured by the save button.
      child: Stack(
        children: [
          // Background Atmospheric Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.wealth.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.income.withValues(alpha: 0.05),
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              _TypeSelector(
                isExpense: _isExpense,
                onChanged: (isExp) {
                  if (_isExpense != isExp) {
                    setState(() {
                      _isExpense = isExp;
                      _selectedCategory = null; // Reset category on type change
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              const SizedBox(height: 32),
              _AmountInput(
                controller: _amountController,
                isExpense: _isExpense,
                currencyCode: _isUsd ? 'USD' : 'CUP',
                onCurrencyToggle: () => setState(() => _isUsd = !_isUsd),
              ),
              const SizedBox(height: 32),
              _FormDetails(
                noteController: _noteController,
                selectedCategory: _selectedCategory,
                onSelectCategory: () => _showCategoryPicker(context),
              ),
              const SizedBox(height: 120), // Padding for button
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + MediaQuery.paddingOf(context).bottom),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: ref.watch(createMovementProvider).isLoading ? null : _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.wealth,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: AppColors.wealth.withValues(alpha: 0.2),
                ),
                child: ref.watch(createMovementProvider).isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : const Text(
                        'GUARDAR MOVIMIENTO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return CategoryPickerSheet(
          movementType: _isExpense ? CategoryMovementType.expense : CategoryMovementType.income,
          selectedId: _selectedCategory?.id ?? widget.initialMovement?.categoryId,
          onSelected: (category) {
            setState(() {
              _selectedCategory = category;
            });
            context.pop();
          },
        );
      },
    );
  }
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({
    required this.isExpense,
    required this.onChanged,
  });

  final bool isExpense;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(4),
      borderRadius: 12,
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              title: 'Gasto',
              isActive: isExpense,
              activeColor: AppColors.expense,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              title: 'Ingreso',
              isActive: !isExpense,
              activeColor: AppColors.income,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.title,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  final String title;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? activeColor.withValues(alpha: 0.3) : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isActive ? activeColor : AppColors.onSurfaceVariant,
                ),
          ),
        ),
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({
    required this.controller,
    required this.isExpense,
    required this.currencyCode,
    required this.onCurrencyToggle,
  });

  final TextEditingController controller;
  final bool isExpense;
  final String currencyCode;
  final VoidCallback onCurrencyToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '\$',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(width: 8),
            IntrinsicWidth(
              child: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.onSurface,
                    ),
                decoration: const InputDecoration(
                  hintText: '0.00',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: false,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onCurrencyToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currencyCode,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.wealth,
                      ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.sync, color: AppColors.wealth, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FormDetails extends StatelessWidget {
  const _FormDetails({
    required this.noteController,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  final TextEditingController noteController;
  final Category? selectedCategory;
  final VoidCallback onSelectCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FormRow(
          icon: Icons.category,
          label: 'Categoría',
          value: selectedCategory?.name ?? 'Seleccionar...',
          onTap: onSelectCategory,
        ),
        const SizedBox(height: 12),
        _FormRow(
          icon: Icons.calendar_today,
          label: 'Fecha',
          value: 'Hoy, 24 Oct',
          actionIcon: Icons.edit,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nota (Opcional)',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  hintText: '¿En qué gastaste?',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({
    required this.icon,
    required this.label,
    required this.value,
    this.actionIcon = Icons.chevron_right,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final IconData actionIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          Icon(actionIcon, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}
