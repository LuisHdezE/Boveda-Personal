import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account_balance.dart';

abstract final class AccountBalanceModel {
  static AccountBalance fromRow(Map<String, Object?> row) {
    final currency = Currency(
      code: row.requiredString('currency_code'),
      scale: row.requiredInt('currency_scale'),
    );
    return AccountBalance(
      accountId: row.requiredString('account_id'),
      userId: row.requiredString('user_id'),
      currency: currency,
      balance: Money(
        minorUnits: row.requiredInt('balance_minor'),
        currency: currency,
      ),
    );
  }
}
