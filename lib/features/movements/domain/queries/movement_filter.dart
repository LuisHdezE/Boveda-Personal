import 'package:boveda_personal/core/domain/value_objects/date_range.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:collection/collection.dart';

class MovementFilter {
  factory MovementFilter({
    DateRange? period,
    String? accountId,
    String? categoryId,
    Set<MovementType> types = const {},
  }) {
    return MovementFilter._(
      period: period,
      accountId: accountId,
      categoryId: categoryId,
      types: Set.unmodifiable(types),
    );
  }

  const MovementFilter._({
    required this.period,
    required this.accountId,
    required this.categoryId,
    required this.types,
  });

  final DateRange? period;
  final String? accountId;
  final String? categoryId;
  final Set<MovementType> types;

  bool get isEmpty =>
      period == null &&
      accountId == null &&
      categoryId == null &&
      types.isEmpty;

  MovementFilter copyWith({
    DateRange? period,
    bool clearPeriod = false,
    String? accountId,
    bool clearAccountId = false,
    String? categoryId,
    bool clearCategoryId = false,
    Set<MovementType>? types,
  }) {
    return MovementFilter(
      period: clearPeriod ? null : period ?? this.period,
      accountId: clearAccountId ? null : accountId ?? this.accountId,
      categoryId: clearCategoryId ? null : categoryId ?? this.categoryId,
      types: types ?? this.types,
    );
  }

  MovementFilter clear() => MovementFilter();

  @override
  bool operator ==(Object other) {
    return other is MovementFilter &&
        other.period == period &&
        other.accountId == accountId &&
        other.categoryId == categoryId &&
        const SetEquality<MovementType>().equals(other.types, types);
  }

  @override
  int get hashCode => Object.hash(
    period,
    accountId,
    categoryId,
    const SetEquality<MovementType>().hash(types),
  );
}
