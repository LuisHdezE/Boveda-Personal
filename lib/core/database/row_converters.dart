import 'package:decimal/decimal.dart';

abstract final class RowConverters {
  static int dateToSql(DateTime value) {
    return value.toUtc().millisecondsSinceEpoch;
  }

  static DateTime dateFromSql(Object? value) {
    if (value is! int) {
      throw const FormatException('Expected SQLite integer date');
    }
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }

  static String decimalToSql(String value) {
    return Decimal.parse(value).toString();
  }

  static Decimal decimalFromSql(Object? value) {
    if (value is! String) {
      throw const FormatException('Expected SQLite text decimal');
    }
    return Decimal.parse(value);
  }

  static int boolToSql(bool value) => value ? 1 : 0;

  static bool boolFromSql(Object? value) {
    return switch (value) {
      0 => false,
      1 => true,
      _ => throw const FormatException('Expected SQLite boolean 0 or 1'),
    };
  }
}
