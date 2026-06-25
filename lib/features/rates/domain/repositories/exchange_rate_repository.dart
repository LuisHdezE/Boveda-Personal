import 'package:boveda_personal/features/rates/domain/entities/exchange_rate.dart';

abstract interface class ExchangeRateRepository {
  Future<ExchangeRate?> latestAt({
    required String baseCurrencyCode,
    required String quoteCurrencyCode,
    required DateTime instant,
  });
  Future<List<ExchangeRate>> history({
    required String baseCurrencyCode,
    required String quoteCurrencyCode,
  });
  Future<void> save(ExchangeRate rate);
}
