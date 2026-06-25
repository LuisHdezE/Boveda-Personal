class User {
  const User({
    required this.id,
    required this.displayName,
    required this.username,
    required this.passwordHash,
    required this.passwordSalt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String displayName;
  final String username;
  final String passwordHash;
  final String passwordSalt;
  final DateTime createdAt;
  final DateTime updatedAt;

  User copyWith({
    String? displayName,
    String? username,
    String? passwordHash,
    String? passwordSalt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is User &&
        other.id == id &&
        other.displayName == displayName &&
        other.username == username &&
        other.passwordHash == passwordHash &&
        other.passwordSalt == passwordSalt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        displayName,
        username,
        passwordHash,
        passwordSalt,
        createdAt,
        updatedAt,
      );

  @override
  String toString() {
    return 'User(id: $id, displayName: $displayName, username: $username)';
  }
}
