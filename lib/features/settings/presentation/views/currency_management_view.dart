import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/features/converter/domain/entities/calculator_currency.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
import 'package:boveda_personal/features/settings/presentation/widgets/currency_form_sheet.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyManagementView extends ConsumerStatefulWidget {
  const CurrencyManagementView({super.key});

  @override
  ConsumerState<CurrencyManagementView> createState() => _CurrencyManagementViewState();
}

class _CurrencyManagementViewState extends ConsumerState<CurrencyManagementView> {
  void _showCurrencyForm([CalculatorCurrency? currency]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CurrencyFormSheet(currency: currency),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currenciesAsync = ref.watch(calculatorCurrenciesProvider);

    return MainScaffold(
      title: 'Administrar Monedas',
      showBackButton: true,
      showBottomNav: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configura las tasas de referencia globales.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showCurrencyForm(),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Nueva Moneda'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.wealth,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.wealth.withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          currenciesAsync.when(
            data: (currencies) {
              return Column(
                children: currencies.map((currency) {
                  final isBase = currency.currency.code == 'USD';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _CurrencyCard(
                      symbol: currency.symbol,
                      name: currency.name,
                      code: isBase ? '${currency.currency.code} • Moneda Base' : currency.currency.code,
                      value: currency.unitsPerUsd.toStringAsFixed(2),
                      isBase: isBase,
                      isEnabled: currency.isActive,
                      onChanged: isBase 
                        ? null 
                        : (val) => ref.read(calculatorCurrenciesProvider.notifier).toggleActive(currency.id, val),
                      onEdit: isBase
                        ? null
                        : () => _showCurrencyForm(currency),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _CurrencyCard extends StatelessWidget {
  const _CurrencyCard({
    required this.symbol,
    required this.name,
    required this.code,
    required this.value,
    required this.isBase,
    required this.isEnabled,
    required this.onChanged,
    this.onEdit,
  });

  final String symbol;
  final String name;
  final String code;
  final String value;
  final bool isBase;
  final bool isEnabled;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                alignment: Alignment.center,
                child: Text(
                  symbol,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isEnabled ? AppColors.wealth : AppColors.onSurfaceVariant,
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isEnabled ? AppColors.onSurface : AppColors.onSurfaceVariant,
                          ),
                    ),
                    Text(
                      code,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1.0,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBase ? 'Valor ref. (Fijo)' : 'Valor ref. (1 USD)',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isEnabled ? AppColors.onSurface : AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              Row(
                children: [
                  if (isBase)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.lock, color: AppColors.onSurfaceVariant, size: 20),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      color: AppColors.onSurfaceVariant,
                      onPressed: onEdit,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Switch(
                    value: isEnabled,
                    onChanged: isBase ? null : (val) => onChanged?.call(val),
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.wealth,
                    inactiveThumbColor: AppColors.onSurfaceVariant,
                    inactiveTrackColor: AppColors.surfaceHighest,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
