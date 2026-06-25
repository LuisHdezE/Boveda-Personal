import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DATE-007 incluye inicio y excluye fin', () {
    final range = DateRange(
      start: DateTime.utc(2026, 6, 1),
      endExclusive: DateTime.utc(2026, 7, 1),
    );

    expect(range.contains(DateTime.utc(2026, 6, 1)), isTrue);
    expect(range.contains(DateTime.utc(2026, 6, 30, 23, 59)), isTrue);
    expect(range.contains(DateTime.utc(2026, 7, 1)), isFalse);
  });

  test('DATE-005 calcula trimestre', () {
    final range = DateRange.forPeriod(
      DateTime.utc(2026, 5, 20),
      PeriodUnit.quarter,
    );

    expect(range.start, DateTime.utc(2026, 4, 1));
    expect(range.endExclusive, DateTime.utc(2026, 7, 1));
  });

  test('DATE-004 contempla febrero bisiesto', () {
    final range = DateRange.forPeriod(
      DateTime.utc(2024, 2, 20),
      PeriodUnit.month,
    );

    expect(range.endExclusive, DateTime.utc(2024, 3, 1));
    expect(range.duration.inDays, 29);
  });

  test('DATE-008 desplaza períodos sin solaparlos', () {
    final current = DateRange.forPeriod(
      DateTime.utc(2026, 12, 5),
      PeriodUnit.month,
    );

    expect(current.previous().start, DateTime.utc(2026, 11, 1));
    expect(current.next().start, DateTime.utc(2027, 1, 1));
  });

  test('MODEL-005 rechaza rango vacío o invertido', () {
    final instant = DateTime.utc(2026);
    expect(
      () => DateRange(start: instant, endExclusive: instant),
      throwsArgumentError,
    );
  });
}
