import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';

class Debt {
  const Debt({
    required this.id,
    required this.name,
    required this.amount,
    required this.remainingAmount,
    this.totalInstallments,
    required this.paidInstallments,
    this.dueDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final Money amount;
  final Money remainingAmount;
  final int? totalInstallments;
  final int paidInstallments;
  final DateTime? dueDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Debt copyWith({
    String? name,
    Money? amount,
    Money? remainingAmount,
    int? totalInstallments,
    int? paidInstallments,
    DateTime? dueDate,
    bool clearDueDate = false,
    bool? isActive,
  }) {
    return Debt(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      paidInstallments: paidInstallments ?? this.paidInstallments,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
