import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/features/simulator/domain/simulation_data.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SimulatorView extends ConsumerStatefulWidget {
  const SimulatorView({super.key});

  @override
  ConsumerState<SimulatorView> createState() => _SimulatorViewState();
}

class _SimulatorViewState extends ConsumerState<SimulatorView> {
  String _currency = 'CUP';
  final _initialBalanceController = TextEditingController(text: '100000');
  final _monthlySavingsController = TextEditingController(text: '25000');
  final _rateController = TextEditingController(text: '10');
  double _years = 5;

  @override
  void dispose() {
    _initialBalanceController.dispose();
    _monthlySavingsController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Simulador',
      showBackButton: true,
      showBottomNav: false,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                Text(
                  'Proyecta tu crecimiento financiero ajustando tus variables iniciales.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                // Currency
                GlassCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Moneda de Proyección',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Expanded(
                              child: _CurrencyTab(
                                label: 'CUP (\$)',
                                isSelected: _currency == 'CUP',
                                onTap: () => setState(() => _currency = 'CUP'),
                              ),
                            ),
                            Expanded(
                              child: _CurrencyTab(
                                label: 'USD (U\$D)',
                                isSelected: _currency == 'USD',
                                onTap: () => setState(() => _currency = 'USD'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Inputs
                GlassCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _SimulatorInput(
                        label: 'Saldo Inicial',
                        controller: _initialBalanceController,
                      ),
                      Divider(height: 24, color: Colors.white.withValues(alpha: 0.05)),
                      _SimulatorInput(
                        label: 'Ahorro Mensual Estimado',
                        controller: _monthlySavingsController,
                      ),
                      Divider(height: 24, color: Colors.white.withValues(alpha: 0.05)),
                      _SimulatorInput(
                        label: 'Tasa Anual Esperada (%)',
                        controller: _rateController,
                        prefix: '%',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Slider
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Tiempo de Proyección',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                _years.toInt().toString(),
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppColors.wealth,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Años',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.wealth,
                          inactiveTrackColor: AppColors.surfaceHigh,
                          thumbColor: AppColors.wealth,
                          overlayColor: AppColors.wealth.withValues(alpha: 0.2),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: _years,
                          min: 1,
                          max: 30,
                          divisions: 29,
                          onChanged: (val) => setState(() => _years = val),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1 año',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                          Text(
                            '30 años',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Actions
          Container(
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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: AppColors.wealth.withValues(alpha: 0.8), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Los resultados de este simulador son proyecciones basadas en tasas estimadas e información histórica. No constituyen asesoramiento financiero ni garantizan rendimientos futuros.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    final initial = double.tryParse(_initialBalanceController.text) ?? 0;
                    final savings = double.tryParse(_monthlySavingsController.text) ?? 0;
                    final rate = double.tryParse(_rateController.text) ?? 0;
                    final data = SimulationData(
                      initialBalance: initial,
                      monthlySavings: savings,
                      annualRate: rate,
                      years: _years.toInt(),
                      currency: _currency,
                    );
                    context.push('/simulator/result', extra: data);
                  },
                  icon: const Icon(Icons.trending_up, color: Colors.black),
                  label: Text(
                    'Calcular Proyección',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.wealth,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    shadowColor: AppColors.wealth.withValues(alpha: 0.3),
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

class _CurrencyTab extends StatelessWidget {
  const _CurrencyTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.wealth : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
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

class _SimulatorInput extends StatelessWidget {
  const _SimulatorInput({
    required this.label,
    required this.controller,
    this.prefix = '\$',
  });

  final String label;
  final TextEditingController controller;
  final String prefix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Text(
                prefix,
                style: const TextStyle(
                  fontSize: 22,
                  color: AppColors.wealth,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
