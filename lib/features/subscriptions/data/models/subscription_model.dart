import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/features/subscriptions/domain/entities/subscription.dart';

class SubscriptionModel {
  const SubscriptionModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.amountMinor,
    required this.currencyCode,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.lastPaymentDate,
  });

  final String id;
  final String userId;
  final String name;
  final int amountMinor;
  final String currencyCode;
  final String billingCycle;
  final DateTime nextBillingDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastPaymentDate;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'amount_minor': amountMinor,
      'currency_code': currencyCode,
      'billing_cycle': billingCycle,
      'next_billing_date': RowConverters.dateToSql(nextBillingDate),
      'is_active': isActive ? 1 : 0,
      'created_at': RowConverters.dateToSql(createdAt),
      'updated_at': RowConverters.dateToSql(updatedAt),
      'last_payment_date': lastPaymentDate != null
          ? RowConverters.dateToSql(lastPaymentDate!)
          : null,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      amountMinor: map['amount_minor'] as int,
      currencyCode: map['currency_code'] as String,
      billingCycle: map['billing_cycle'] as String,
      nextBillingDate: RowConverters.dateFromSql(
        map['next_billing_date'] as Object,
      ),
      isActive: (map['is_active'] as int) == 1,
      createdAt: RowConverters.dateFromSql(map['created_at'] as Object),
      updatedAt: RowConverters.dateFromSql(map['updated_at'] as Object),
      lastPaymentDate: map['last_payment_date'] != null
          ? RowConverters.dateFromSql(map['last_payment_date'] as Object)
          : null,
    );
  }
}
