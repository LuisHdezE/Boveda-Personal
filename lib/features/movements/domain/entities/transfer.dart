import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:decimal/decimal.dart';

class Transfer {
  const Transfer({
    required this.id,
    required this.sourceAccountId,
    required this.destinationAccountId,
    required this.sourceAmount,
    required this.destinationAmount,
    required this.exchangeRate,
    required this.occurredAt,
    required this.createdAt,
    required this.updatedAt,
    this.note,
  });

  final String id;
  final String sourceAccountId;
  final String destinationAccountId;
  final Money sourceAmount;
  final Money destinationAmount;
  final Decimal exchangeRate;
  final DateTime occurredAt;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transfer copyWith({
    String? sourceAccountId,
    String? destinationAccountId,
    Money? sourceAmount,
    Money? destinationAmount,
    Decimal? exchangeRate,
    DateTime? occurredAt,
    String? note,
    bool clearNote = false,
    DateTime? updatedAt,
  }) {
    return Transfer(
      id: id,
      sourceAccountId: sourceAccountId ?? this.sourceAccountId,
      destinationAccountId: destinationAccountId ?? this.destinationAccountId,
      sourceAmount: sourceAmount ?? this.sourceAmount,
      destinationAmount: destinationAmount ?? this.destinationAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      occurredAt: occurredAt ?? this.occurredAt,
      note: clearNote ? null : note ?? this.note,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Transfer &&
        other.id == id &&
        other.sourceAccountId == sourceAccountId &&
        other.destinationAccountId == destinationAccountId &&
        other.sourceAmount == sourceAmount &&
        other.destinationAmount == destinationAmount &&
        other.exchangeRate == exchangeRate &&
        other.occurredAt == occurredAt &&
        other.note == note &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceAccountId,
    destinationAccountId,
    sourceAmount,
    destinationAmount,
    exchangeRate,
    occurredAt,
    note,
    createdAt,
    updatedAt,
  );
}
