class LoginCredentials {
  LoginCredentials({required String username, required this.password})
    : username = username.trim() {
    if (this.username.isEmpty || password.isEmpty) {
      throw ArgumentError('Username and password are required');
    }
  }

  final String username;
  final String password;

  @override
  String toString() => 'LoginCredentials(username: $username)';
}

class PasswordChange {
  PasswordChange({required this.currentPassword, required this.newPassword}) {
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      throw ArgumentError('Current and new passwords are required');
    }
    if (currentPassword == newPassword) {
      throw ArgumentError('New password must differ from current password');
    }
  }

  final String currentPassword;
  final String newPassword;

  @override
  String toString() => 'PasswordChange(redacted)';
}
