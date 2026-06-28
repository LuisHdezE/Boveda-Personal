import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/utils/currency_formatter.dart';
import 'package:boveda_personal/features/debts/domain/entities/debt.dart';
import 'package:boveda_personal/features/debts/presentation/providers/debts_provider.dart';
import 'package:boveda_personal/features/dashboard/presentation/providers.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DebtsView extends ConsumerWidget {
  const DebtsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtsAsync = ref.watch(debtsProvider);

    return MainScaffold(
      title: 'Deudas',
      showBackButton: true,
      showBottomNav: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.bar_chart),
          onPressed: () => context.push('/debts/stats'),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/debts/new'),
        backgroundColor: AppColors.wealth,
        child: const Icon(Icons.add, color: AppColors.surfaceHighest),
      ),
      child: debtsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (debts) {
          if (debts.isEmpty) {
            return _buildEmptyState(context);
          }
          
          final activeDebts = debts.where((d) => d.isActive).toList();
          final inactiveDebts = debts.where((d) => !d.isActive).toList();

          return CustomScrollView(
            slivers: [
              if (activeDebts.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text(
                      'Activas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: activeDebts.length,
                  itemBuilder: (context, index) {
                    final debt = activeDebts[index];
                    return _DebtListItem(debt: debt);
                  },
                ),
              ],
              if (inactiveDebts.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text(
                      'Pagadas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: inactiveDebts.length,
                  itemBuilder: (context, index) {
                    final debt = inactiveDebts[index];
                    return _DebtListItem(debt: debt);
                  },
                ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 80)), // Padding for FAB
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: AppColors.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay deudas registradas',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para añadir una',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _DebtListItem extends ConsumerWidget {
  const _DebtListItem({required this.debt});

  final Debt debt;

  void _showPaymentDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _PaymentDialog(debt: debt),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = 1.0 - (debt.remainingAmount.minorUnits / debt.amount.minorUnits);
    final progressClamped = progress.clamp(0.0, 1.0);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        debt.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (debt.dueDate != null)
                        Text(
                          'Vence: ${DateFormat('dd MMM yyyy').format(debt.dueDate!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      context.push('/debts/edit', extra: debt);
                    } else if (value == 'delete') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar Deuda'),
                          content: const Text('¿Estás seguro de que quieres eliminar esta deuda? Los pagos realizados quedarán en el historial pero ya no estarán vinculados a esta deuda.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(foregroundColor: AppColors.error),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirm == true) {
                        ref.read(debtsProvider.notifier).deleteDebt(debt.id);
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20, color: AppColors.onSurface),
                          SizedBox(width: 12),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: AppColors.error),
                          SizedBox(width: 12),
                          Text('Eliminar', style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Restante',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.formatAmountNeutral(debt.remainingAmount.minorUnits / 100, currencyCode: debt.amount.currency.code),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'Total: ${CurrencyFormatter.formatAmountNeutral(debt.amount.minorUnits / 100, currencyCode: debt.amount.currency.code)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressClamped,
                backgroundColor: AppColors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressClamped == 1.0 ? AppColors.wealth : AppColors.onSurface,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (debt.totalInstallments != null)
                  Text(
                    'Cuotas: ${debt.paidInstallments} / ${debt.totalInstallments}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  )
                else
                  Text(
                    'Pagos realizados: ${debt.paidInstallments}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                if (debt.isActive)
                  FilledButton.icon(
                    onPressed: () => _showPaymentDialog(context, ref),
                    icon: const Icon(Icons.payment, size: 16),
                    label: const Text('Abonar'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.onSurfaceVariant,
                      foregroundColor: AppColors.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentDialog extends ConsumerStatefulWidget {
  const _PaymentDialog({required this.debt});
  final Debt debt;

  @override
  ConsumerState<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends ConsumerState<_PaymentDialog> {
  final _amountController = TextEditingController();
  String? _selectedAccountId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Sugerir monto de cuota si hay plazos definidos y no se han pagado todos
    if (widget.debt.totalInstallments != null && widget.debt.totalInstallments! > 0) {
      final cuota = widget.debt.amount.minorUnits / widget.debt.totalInstallments!;
      _amountController.text = (cuota / 100).toStringAsFixed(2);
    } else {
      _amountController.text = (widget.debt.remainingAmount.minorUnits / 100).toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    final amountText = _amountController.text;
    final parsed = double.tryParse(amountText);
    if (parsed == null || parsed <= 0) return;
    if (_selectedAccountId == null) return;

    setState(() => _isLoading = true);
    
    try {
      final paymentAmount = Money.parseMajor(
        parsed.toStringAsFixed(2), 
        currency: widget.debt.amount.currency
      );
      
      final balances = ref.read(accountBalancesProvider).value;
      if (balances != null) {
        final accountBalance = balances.where((b) => b.accountId == _selectedAccountId).firstOrNull;
        if (accountBalance != null && accountBalance.balance.minorUnits < paymentAmount.minorUnits) {
          throw Exception('No hay saldo suficiente en la cuenta seleccionada.');
        }
      }
      
      await ref.read(debtsProvider.notifier).payDebt(
        widget.debt, 
        _selectedAccountId!, 
        paymentAmount
      );
      
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final balancesAsync = ref.watch(accountBalancesProvider);
    
    return AlertDialog(
      title: Text('Abonar a ${widget.debt.name}'),
      content: balancesAsync.when(
        loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
        error: (e, _) => Text('Error: $e'),
        data: (balances) {
          final accounts = balances.where((a) => a.currency.code == widget.debt.amount.currency.code).toList();
          
          if (accounts.isEmpty) {
            return Text('No tienes cuentas en ${widget.debt.amount.currency.code} para realizar este pago.');
          }
          
          if (_selectedAccountId == null && accounts.isNotEmpty) {
            _selectedAccountId = accounts.first.accountId;
          }
          
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monto a pagar',
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedAccountId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Cuenta origen',
                  prefixIcon: Icon(Icons.account_balance),
                ),
                items: accounts.map<DropdownMenuItem<String>>((acc) {
                  return DropdownMenuItem(
                    value: acc.accountId,
                    child: Text(
                      '${acc.accountName} (${CurrencyFormatter.formatAmountNeutral(acc.balance.minorUnits / 100, currencyCode: acc.balance.currency.code)})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedAccountId = v);
                },
              ),
            ],
          );
        }
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _isLoading || _selectedAccountId == null ? null : _pay,
          child: _isLoading 
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text('Pagar'),
        ),
      ],
    );
  }
}
