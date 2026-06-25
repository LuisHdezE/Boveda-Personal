import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('MAP-005 serializa fechas como milisegundos UTC', () {
    final local = DateTime.parse('2026-06-25T12:30:00-03:00');

    final stored = RowConverters.dateToSql(local);
    final restored = RowConverters.dateFromSql(stored);

    expect(restored, local.toUtc());
    expect(restored.isUtc, isTrue);
  });

  test('MAP-006 conserva un decimal monetario como texto', () {
    const value = '1234567890.123456';

    final stored = RowConverters.decimalToSql(value);

    expect(stored, value);
  });

  test('MAP-007 convierte booleanos a enteros SQLite', () {
    expect(RowConverters.boolToSql(true), 1);
    expect(RowConverters.boolToSql(false), 0);
    expect(RowConverters.boolFromSql(1), isTrue);
    expect(RowConverters.boolFromSql(0), isFalse);
  });

  test('MAP-007 rechaza booleanos SQLite inválidos', () {
    expect(() => RowConverters.boolFromSql(2), throwsFormatException);
  });
}
