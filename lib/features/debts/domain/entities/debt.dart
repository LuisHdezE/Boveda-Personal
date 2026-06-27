import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';

class Debt {
  const Debt({
    required this.id,
    required this.name,
    required this.amount,
    this.dueDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final Money amount;
  final DateTime? dueDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Debt copyWith({
    String? name,
    Money? amount,
    DateTime? dueDate,
    bool clearDueDate = false,
    bool? isActive,
  }) {
    return Debt(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      dueDate: clearDueDate ? null : dueDate ?? this.dueDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
