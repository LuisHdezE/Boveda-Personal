import 'dart:convert';
import 'dart:typed_data';

import 'package:boveda_personal/core/ports/password_hasher.dart';
import 'package:cryptography/cryptography.dart';

/// Implementación de [PasswordHasher] usando PBKDF2 con HMAC-SHA256.
///
/// - Salt: 16 bytes aleatorios codificados en base64.
/// - Hash: 32 bytes derivados codificados en base64.
/// - Iteraciones: 100 000 (ajustado para dispositivos móviles modernos).
class CryptographyPasswordHasher implements PasswordHasher {
  const CryptographyPasswordHasher();

  static const _iterations = 100000;
  static const _keyLength = 32; // 256 bits

  @override
  Future<PasswordDigest> hash(String password) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _iterations,
      bits: _keyLength * 8,
    );

    final saltBytes = SecretKeyData.random(length: 16).bytes;
    final saltB64 = base64.encode(saltBytes);

    final secretKey = await pbkdf2.deriveKeyFromPassword(
      password: password,
      nonce: saltBytes,
    );
    final hashBytes = await secretKey.extractBytes();
    final hashB64 = base64.encode(hashBytes);

    return PasswordDigest(hash: hashB64, salt: saltB64);
  }

  @override
  Future<bool> verify({
    required String password,
    required String hash,
    required String salt,
  }) async {
    try {
      final saltBytes = base64.decode(salt);
      final pbkdf2 = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: _iterations,
        bits: _keyLength * 8,
      );
      final secretKey = await pbkdf2.deriveKeyFromPassword(
        password: password,
        nonce: saltBytes,
      );
      final computedBytes = await secretKey.extractBytes();
      final expectedBytes = base64.decode(hash);
      return _constantTimeEquals(computedBytes, expectedBytes);
    } catch (_) {
      return false;
    }
  }

  /// Comparación en tiempo constante para evitar timing attacks.
  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }
}
