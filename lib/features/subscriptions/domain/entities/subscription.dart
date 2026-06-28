import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';

class Subscription {
  const Subscription({
    required this.id,
    required this.name,
    required this.amount,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.lastPaymentDate,
  });

  final String id;
  final String name;
  final Money amount;
  final String billingCycle;
  final DateTime nextBillingDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastPaymentDate;

  Subscription copyWith({
    String? name,
    Money? amount,
    String? billingCycle,
    DateTime? nextBillingDate,
    bool? isActive,
    DateTime? lastPaymentDate,
  }) {
    return Subscription(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
    );
  }
}
