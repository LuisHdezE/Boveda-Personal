import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConverterView extends ConsumerStatefulWidget {
  const ConverterView({super.key});

  @override
  ConsumerState<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends ConsumerState<ConverterView> {
  final _amountController = TextEditingController(text: '100000');
  bool _isArsToUsd = true;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _swapCurrencies() {
    setState(() {
      _isArsToUsd = !_isArsToUsd;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Conversión de Moneda',
      showBackButton: true,
      showBottomNav: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          Text(
            'Transfiere fondos entre tus saldos de ARS y USD al instante.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Stack(
              children: [
                // Background radial gradient texture
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topRight,
                        radius: 1.5,
                        colors: [
                          AppColors.wealth.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Account Selector
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            _AccountSelector(
                              label: 'Origen',
                              currencySymbol: _isArsToUsd ? 'AR\$' : 'U\$D',
                              currencyColor: _isArsToUsd ? AppColors.onSurface : AppColors.wealth,
                              accountName: _isArsToUsd ? 'Caja de Ahorro' : 'Cuenta Corriente',
                              balance: _isArsToUsd ? '\$ 1.500.000,00' : 'USD 4.250,00',
                            ),
                            const SizedBox(height: 16),
                            _AccountSelector(
                              label: 'Destino',
                              currencySymbol: _isArsToUsd ? 'U\$D' : 'AR\$',
                              currencyColor: _isArsToUsd ? AppColors.wealth : AppColors.onSurface,
                              accountName: _isArsToUsd ? 'Cuenta Corriente' : 'Caja de Ahorro',
                              balance: _isArsToUsd ? 'USD 4.250,00' : '\$ 1.500.000,00',
                            ),
                          ],
                        ),
                        // Swap button
                        InkWell(
                          onTap: _swapCurrencies,
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.swap_vert,
                              color: AppColors.wealth,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Amount Input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Importe a convertir (${_isArsToUsd ? 'AR\$' : 'U\$D'})',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '\$',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppColors.onSurface,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _amountController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: AppColors.onSurface,
                                      ),
                                  decoration: InputDecoration(
                                    hintText: '0.00',
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Exchange Rate
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tipo de cambio (Venta)',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '1 USD = 1.050,00 ARS',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.onSurface,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Divider(color: Colors.white.withValues(alpha: 0.05)),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recibirás (Aprox)',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.onSurface,
                                ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _isArsToUsd ? 'USD 95,23' : 'ARS 105.000,00',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.wealth,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.wealth,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 8,
                        shadowColor: AppColors.wealth.withValues(alpha: 0.15),
                      ),
                      child: Text(
                        'Realizar Conversión',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountSelector extends StatelessWidget {
  const _AccountSelector({
    required this.label,
    required this.currencySymbol,
    required this.currencyColor,
    required this.accountName,
    required this.balance,
  });

  final String label;
  final String currencySymbol;
  final Color currencyColor;
  final String accountName;
  final String balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceHighest,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  currencySymbol,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: currencyColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      accountName,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.onSurface,
                          ),
                    ),
                    Text(
                      balance,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.expand_more, color: AppColors.onSurfaceVariant),
            ],
          ),
        ],
      ),
    );
  }
}
