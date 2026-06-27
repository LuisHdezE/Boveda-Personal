import 'package:boveda_personal/core/security/cryptography_password_hasher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CryptographyPasswordHasher hasher;

  setUp(() {
    hasher = const CryptographyPasswordHasher();
  });

  test('SEC-001 hash produce digest con hash y salt no vacíos', () async {
    final digest = await hasher.hash('miContraseña');

    expect(digest.hash, isNotEmpty);
    expect(digest.salt, isNotEmpty);
  });

  test('SEC-002 dos llamadas con la misma contraseña producen salts distintos',
      () async {
    final a = await hasher.hash('mismaContraseña');
    final b = await hasher.hash('mismaContraseña');

    expect(a.salt, isNot(equals(b.salt)));
    expect(a.hash, isNot(equals(b.hash)));
  });

  test('SEC-003 verify retorna true con la contraseña correcta', () async {
    final digest = await hasher.hash('correcta');

    final result = await hasher.verify(
      password: 'correcta',
      hash: digest.hash,
      salt: digest.salt,
    );

    expect(result, isTrue);
  });

  test('SEC-004 verify retorna false con contraseña incorrecta', () async {
    final digest = await hasher.hash('correcta');

    final result = await hasher.verify(
      password: 'incorrecta',
      hash: digest.hash,
      salt: digest.salt,
    );

    expect(result, isFalse);
  });

  test('SEC-005 verify retorna false con salt manipulado', () async {
    final digest = await hasher.hash('contraseña');

    final result = await hasher.verify(
      password: 'contraseña',
      hash: digest.hash,
      salt: 'salt-manipulado',
    );

    expect(result, isFalse);
  });
}
