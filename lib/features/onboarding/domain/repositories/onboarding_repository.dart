import 'package:boveda_personal/features/accounts/domain/entities/account.dart';
import 'package:boveda_personal/features/auth/domain/entities/user.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/rates/domain/entities/exchange_rate.dart';
import 'package:boveda_personal/features/settings/domain/entities/app_settings.dart';

class OnboardingData {
  OnboardingData({
    required this.user,
    required this.settings,
    required List<Account> accounts,
    required this.initialRate,
    required List<Movement> openingMovements,
  }) : accounts = List.unmodifiable(accounts),
       openingMovements = List.unmodifiable(openingMovements);

  final User user;
  final AppSettings settings;
  final List<Account> accounts;
  final ExchangeRate initialRate;
  final List<Movement> openingMovements;
}

abstract interface class OnboardingRepository {
  Future<bool> isConfigured();
  Future<void> initialize(OnboardingData data);
}
