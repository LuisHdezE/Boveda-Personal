import 'package:boveda_personal/features/accounts/domain/entities/account.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account_balance.dart';

abstract interface class AccountRepository {
  Future<Account?> findById(String id);
  Future<List<Account>> list({bool activeOnly = false});
  Future<List<AccountBalance>> balances();
  Future<void> save(Account account);
  Future<void> setActive(String id, {required bool active});
  Future<void> updateCurrency(String id, {required String currencyCode, required int currencyScale});
}
