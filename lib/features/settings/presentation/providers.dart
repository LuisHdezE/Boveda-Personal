import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/rates/domain/commands/exchange_rate_update.dart';
import 'package:boveda_personal/features/rates/domain/use_cases/update_exchange_rate.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateRateState {
  const UpdateRateState({this.isLoading = false, this.error, this.success = false});

  final bool isLoading;
  final String? error;
  final bool success;

  UpdateRateState copyWith({bool? isLoading, String? error, bool clearError = false, bool? success}) {
    return UpdateRateState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      success: success ?? this.success,
    );
  }
}

class UpdateRateNotifier extends Notifier<UpdateRateState> {
  @override
  UpdateRateState build() => const UpdateRateState();

  Future<void> save({
    required String baseCurrency,
    required String quoteCurrency,
    required String rateText,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final rate = Decimal.tryParse(rateText);
      if (rate == null || rate <= Decimal.zero) {
        state = state.copyWith(isLoading: false, error: 'Ingresa una tasa válida mayor que 0');
        return;
      }

      final useCase = UpdateExchangeRate(
        repository: ref.read(exchangeRateRepositoryProvider),
        ids: ref.read(idGeneratorProvider),
        now: DateTime.now,
      );

      await useCase(
        ExchangeRateUpdate(
          baseCurrencyCode: baseCurrency,
          quoteCurrencyCode: quoteCurrency,
          rate: rate,
          effectiveAt: DateTime.now(),
        ),
      );

      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'No se pudo guardar la tasa: $e');
    }
  }

  void resetSuccess() {
    state = state.copyWith(success: false);
  }
}

final updateRateNotifierProvider =
    NotifierProvider<UpdateRateNotifier, UpdateRateState>(UpdateRateNotifier.new);
