import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class MovementFiltersView extends StatelessWidget {
  const MovementFiltersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.onSurfaceVariant),
          onPressed: () {},
        ),
        title: const Text(
          'Filtros',
          style: TextStyle(
            color: AppColors.wealth,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.wealth,
            ),
            child: const Text('Limpiar'),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100), // Padding bottom for fixed button
            children: [
              // Rango de Fecha
              const _SectionTitle('Rango de Fecha'),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(label: 'Este mes', isSelected: true),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Esta semana', isSelected: false),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Hoy', isSelected: false),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Personalizado', isSelected: false),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(child: _DateInput(label: 'Desde', value: '01 Mar 2024')),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.arrow_right_alt, color: AppColors.outlineVariant),
                    ),
                    Expanded(child: _DateInput(label: 'Hasta', value: '31 Mar 2024')),
                  ],
                ),
              ),
              const _SectionDivider(),

              // Tipo de Movimiento
              const _SectionTitle('Tipo de Movimiento'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TypeCheckbox(
                      icon: Icons.arrow_downward,
                      label: 'Ingresos',
                      color: AppColors.income,
                      isSelected: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TypeCheckbox(
                      icon: Icons.arrow_upward,
                      label: 'Gastos',
                      color: AppColors.expense,
                      isSelected: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TypeCheckbox(
                      icon: Icons.sync_alt,
                      label: 'Transferencias',
                      color: AppColors.wealth,
                      isSelected: false,
                    ),
                  ),
                ],
              ),
              const _SectionDivider(),

              // Categorías
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionTitle('Categorías'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Seleccionar todo', style: TextStyle(color: AppColors.wealth)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 16,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  _CategoryItem(icon: Icons.restaurant, label: 'Alimentación', isSelected: true),
                  _CategoryItem(icon: Icons.directions_car, label: 'Transporte', isSelected: false),
                  _CategoryItem(icon: Icons.favorite, label: 'Salud', isSelected: false),
                  _CategoryItem(icon: Icons.movie, label: 'Ocio', isSelected: true),
                  _CategoryItem(icon: Icons.home, label: 'Hogar', isSelected: false),
                  _CategoryItem(icon: Icons.shopping_bag, label: 'Compras', isSelected: false),
                ],
              ),
              const _SectionDivider(),

              // Moneda
              const _SectionTitle('Moneda'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _CurrencyRadio(
                      title: 'ARS',
                      subtitle: 'Pesos',
                      isSelected: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CurrencyRadio(
                      title: 'USD',
                      subtitle: 'Dólares',
                      isSelected: false,
                    ),
                  ),
                ],
              ),
              const _SectionDivider(),

              // Importe
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionTitle('Importe'),
                  Text(
                    '\$0 - \$150.000+',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.wealth,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Mock Slider
                    RangeSlider(
                      values: const RangeValues(10, 30),
                      min: 0,
                      max: 100,
                      activeColor: AppColors.wealth,
                      inactiveColor: AppColors.surfaceVariant,
                      onChanged: (values) {},
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _AmountInput(label: 'Mínimo', value: '0')),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('-', style: TextStyle(color: AppColors.outlineVariant)),
                        ),
                        Expanded(child: _AmountInput(label: 'Máximo', value: '150000')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Fixed Bottom Action
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
              ),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.filter_list, color: Colors.black),
                label: const Text(
                  'Aplicar Filtros (12 resultados)',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.wealth,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.onSurface,
          ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.white.withValues(alpha: 0.05),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.isSelected});
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.wealth.withValues(alpha: 0.1) : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.wealth.withValues(alpha: 0.2) : AppColors.outlineVariant,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isSelected ? AppColors.wealth : AppColors.onSurfaceVariant,
            ),
      ),
    );
  }
}

class _DateInput extends StatelessWidget {
  const _DateInput({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: AppColors.onSurfaceVariant, size: 20),
          const SizedBox(width: 8),
          Column(
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
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeCheckbox extends StatelessWidget {
  const _TypeCheckbox({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 8,
      backgroundColor: isSelected ? color.withValues(alpha: 0.1) : null,
      borderColor: isSelected ? color.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.1),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? color : AppColors.onSurfaceVariant),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected ? color : AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  final IconData icon;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52, // Fixed width to roughly match the grid look
      child: Column(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.wealth.withValues(alpha: 0.2) : AppColors.surfaceContainer,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.wealth.withValues(alpha: 0.5) : AppColors.outlineVariant,
              ),
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.wealth : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyRadio extends StatelessWidget {
  const _CurrencyRadio({
    required this.title,
    required this.subtitle,
    required this.isSelected,
  });

  final String title;
  final String subtitle;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 12),
      borderRadius: 8,
      backgroundColor: isSelected ? AppColors.wealth.withValues(alpha: 0.1) : null,
      borderColor: isSelected ? AppColors.wealth.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.wealth : AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(width: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: (isSelected ? AppColors.wealth : AppColors.onSurfaceVariant).withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          TextField(
            controller: TextEditingController(text: value),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurface,
                ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
