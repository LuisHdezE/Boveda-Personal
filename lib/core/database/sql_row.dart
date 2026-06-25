import 'package:boveda_personal/core/database/row_converters.dart';

extension SqlRow on Map<String, Object?> {
  String requiredString(String key) {
    final value = this[key];
    if (value is! String) {
      throw FormatException('Expected text column: $key');
    }
    return value;
  }

  String? optionalString(String key) {
    final value = this[key];
    if (value == null) {
      return null;
    }
    if (value is! String) {
      throw FormatException('Expected nullable text column: $key');
    }
    return value;
  }

  int requiredInt(String key) {
    final value = this[key];
    if (value is! int) {
      throw FormatException('Expected integer column: $key');
    }
    return value;
  }

  int? optionalInt(String key) {
    final value = this[key];
    if (value == null) {
      return null;
    }
    if (value is! int) {
      throw FormatException('Expected nullable integer column: $key');
    }
    return value;
  }

  bool requiredBool(String key) {
    return RowConverters.boolFromSql(this[key]);
  }

  DateTime requiredDate(String key) {
    return RowConverters.dateFromSql(this[key]);
  }
}
