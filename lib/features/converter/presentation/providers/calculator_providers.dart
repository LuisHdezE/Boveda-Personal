import 'package:boveda_personal/core/database/database_provider.dart';
import 'package:boveda_personal/features/converter/data/repositories/sqlite_calculator_currency_repository.dart';
import 'package:boveda_personal/features/converter/domain/repositories/calculator_currency_repository.dart';
import 'package:boveda_personal/features/converter/domain/use_cases/manage_calculator_currencies.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calculatorCurrencyRepositoryProvider = Provider<CalculatorCurrencyRepository>((ref) {
  final db = ref.watch(bovedaDatabaseProvider);
  return SqliteCalculatorCurrencyRepository(db);
});

final listCalculatorCurrenciesUseCaseProvider = Provider<ListCalculatorCurrencies>((ref) {
  final repo = ref.watch(calculatorCurrencyRepositoryProvider);
  return ListCalculatorCurrencies(repo);
});

final saveCalculatorCurrencyUseCaseProvider = Provider<SaveCalculatorCurrency>((ref) {
  final repo = ref.watch(calculatorCurrencyRepositoryProvider);
  return SaveCalculatorCurrency(repo);
});

final setCalculatorCurrencyActiveUseCaseProvider = Provider<SetCalculatorCurrencyActive>((ref) {
  final repo = ref.watch(calculatorCurrencyRepositoryProvider);
  return SetCalculatorCurrencyActive(repo);
});
