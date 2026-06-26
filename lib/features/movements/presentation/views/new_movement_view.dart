import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewMovementView extends ConsumerStatefulWidget {
  const NewMovementView({super.key});

  @override
  ConsumerState<NewMovementView> createState() => _NewMovementViewState();
}

class _NewMovementViewState extends ConsumerState<NewMovementView> {
  bool _isExpense = true;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Nuevo Movimiento',
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
                onChanged: (isExp) => setState(() => _isExpense = isExp),
              ),
              const SizedBox(height: 32),
              _AmountInput(
                controller: _amountController,
                isExpense: _isExpense,
              ),
              const SizedBox(height: 32),
              _FormDetails(
                noteController: _noteController,
              ),
              const SizedBox(height: 100), // Padding for button
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.wealth,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: AppColors.wealth.withValues(alpha: 0.3),
                ),
                child: Text(
                  'Guardar Movimiento',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
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
  });

  final TextEditingController controller;
  final bool isExpense;

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
        Container(
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
                'USD',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.wealth,
                    ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, color: AppColors.wealth, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _FormDetails extends StatelessWidget {
  const _FormDetails({required this.noteController});

  final TextEditingController noteController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FormRow(
          icon: Icons.category,
          label: 'Categoría',
          value: 'Seleccionar...',
          onTap: () {},
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
