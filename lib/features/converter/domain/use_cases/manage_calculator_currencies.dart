import 'package:boveda_personal/features/converter/domain/entities/calculator_currency.dart';
import 'package:boveda_personal/features/converter/domain/repositories/calculator_currency_repository.dart';

class ListCalculatorCurrencies {
  const ListCalculatorCurrencies(this.repository);
  final CalculatorCurrencyRepository repository;

  Future<List<CalculatorCurrency>> call({bool activeOnly = false}) {
    return repository.list(activeOnly: activeOnly);
  }
}

class SaveCalculatorCurrency {
  const SaveCalculatorCurrency(this.repository);
  final CalculatorCurrencyRepository repository;

  Future<CalculatorCurrency> call(CalculatorCurrency currency) async {
    await repository.save(currency);
    return currency;
  }
}

class SetCalculatorCurrencyActive {
  const SetCalculatorCurrencyActive(this.repository);
  final CalculatorCurrencyRepository repository;

  Future<void> call(String id, {required bool active}) {
    return repository.setActive(id, active: active);
  }
}
