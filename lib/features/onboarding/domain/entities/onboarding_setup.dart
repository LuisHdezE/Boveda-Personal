import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:decimal/decimal.dart';

class OnboardingSetup {
  OnboardingSetup({
    required String displayName,
    required String username,
    required this.password,
    required this.primaryCurrency,
    required this.secondaryCurrency,
    required this.initialExchangeRate,
    required this.primaryOpeningBalance,
    required this.secondaryOpeningBalance,
    required String locale,
  }) : displayName = displayName.trim(),
       username = username.trim(),
       locale = locale.trim() {
    if (primaryCurrency.code == secondaryCurrency.code) {
      throw ArgumentError('Primary and secondary currencies must differ');
    }
    if (primaryOpeningBalance.currency != primaryCurrency ||
        secondaryOpeningBalance.currency != secondaryCurrency) {
      throw ArgumentError('Opening balance currencies do not match accounts');
    }
    if (initialExchangeRate <= Decimal.zero) {
      throw ArgumentError.value(initialExchangeRate, 'initialExchangeRate');
    }
  }

  final String displayName;
  final String username;
  final String password;
  final Currency primaryCurrency;
  final Currency secondaryCurrency;
  final Decimal initialExchangeRate;
  final Money primaryOpeningBalance;
  final Money secondaryOpeningBalance;
  final String locale;

  bool get isComplete =>
      displayName.isNotEmpty &&
      username.isNotEmpty &&
      password.isNotEmpty &&
      locale.isNotEmpty;

  @override
  String toString() {
    return 'OnboardingSetup('
        'displayName: $displayName, '
        'username: $username, '
        'primaryCurrency: ${primaryCurrency.code}, '
        'secondaryCurrency: ${secondaryCurrency.code}, '
        'locale: $locale'
        ')';
  }
}
