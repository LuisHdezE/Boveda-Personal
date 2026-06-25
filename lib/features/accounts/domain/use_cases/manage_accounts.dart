import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account.dart';
import 'package:boveda_personal/features/accounts/domain/entities/account_balance.dart';
import 'package:boveda_personal/features/accounts/domain/repositories/account_repository.dart';

class ListAccounts {
  const ListAccounts(this.repository);
  final AccountRepository repository;

  Future<List<Account>> call({bool activeOnly = false}) {
    return repository.list(activeOnly: activeOnly);
  }
}

class GetAccount {
  const GetAccount(this.repository);
  final AccountRepository repository;

  Future<Account> call(String id) async {
    final account = await repository.findById(id);
    if (account == null) {
      throw const NotFoundFailure('account_not_found');
    }
    return account;
  }
}

class GetAccountBalances {
  const GetAccountBalances(this.repository);
  final AccountRepository repository;

  Future<List<AccountBalance>> call() => repository.balances();
}

class SetAccountActive {
  const SetAccountActive(this.repository);
  final AccountRepository repository;

  Future<void> call(String id, {required bool active}) {
    return repository.setActive(id, active: active);
  }
}
