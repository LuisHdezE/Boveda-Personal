import 'package:boveda_personal/features/converter/domain/entities/calculator_currency.dart';

abstract interface class CalculatorCurrencyRepository {
  Future<CalculatorCurrency?> findActiveByCode(String code);
  Future<List<CalculatorCurrency>> list({bool activeOnly = false});
  Future<void> save(CalculatorCurrency currency);
  Future<void> setActive(String id, {required bool active});
}
