import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:sqflite/sqflite.dart';

abstract final class DatabaseExceptionMapper {
  static AppFailure map(Object error) {
    if (error is DatabaseException) {
      final message = error.toString().toLowerCase();
      if (message.contains('unique constraint')) {
        return ConflictFailure('database_unique_constraint');
      }
      if (message.contains('not null constraint') ||
          message.contains('foreign key constraint') ||
          message.contains('check constraint') ||
          message.contains('constraint failed')) {
        return StorageFailure('database_integrity_constraint', cause: error);
      }
      if (message.contains('database_closed') ||
          message.contains('database is closed')) {
        return StorageFailure('database_closed', cause: error);
      }
      return StorageFailure('database_operation_failed', cause: error);
    }
    return UnexpectedFailure(cause: error);
  }
}
