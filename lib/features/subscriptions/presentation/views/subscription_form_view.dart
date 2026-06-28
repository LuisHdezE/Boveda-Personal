import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/subscriptions/domain/entities/subscription.dart';
import 'package:boveda_personal/features/subscriptions/presentation/providers/subscriptions_provider.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SubscriptionFormView extends ConsumerStatefulWidget {
  const SubscriptionFormView({super.key, this.subscription});

  final Subscription? subscription;

  @override
  ConsumerState<SubscriptionFormView> createState() =>
      _SubscriptionFormViewState();
}

class _SubscriptionFormViewState extends ConsumerState<SubscriptionFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  String _currencyCode = 'USD';
  String _billingCycle = 'monthly';
  late DateTime _nextBillingDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.subscription?.name ?? '',
    );
    _amountController = TextEditingController(
      text: widget.subscription != null
          ? widget.subscription!.amount.majorUnits
          : '',
    );
    if (widget.subscription != null) {
      _currencyCode = widget.subscription!.amount.currency.code;
      _billingCycle = widget.subscription!.billingCycle;
      _nextBillingDate = widget.subscription!.nextBillingDate;
    } else {
      _nextBillingDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextBillingDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _nextBillingDate) {
      setState(() {
        _nextBillingDate = picked;
      });
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final idGenerator = ref.read(idGeneratorProvider);
    final isEditing = widget.subscription != null;

    final amountDouble = double.tryParse(_amountController.text) ?? 0.0;
    final minorUnits = (amountDouble * 100).round();

    final subscription = Subscription(
      id: isEditing ? widget.subscription!.id : idGenerator.next(),
      name: _nameController.text.trim(),
      amount: Money(
        minorUnits: minorUnits,
        currency: Currency(code: _currencyCode, scale: 2),
      ),
      billingCycle: _billingCycle,
      nextBillingDate: _nextBillingDate,
      isActive: true,
      createdAt: isEditing ? widget.subscription!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
      lastPaymentDate: isEditing ? widget.subscription!.lastPaymentDate : null,
    );

    final notifier = ref.read(subscriptionsProvider.notifier);
    if (isEditing) {
      await notifier.updateSubscription(subscription);
    } else {
      await notifier.addSubscription(subscription);
    }

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: widget.subscription != null
          ? 'Editar Suscripción'
          : 'Nueva Suscripción',
      showBackButton: true,
      showBottomNav: false,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la suscripción (ej. Netflix)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Importe',
                            border: OutlineInputBorder(),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Requerido';
                            if (double.tryParse(val) == null)
                              return 'Monto inválido';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: DropdownButtonFormField<String>(
                          value: _currencyCode,
                          decoration: const InputDecoration(
                            labelText: 'Moneda',
                            border: OutlineInputBorder(),
                          ),
                          items: ['USD', 'EUR', 'CUP'].map((e) {
                            return DropdownMenuItem(value: e, child: Text(e));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null)
                              setState(() => _currencyCode = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _billingCycle,
                    decoration: const InputDecoration(
                      labelText: 'Ciclo de facturación',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'monthly',
                        child: Text('Mensual'),
                      ),
                      DropdownMenuItem(value: 'yearly', child: Text('Anual')),
                      DropdownMenuItem(value: 'weekly', child: Text('Semanal')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _billingCycle = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Próxima fecha de cobro',
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_nextBillingDate.day}/${_nextBillingDate.month}/${_nextBillingDate.year}',
                          ),
                          const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.wealth,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(
                  color: AppColors.surface,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
