import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/dashboard/presentation/providers.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/presentation/providers.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConverterView extends ConsumerStatefulWidget {
  const ConverterView({super.key});

  @override
  ConsumerState<ConverterView> createState() => _ConverterViewState();
}

class _ConverterViewState extends ConsumerState<ConverterView> {
  final _amountController = TextEditingController();
  final _rateController = TextEditingController(text: '320'); // Default rate CUP/USD
  bool _isCupToUsd = true;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
    _rateController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    setState(() {}); // Rebuild to update "Recibirás (Aprox)"
  }

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _swapCurrencies() {
    setState(() {
      _isCupToUsd = !_isCupToUsd;
    });
  }

  Future<void> _performConversion() async {
    final balances = ref.read(accountBalancesProvider).value;
    if (balances == null) return;

    final cupAccount = balances.firstWhere((b) => b.currency.code == 'CUP', orElse: () => balances.first);
    final usdAccount = balances.firstWhere((b) => b.currency.code == 'USD', orElse: () => balances.last);

    final sourceAccount = _isCupToUsd ? cupAccount : usdAccount;
    final targetAccount = _isCupToUsd ? usdAccount : cupAccount;

    final sourceAmountStr = _amountController.text.replaceAll(',', '.');
    final rateStr = _rateController.text.replaceAll(',', '.');

    final sourceAmount = double.tryParse(sourceAmountStr) ?? 0;
    final rate = double.tryParse(rateStr) ?? 0;

    if (sourceAmount <= 0 || rate <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa montos válidos')),
      );
      return;
    }

    final sourceMinorUnits = (sourceAmount * 100).toInt();
    if (sourceMinorUnits > sourceAccount.balance.minorUnits) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo insuficiente en la cuenta de origen')),
      );
      return;
    }

    // Calculate target amount
    double targetAmount;
    if (_isCupToUsd) {
      targetAmount = sourceAmount / rate;
    } else {
      targetAmount = sourceAmount * rate;
    }
    final targetMinorUnits = (targetAmount * 100).toInt();

    final now = DateTime.now();
    final repo = ref.read(movementRepositoryProvider);
    final idGen = ref.read(idGeneratorProvider);

    // 1. Withdrawal (Expense)
    final expense = Movement(
      id: idGen.next(),
      accountId: sourceAccount.accountId,
      type: MovementType.expense,
      amount: Money(minorUnits: sourceMinorUnits, currency: sourceAccount.currency),
      occurredAt: now,
      note: 'Conversión de moneda (Salida)',
      createdAt: now,
      updatedAt: now,
    );

    // 2. Deposit (Income)
    final income = Movement(
      id: idGen.next(),
      accountId: targetAccount.accountId,
      type: MovementType.income,
      amount: Money(minorUnits: targetMinorUnits, currency: targetAccount.currency),
      occurredAt: now,
      note: 'Conversión de moneda (Entrada)',
      createdAt: now,
      updatedAt: now,
    );

    try {
      await repo.create(expense);
      await repo.create(income);

      ref.invalidate(recentMovementsProvider);
      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(accountBalancesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conversión realizada con éxito')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al procesar la conversión')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final balances = ref.watch(accountBalancesProvider).value;
    if (balances == null) {
      return const MainScaffold(
        title: 'Conversión de Moneda',
        showBackButton: true,
        showBottomNav: false,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final cupAccount = balances.firstWhere((b) => b.currency.code == 'CUP', orElse: () => balances.first);
    final usdAccount = balances.firstWhere((b) => b.currency.code == 'USD', orElse: () => balances.last);

    final sourceAccount = _isCupToUsd ? cupAccount : usdAccount;
    final targetAccount = _isCupToUsd ? usdAccount : cupAccount;

    // Calculate approximate received amount
    final sourceAmount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
    final rate = double.tryParse(_rateController.text.replaceAll(',', '.')) ?? 0.0;
    
    double receivedAmount = 0.0;
    if (rate > 0) {
      if (_isCupToUsd) {
        receivedAmount = sourceAmount / rate;
      } else {
        receivedAmount = sourceAmount * rate;
      }
    }

    return MainScaffold(
      title: 'Conversión de Moneda',
      showBackButton: true,
      showBottomNav: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          Text(
            'Transfiere fondos entre tus saldos al instante.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Stack(
              children: [
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
                              currencySymbol: sourceAccount.currency.code == 'CUP' ? '\$' : 'USD',
                              currencyColor: _isCupToUsd ? AppColors.onSurface : AppColors.wealth,
                              accountName: 'Cuenta ${sourceAccount.currency.code}',
                              balance: (sourceAccount.balance.minorUnits / 100).toStringAsFixed(2),
                            ),
                            const SizedBox(height: 16),
                            _AccountSelector(
                              label: 'Destino',
                              currencySymbol: targetAccount.currency.code == 'CUP' ? '\$' : 'USD',
                              currencyColor: _isCupToUsd ? AppColors.wealth : AppColors.onSurface,
                              accountName: 'Cuenta ${targetAccount.currency.code}',
                              balance: (targetAccount.balance.minorUnits / 100).toStringAsFixed(2),
                            ),
                          ],
                        ),
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
                            'Importe a convertir (${sourceAccount.currency.code})',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                sourceAccount.currency.code == 'CUP' ? '\$' : 'USD',
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
                    // Rate Input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Text(
                            'Tasa 1 USD =',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _rateController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.onSurface,
                                  ),
                              decoration: InputDecoration(
                                hintText: '0.00',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'CUP',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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
                            '${targetAccount.currency.code == 'CUP' ? '\$' : 'USD'} ${receivedAmount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.wealth,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _performConversion,
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
            ],
          ),
        ],
      ),
    );
  }
}
