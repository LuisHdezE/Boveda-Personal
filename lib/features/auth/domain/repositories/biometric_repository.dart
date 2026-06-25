import 'package:boveda_personal/features/auth/domain/entities/biometric_status.dart';

abstract interface class BiometricRepository {
  Future<BiometricStatus> status();
  Future<bool> authenticate();
  Future<void> storeUserId(String userId);
  Future<String?> readUserId();
  Future<void> clearUserId();
}
