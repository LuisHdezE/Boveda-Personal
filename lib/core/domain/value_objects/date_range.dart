enum PeriodUnit { day, week, month, quarter, year, custom }

class DateRange {
  DateRange({
    required this.start,
    required this.endExclusive,
    this.unit = PeriodUnit.custom,
  }) {
    if (!endExclusive.isAfter(start)) {
      throw ArgumentError('endExclusive must be after start');
    }
  }

  factory DateRange.forPeriod(DateTime anchor, PeriodUnit unit) {
    if (unit == PeriodUnit.custom) {
      throw ArgumentError('Custom periods require explicit boundaries');
    }
    final normalized = _date(anchor);
    final (start, end) = switch (unit) {
      PeriodUnit.day => (normalized, _addDays(normalized, 1)),
      PeriodUnit.week => (
        _addDays(normalized, -(normalized.weekday - DateTime.monday)),
        _addDays(
          _addDays(normalized, -(normalized.weekday - DateTime.monday)),
          7,
        ),
      ),
      PeriodUnit.month => (
        _at(normalized, normalized.year, normalized.month),
        _at(normalized, normalized.year, normalized.month + 1),
      ),
      PeriodUnit.quarter => (
        _at(normalized, normalized.year, ((normalized.month - 1) ~/ 3) * 3 + 1),
        _at(normalized, normalized.year, ((normalized.month - 1) ~/ 3) * 3 + 4),
      ),
      PeriodUnit.year => (
        _at(normalized, normalized.year),
        _at(normalized, normalized.year + 1),
      ),
      PeriodUnit.custom => throw StateError('Unreachable'),
    };
    return DateRange(start: start, endExclusive: end, unit: unit);
  }

  final DateTime start;
  final DateTime endExclusive;
  final PeriodUnit unit;

  Duration get duration => endExclusive.difference(start);

  bool contains(DateTime instant) {
    return !instant.isBefore(start) && instant.isBefore(endExclusive);
  }

  DateRange previous() => _shift(-1);
  DateRange next() => _shift(1);

  DateRange _shift(int amount) {
    if (unit == PeriodUnit.custom) {
      final delta = Duration(microseconds: duration.inMicroseconds * amount);
      return DateRange(
        start: start.add(delta),
        endExclusive: endExclusive.add(delta),
      );
    }
    final anchor = switch (unit) {
      PeriodUnit.day => _addDays(start, amount),
      PeriodUnit.week => _addDays(start, amount * 7),
      PeriodUnit.month => _at(start, start.year, start.month + amount),
      PeriodUnit.quarter => _at(start, start.year, start.month + amount * 3),
      PeriodUnit.year => _at(start, start.year + amount),
      PeriodUnit.custom => throw StateError('Unreachable'),
    };
    return DateRange.forPeriod(anchor, unit);
  }

  @override
  bool operator ==(Object other) {
    return other is DateRange &&
        other.start == start &&
        other.endExclusive == endExclusive &&
        other.unit == unit;
  }

  @override
  int get hashCode => Object.hash(start, endExclusive, unit);
}

DateTime _date(DateTime value) {
  return _at(value, value.year, value.month, value.day);
}

DateTime _addDays(DateTime value, int days) {
  return _at(value, value.year, value.month, value.day + days);
}

DateTime _at(DateTime template, int year, [int month = 1, int day = 1]) {
  return template.isUtc
      ? DateTime.utc(year, month, day)
      : DateTime(year, month, day);
}
