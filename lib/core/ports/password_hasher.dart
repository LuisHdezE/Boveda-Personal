class PasswordDigest {
  const PasswordDigest({
    required this.hash,
    required this.salt,
  });

  final String hash;
  final String salt;
}

abstract interface class PasswordHasher {
  Future<PasswordDigest> hash(String password);

  Future<bool> verify({
    required String password,
    required String hash,
    required String salt,
  });
}
