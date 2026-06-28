import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/debts/domain/entities/debt.dart';
import 'package:boveda_personal/features/debts/presentation/providers/debts_provider.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class DebtFormView extends ConsumerStatefulWidget {
  const DebtFormView({super.key, this.debt});

  final Debt? debt;

  @override
  ConsumerState<DebtFormView> createState() => _DebtFormViewState();
}

class _DebtFormViewState extends ConsumerState<DebtFormView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _installmentsController = TextEditingController();

  DateTime? _dueDate;
  String _selectedCurrency = 'USD';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.debt != null) {
      final d = widget.debt!;
      _nameController.text = d.name;
      _amountController.text = (d.amount.minorUnits / 100).toStringAsFixed(2);
      _selectedCurrency = d.amount.currency.code;
      _dueDate = d.dueDate;
      if (d.totalInstallments != null) {
        _installmentsController.text = d.totalInstallments.toString();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _installmentsController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final amountValue = double.parse(_amountController.text);
      final installmentsValue = _installmentsController.text.isNotEmpty 
          ? int.tryParse(_installmentsController.text)
          : null;
          
      final amount = Money.parseMajor(
        amountValue.toStringAsFixed(2),
        currency: Currency(code: _selectedCurrency, scale: 2),
      );
      
      final provider = ref.read(debtsProvider.notifier);
      
      if (widget.debt == null) {
        final newDebt = Debt(
          id: const Uuid().v4(),
          name: _nameController.text.trim(),
          amount: amount,
          remainingAmount: amount, // Start with full remaining amount
          totalInstallments: installmentsValue,
          paidInstallments: 0,
          dueDate: _dueDate,
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await provider.addDebt(newDebt);
      } else {
        final d = widget.debt!;
        // Handle changes in amount keeping the paid proportion in mind. For simplicity, just update amount and let the user manage it.
        // If they edit the amount, the remaining amount should probably change by the same difference, 
        // or just stay what it was if it's editing name only.
        final diff = amount.minorUnits - d.amount.minorUnits;
        final newRemainingMinor = d.remainingAmount.minorUnits + diff;
        
        final updatedDebt = d.copyWith(
          name: _nameController.text.trim(),
          amount: amount,
          remainingAmount: Money(minorUnits: newRemainingMinor < 0 ? 0 : newRemainingMinor, currency: amount.currency),
          totalInstallments: installmentsValue,
          dueDate: _dueDate,
          clearDueDate: _dueDate == null,
        );
        await provider.updateDebt(updatedDebt);
      }
      
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final isEditing = widget.debt != null;

    return MainScaffold(
      title: isEditing ? 'Editar Deuda' : 'Nueva Deuda',
      showBackButton: true,
      showBottomNav: false,
      child: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (settings) {
          final currencies = [
            settings?.primaryCurrencyCode ?? 'USD', 
            settings?.secondaryCurrencyCode ?? 'CUP'
          ].toSet().toList();
          
          if (!currencies.contains(_selectedCurrency)) {
            _selectedCurrency = currencies.first;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la deuda',
                      prefixIcon: Icon(Icons.label_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Monto Original',
                            prefixIcon: Icon(Icons.attach_money),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Requerido';
                            if (double.tryParse(v) == null) return 'Monto inválido';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCurrency,
                          decoration: InputDecoration(
                            labelText: 'Moneda',
                            filled: true,
                            fillColor: AppColors.surfaceHighest,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: currencies.map<DropdownMenuItem<String>>((c) {
                            return DropdownMenuItem(value: c, child: Text(c));
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedCurrency = v);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _installmentsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Plazos / Cuotas (Opcional)',
                      prefixIcon: Icon(Icons.format_list_numbered),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v != null && v.isNotEmpty && int.tryParse(v) == null) {
                        return 'Número inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _selectDueDate,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _dueDate != null
                                  ? 'Fecha límite: ${DateFormat('dd MMM yyyy').format(_dueDate!)}'
                                  : 'Sin fecha límite',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: _dueDate != null
                                        ? AppColors.onSurface
                                        : AppColors.onSurfaceVariant,
                                  ),
                            ),
                          ),
                          if (_dueDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => setState(() => _dueDate = null),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: _isLoading ? null : _save,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            isEditing ? 'Guardar Cambios' : 'Registrar Deuda',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
