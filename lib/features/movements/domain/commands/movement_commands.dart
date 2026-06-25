import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:decimal/decimal.dart';

class MovementDraft {
  MovementDraft({
    required this.accountId,
    required this.categoryId,
    required this.type,
    required this.amount,
    required this.occurredAt,
    String? note,
  }) : note = _normalizeNote(note) {
    if (amount.minorUnits <= 0) {
      throw ArgumentError.value(amount, 'amount', 'Must be positive');
    }
    if (type != MovementType.income && type != MovementType.expense) {
      throw ArgumentError('Ordinary movement draft must be income or expense');
    }
    if (categoryId.trim().isEmpty || accountId.trim().isEmpty) {
      throw ArgumentError('Account and category are required');
    }
  }

  final String accountId;
  final String categoryId;
  final MovementType type;
  final Money amount;
  final DateTime occurredAt;
  final String? note;

  @override
  bool operator ==(Object other) {
    return other is MovementDraft &&
        other.accountId == accountId &&
        other.categoryId == categoryId &&
        other.type == type &&
        other.amount == amount &&
        other.occurredAt == occurredAt &&
        other.note == note;
  }

  @override
  int get hashCode => Object.hash(
        accountId,
        categoryId,
        type,
        amount,
        occurredAt,
        note,
      );
}

class TransferDraft {
  TransferDraft({
    required this.sourceAccountId,
    required this.destinationAccountId,
    required this.sourceAmount,
    required this.destinationAmount,
    required this.exchangeRate,
    required this.occurredAt,
    String? note,
  }) : note = _normalizeNote(note) {
    if (sourceAccountId == destinationAccountId) {
      throw ArgumentError('Transfer accounts must differ');
    }
    if (sourceAmount.minorUnits <= 0 || destinationAmount.minorUnits <= 0) {
      throw ArgumentError('Transfer amounts must be positive');
    }
    if (exchangeRate <= Decimal.zero) {
      throw ArgumentError.value(exchangeRate, 'exchangeRate');
    }
    if (sourceAmount.currency == destinationAmount.currency) {
      throw ArgumentError('Transfer currencies must differ');
    }
  }

  final String sourceAccountId;
  final String destinationAccountId;
  final Money sourceAmount;
  final Money destinationAmount;
  final Decimal exchangeRate;
  final DateTime occurredAt;
  final String? note;

  @override
  bool operator ==(Object other) {
    return other is TransferDraft &&
        other.sourceAccountId == sourceAccountId &&
        other.destinationAccountId == destinationAccountId &&
        other.sourceAmount == sourceAmount &&
        other.destinationAmount == destinationAmount &&
        other.exchangeRate == exchangeRate &&
        other.occurredAt == occurredAt &&
        other.note == note;
  }

  @override
  int get hashCode => Object.hash(
        sourceAccountId,
        destinationAccountId,
        sourceAmount,
        destinationAmount,
        exchangeRate,
        occurredAt,
        note,
      );
}

String? _normalizeNote(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}
