sealed class AppFailure implements Exception {
  const AppFailure(this.code, {this.cause});

  final String code;
  final Object? cause;
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.code);
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure(super.code);
}

final class ConflictFailure extends AppFailure {
  const ConflictFailure(super.code);
}

final class StorageFailure extends AppFailure {
  const StorageFailure(super.code, {super.cause});
}

final class AuthenticationFailure extends AppFailure {
  const AuthenticationFailure(super.code);
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({super.cause}) : super('unexpected');
}
