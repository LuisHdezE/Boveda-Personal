import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/features/converter/domain/entities/calculator_currency.dart';
import 'package:boveda_personal/features/converter/presentation/providers/calculator_providers.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class CalculatorCurrenciesNotifier extends AsyncNotifier<List<CalculatorCurrency>> {
  @override
  Future<List<CalculatorCurrency>> build() async {
    return _fetchCurrencies();
  }

  Future<List<CalculatorCurrency>> _fetchCurrencies() async {
    final listUseCase = ref.read(listCalculatorCurrenciesUseCaseProvider);
    var currencies = await listUseCase();

    // Seed default currencies if empty
    if (currencies.isEmpty) {
      final saveUseCase = ref.read(saveCalculatorCurrencyUseCaseProvider);
      final now = DateTime.now();
      
      final defaults = [
        CalculatorCurrency(
          id: const Uuid().v4(),
          name: 'Dólar Estadounidense',
          currency: Currency(code: 'USD', scale: 2),
          symbol: '\$',
          unitsPerUsd: Decimal.parse('1.0'),
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
        CalculatorCurrency(
          id: const Uuid().v4(),
          name: 'Peso Argentino',
          currency: Currency(code: 'ARS', scale: 2),
          symbol: '\$',
          unitsPerUsd: Decimal.parse('1050.0'),
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
        CalculatorCurrency(
          id: const Uuid().v4(),
          name: 'Euro',
          currency: Currency(code: 'EUR', scale: 2),
          symbol: '€',
          unitsPerUsd: Decimal.parse('0.92'),
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
        CalculatorCurrency(
          id: const Uuid().v4(),
          name: 'Libra Esterlina',
          currency: Currency(code: 'GBP', scale: 2),
          symbol: '£',
          unitsPerUsd: Decimal.parse('0.79'),
          isActive: false,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      for (var curr in defaults) {
        await saveUseCase(curr);
      }
      
      currencies = await listUseCase();
    }

    return currencies;
  }

  Future<void> toggleActive(String id, bool active) async {
    final setActiveUseCase = ref.read(setCalculatorCurrencyActiveUseCaseProvider);
    await setActiveUseCase(id, active: active);
    // Reload state
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCurrencies());
  }

  Future<void> saveCurrency(CalculatorCurrency currency) async {
    final saveUseCase = ref.read(saveCalculatorCurrencyUseCaseProvider);
    await saveUseCase(currency);
    // Reload state
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCurrencies());
  }
}

final calculatorCurrenciesProvider = AsyncNotifierProvider<CalculatorCurrenciesNotifier, List<CalculatorCurrency>>(() {
  return CalculatorCurrenciesNotifier();
});
