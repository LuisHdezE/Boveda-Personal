import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';

class AccountBalance {
  const AccountBalance({
    required this.accountId,
    required this.userId,
    required this.currency,
    required this.balance,
  });

  final String accountId;
  final String userId;
  final Currency currency;
  final Money balance;

  @override
  bool operator ==(Object other) {
    return other is AccountBalance &&
        other.accountId == accountId &&
        other.userId == userId &&
        other.currency == currency &&
        other.balance == balance;
  }

  @override
  int get hashCode => Object.hash(accountId, userId, currency, balance);
}
