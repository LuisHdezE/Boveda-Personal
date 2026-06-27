import 'package:boveda_personal/core/database/dao/subscription_dao.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/subscriptions/data/models/subscription_model.dart';
import 'package:boveda_personal/features/subscriptions/domain/entities/subscription.dart';
import 'package:boveda_personal/features/subscriptions/domain/repositories/subscription_repository.dart';

class SqliteSubscriptionRepository implements SubscriptionRepository {
  const SqliteSubscriptionRepository(this._dao);

  final SubscriptionDao _dao;

  @override
  Future<void> save(Subscription subscription, String userId) async {
    final model = SubscriptionModel(
      id: subscription.id,
      userId: userId,
      name: subscription.name,
      amountMinor: subscription.amount.minorUnits,
      currencyCode: subscription.amount.currency.code,
      billingCycle: subscription.billingCycle,
      nextBillingDate: subscription.nextBillingDate,
      isActive: subscription.isActive,
      createdAt: subscription.createdAt,
      updatedAt: subscription.updatedAt,
    );

    await _dao.insert(model);
  }

  @override
  Future<void> delete(String id, String userId) async {
    await _dao.delete(id, userId);
  }

  @override
  Future<List<Subscription>> getAll(String userId) async {
    final models = await _dao.getAll(userId);
    return models.map((m) {
      return Subscription(
        id: m.id,
        name: m.name,
        amount: Money(minorUnits: m.amountMinor, currency: Currency(code: m.currencyCode, scale: 2)), // Assuming scale 2
        billingCycle: m.billingCycle,
        nextBillingDate: m.nextBillingDate,
        isActive: m.isActive,
        createdAt: m.createdAt,
        updatedAt: m.updatedAt,
      );
    }).toList();
  }
}
