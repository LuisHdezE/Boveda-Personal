import 'package:boveda_personal/core/ports/id_generator.dart';
import 'package:boveda_personal/features/rates/domain/commands/exchange_rate_update.dart';
import 'package:boveda_personal/features/rates/domain/entities/exchange_rate.dart';
import 'package:boveda_personal/features/rates/domain/repositories/exchange_rate_repository.dart';

class UpdateExchangeRate {
  const UpdateExchangeRate({
    required this.repository,
    required this.ids,
    required this.now,
  });

  final ExchangeRateRepository repository;
  final IdGenerator ids;
  final DateTime Function() now;

  Future<ExchangeRate> call(ExchangeRateUpdate update) async {
    final rate = ExchangeRate(
      id: ids.next(),
      baseCurrencyCode: update.baseCurrencyCode,
      quoteCurrencyCode: update.quoteCurrencyCode,
      rate: update.rate,
      effectiveAt: update.effectiveAt.toUtc(),
      createdAt: now().toUtc(),
    );
    await repository.save(rate);
    return rate;
  }
}
