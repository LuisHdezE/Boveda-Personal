class ProfileUpdate {
  ProfileUpdate({required String displayName, required String username})
    : displayName = displayName.trim(),
      username = username.trim() {
    if (this.displayName.isEmpty || this.username.isEmpty) {
      throw ArgumentError('Display name and username are required');
    }
  }

  final String displayName;
  final String username;

  @override
  bool operator ==(Object other) {
    return other is ProfileUpdate &&
        other.displayName == displayName &&
        other.username == username;
  }

  @override
  int get hashCode => Object.hash(displayName, username);
}
