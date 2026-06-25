import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/core/ports/money_converter.dart';
import 'package:boveda_personal/features/converter/domain/entities/conversion.dart';
import 'package:boveda_personal/features/converter/domain/use_cases/convert_currency.dart';

class CalculatorMoneyConverter implements MoneyConverter {
  const CalculatorMoneyConverter(this.convertCurrency);

  final ConvertCurrency convertCurrency;

  @override
  Future<Money> convert(
    Money amount, {
    required Currency target,
    required DateTime at,
  }) async {
    if (amount.currency == target) {
      return amount;
    }
    final quote = await convertCurrency(
      ConversionRequest(amount: amount, targetCurrency: target),
    );
    return quote.convertedAmount;
  }
}
