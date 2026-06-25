import 'package:boveda_personal/core/domain/value_objects/money.dart';

enum MovementType {
  opening,
  income,
  expense,
  transferIn('transfer_in'),
  transferOut('transfer_out'),
  adjustment;

  const MovementType([String? storageValue])
      : storageValue = storageValue ?? '';

  final String storageValue;

  String get value => storageValue.isEmpty ? name : storageValue;

  static MovementType fromStorage(String value) {
    return values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw FormatException('Unknown movement type: $value'),
    );
  }
}

class Movement {
  const Movement({
    required this.id,
    required this.accountId,
    required this.type,
    required this.amount,
    required this.occurredAt,
    required this.createdAt,
    required this.updatedAt,
    this.categoryId,
    this.transferId,
    this.note,
  });

  final String id;
  final String accountId;
  final String? categoryId;
  final String? transferId;
  final MovementType type;
  final Money amount;
  final DateTime occurredAt;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isCredit {
    return switch (type) {
      MovementType.opening ||
      MovementType.income ||
      MovementType.transferIn ||
      MovementType.adjustment =>
        true,
      MovementType.expense || MovementType.transferOut => false,
    };
  }

  bool get isDebit => !isCredit;
  bool get isTransfer =>
      type == MovementType.transferIn || type == MovementType.transferOut;
  int get signedMinorUnits =>
      isCredit ? amount.minorUnits : -amount.minorUnits;

  Movement copyWith({
    String? accountId,
    String? categoryId,
    bool clearCategoryId = false,
    String? transferId,
    bool clearTransferId = false,
    MovementType? type,
    Money? amount,
    DateTime? occurredAt,
    String? note,
    bool clearNote = false,
    DateTime? updatedAt,
  }) {
    return Movement(
      id: id,
      accountId: accountId ?? this.accountId,
      categoryId: clearCategoryId ? null : categoryId ?? this.categoryId,
      transferId: clearTransferId ? null : transferId ?? this.transferId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      occurredAt: occurredAt ?? this.occurredAt,
      note: clearNote ? null : note ?? this.note,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Movement &&
        other.id == id &&
        other.accountId == accountId &&
        other.categoryId == categoryId &&
        other.transferId == transferId &&
        other.type == type &&
        other.amount == amount &&
        other.occurredAt == occurredAt &&
        other.note == note &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        accountId,
        categoryId,
        transferId,
        type,
        amount,
        occurredAt,
        note,
        createdAt,
        updatedAt,
      );
}
