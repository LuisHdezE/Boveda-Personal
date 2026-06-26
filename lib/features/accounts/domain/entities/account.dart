import 'package:boveda_personal/core/domain/value_objects/currency.dart';

class Account {
  const Account({
    required this.id,
    required this.userId,
    required this.currency,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final Currency currency;
  final String name;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Account copyWith({String? name, bool? isActive, DateTime? updatedAt}) {
    return Account(
      id: id,
      userId: userId,
      currency: currency,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Account &&
        other.id == id &&
        other.userId == userId &&
        other.currency == currency &&
        other.name == name &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, currency, name, isActive, createdAt, updatedAt);
}
