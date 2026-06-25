import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/core/domain/value_objects/page.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/movements/domain/queries/movement_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FIL-015 combina todos los filtros y detecta estado activo', () {
    final filter = MovementFilter(
      period: DateRange(
        start: DateTime.utc(2026, 6, 1),
        endExclusive: DateTime.utc(2026, 7, 1),
      ),
      accountId: 'usd',
      categoryId: 'food',
      types: const {MovementType.expense},
    );

    expect(filter.isEmpty, isFalse);
    expect(filter.types, {MovementType.expense});
  });

  test('FIL-017 clear restaura el filtro vacío', () {
    final filter = MovementFilter(
      accountId: 'usd',
      types: const {MovementType.income},
    );

    expect(filter.clear(), MovementFilter());
  });

  test('MODEL-006 PageRequest valida límites', () {
    expect(() => PageRequest(limit: 0), throwsArgumentError);
    expect(() => PageRequest(offset: -1), throwsArgumentError);
  });

  test('MODEL-007 Page expone si existe otra página', () {
    final page = Page<String>(
      items: const ['a', 'b'],
      request: PageRequest(limit: 2),
      total: 3,
    );

    expect(page.hasNext, isTrue);
    expect(page.nextRequest, PageRequest(limit: 2, offset: 2));
  });
}
