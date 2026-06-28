import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/features/debts/domain/entities/debt.dart';

class DebtModel {
  const DebtModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.amountMinor,
    required this.remainingAmountMinor,
    this.totalInstallments,
    required this.paidInstallments,
    required this.currencyCode,
    this.dueDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String name;
  final int amountMinor;
  final int remainingAmountMinor;
  final int? totalInstallments;
  final int paidInstallments;
  final String currencyCode;
  final DateTime? dueDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'amount_minor': amountMinor,
      'remaining_amount_minor': remainingAmountMinor,
      'total_installments': totalInstallments,
      'paid_installments': paidInstallments,
      'currency_code': currencyCode,
      'due_date': dueDate != null ? RowConverters.dateToSql(dueDate!) : null,
      'is_active': RowConverters.boolToSql(isActive),
      'created_at': RowConverters.dateToSql(createdAt),
      'updated_at': RowConverters.dateToSql(updatedAt),
    };
  }

  factory DebtModel.fromMap(Map<String, dynamic> map) {
    return DebtModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      name: map['name'] as String,
      amountMinor: map['amount_minor'] as int,
      remainingAmountMinor: map['remaining_amount_minor'] as int? ?? map['amount_minor'] as int, // Fallback por si acaso
      totalInstallments: map['total_installments'] as int?,
      paidInstallments: map['paid_installments'] as int? ?? 0,
      currencyCode: map['currency_code'] as String,
      dueDate: map['due_date'] != null ? RowConverters.dateFromSql(map['due_date'] as Object) : null,
      isActive: RowConverters.boolFromSql(map['is_active'] as Object),
      createdAt: RowConverters.dateFromSql(map['created_at'] as Object),
      updatedAt: RowConverters.dateFromSql(map['updated_at'] as Object),
    );
  }
}
