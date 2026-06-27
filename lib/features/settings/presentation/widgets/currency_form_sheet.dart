import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/features/converter/domain/entities/calculator_currency.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class CurrencyFormSheet extends ConsumerStatefulWidget {
  const CurrencyFormSheet({
    super.key,
    this.currency,
  });

  final CalculatorCurrency? currency;

  @override
  ConsumerState<CurrencyFormSheet> createState() => _CurrencyFormSheetState();
}

class _CurrencyFormSheetState extends ConsumerState<CurrencyFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _symbolController;
  late TextEditingController _unitsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currency?.name ?? '');
    _codeController = TextEditingController(text: widget.currency?.currency.code ?? '');
    _symbolController = TextEditingController(text: widget.currency?.symbol ?? '');
    _unitsController = TextEditingController(text: widget.currency?.unitsPerUsd.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _symbolController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final newCurrency = CalculatorCurrency(
        id: widget.currency?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        currency: Currency(code: _codeController.text.trim().toUpperCase(), scale: 2),
        symbol: _symbolController.text.trim(),
        unitsPerUsd: Decimal.parse(_unitsController.text.trim()),
        isActive: widget.currency?.isActive ?? true,
        createdAt: widget.currency?.createdAt ?? now,
        updatedAt: now,
      );

      ref.read(calculatorCurrenciesProvider.notifier).saveCurrency(newCurrency);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.currency == null ? 'Nueva Moneda' : 'Editar Moneda',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.onSurface),
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Moneda',
                  hintText: 'Ej. Peso Cubano',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codeController,
                      style: const TextStyle(color: AppColors.onSurface),
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Código (ISO)',
                        hintText: 'Ej. CUP',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Obligatorio';
                        }
                        if (value.trim().length < 3) {
                          return 'Mín. 3 letras';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _symbolController,
                      style: const TextStyle(color: AppColors.onSurface),
                      decoration: const InputDecoration(
                        labelText: 'Símbolo',
                        hintText: 'Ej. \$',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Obligatorio';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unitsController,
                style: const TextStyle(color: AppColors.onSurface),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor de 1 USD en esta moneda',
                  hintText: 'Ej. 1050.50',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El valor es obligatorio';
                  }
                  try {
                    final dec = Decimal.parse(value.trim());
                    if (dec <= Decimal.zero) {
                      return 'Debe ser mayor a 0';
                    }
                  } catch (e) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.wealth,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Guardar',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
