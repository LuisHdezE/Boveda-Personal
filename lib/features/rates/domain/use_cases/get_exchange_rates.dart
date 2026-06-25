import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/features/rates/domain/entities/exchange_rate.dart';
import 'package:boveda_personal/features/rates/domain/repositories/exchange_rate_repository.dart';

class GetLatestExchangeRate {
  const GetLatestExchangeRate(this.repository);
  final ExchangeRateRepository repository;

  Future<ExchangeRate> call({
    required String baseCurrencyCode,
    required String quoteCurrencyCode,
    required DateTime at,
  }) async {
    final rate = await repository.latestAt(
      baseCurrencyCode: baseCurrencyCode,
      quoteCurrencyCode: quoteCurrencyCode,
      instant: at.toUtc(),
    );
    if (rate == null) {
      throw const NotFoundFailure('exchange_rate_not_found');
    }
    return rate;
  }
}

class ListExchangeRates {
  const ListExchangeRates(this.repository);
  final ExchangeRateRepository repository;

  Future<List<ExchangeRate>> call({
    required String baseCurrencyCode,
    required String quoteCurrencyCode,
  }) {
    return repository.history(
      baseCurrencyCode: baseCurrencyCode,
      quoteCurrencyCode: quoteCurrencyCode,
    );
  }
}
