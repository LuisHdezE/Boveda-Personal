import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/entities/transfer.dart';

abstract interface class TransferRepository {
  Future<Transfer?> findById(String id);
  Future<void> create({
    required Transfer transfer,
    required Movement outgoing,
    required Movement incoming,
  });
  Future<void> replace({
    required Transfer transfer,
    required Movement outgoing,
    required Movement incoming,
  });
  Future<void> delete(String id);
}
