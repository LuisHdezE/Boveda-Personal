import 'package:boveda_personal/features/subscriptions/domain/entities/subscription.dart';

abstract class SubscriptionRepository {
  Future<void> save(Subscription subscription, String userId);
  Future<void> delete(String id, String userId);
  Future<List<Subscription>> getAll(String userId);
}
