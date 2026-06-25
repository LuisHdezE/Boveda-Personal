import 'package:boveda_personal/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<User?> findByUsername(String username);
  Future<void> save(User user);
}
