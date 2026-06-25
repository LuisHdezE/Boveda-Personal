import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';

abstract interface class MoneyConverter {
  Future<Money> convert(
    Money amount, {
    required Currency target,
    required DateTime at,
  });
}
