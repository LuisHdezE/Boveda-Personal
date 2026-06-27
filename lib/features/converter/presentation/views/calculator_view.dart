import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
class CalculatorView extends ConsumerStatefulWidget {
  const CalculatorView({super.key});

  @override
  ConsumerState<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends ConsumerState<CalculatorView> {
  final _amountController = TextEditingController(text: '12500');

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Calculadora Universal',
      showBackButton: true,
      showBottomNav: false,
      child: ListView(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 40 + MediaQuery.paddingOf(context).bottom),
        children: [
          Text(
            'Conversión en tiempo real sin impacto en saldos.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          // Search Bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurface,
                        ),
                    decoration: InputDecoration(
                      hintText: 'Buscar moneda (ej. JPY, EUR)...',
                      hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
          const SizedBox(height: 24),
          // Base Currency Card
          Stack(
            children: [
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'IMPORTE BASE',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                                letterSpacing: 1.5,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'USD',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.keyboard_arrow_down, color: AppColors.onSurface, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '\$',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.wealth.withValues(alpha: 0.5),
                              ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: AppColors.wealth,
                                  fontWeight: FontWeight.w600,
                                ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(bottom: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dólar Estadounidense',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                        Text(
                          '1.00 USD = Base',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Glow effect / gradient
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.wealth.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          'CONVERSIONES ACTIVAS',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.5,
              ),
        ),
        const SizedBox(height: 8),
        
        // Dynamic list of active currencies
        Consumer(
          builder: (context, ref, _) {
            final currenciesAsync = ref.watch(calculatorCurrenciesProvider);
            return currenciesAsync.when(
              data: (currencies) {
                final active = currencies.where((c) => c.isActive && c.currency.code != 'USD').toList();
                if (active.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No hay monedas activas',
                        style: TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                    ),
                  );
                }

                // Parse input amount
                final inputAmount = double.tryParse(_amountController.text) ?? 0.0;

                return Column(
                  children: active.map((currency) {
                    final convertedAmount = inputAmount * currency.unitsPerUsd.toDouble();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ConversionItem(
                        symbol: currency.symbol,
                        currency: currency.currency.code,
                        name: currency.name,
                        amount: convertedAmount.toStringAsFixed(2),
                        rate: currency.unitsPerUsd.toStringAsFixed(3),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            );
          },
        ),

        const SizedBox(height: 24),
        InkWell(
          onTap: () {
            // TODO: Open currency management or selector
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_circle_outline, color: AppColors.wealth),
                const SizedBox(width: 8),
                Text(
                  'Administrar Monedas',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    ),
    );
  }
}

class _ConversionItem extends StatelessWidget {
  const _ConversionItem({
    required this.symbol,
    required this.currency,
    required this.name,
    required this.amount,
    required this.rate,
  });

  final String symbol;
  final String currency;
  final String name;
  final String amount;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            alignment: Alignment.center,
            child: Text(
              symbol,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currency,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                ),
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
              Text(
                'Tasa: $rate',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
