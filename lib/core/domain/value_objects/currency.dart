class Currency {
  factory Currency({required String code, required int scale}) {
    final normalizedCode = code.trim().toUpperCase();
    if (!RegExp(r'^[A-Z0-9]{3,8}$').hasMatch(normalizedCode)) {
      throw ArgumentError.value(code, 'code', 'Invalid currency code');
    }
    if (scale < 0 || scale > 6) {
      throw ArgumentError.value(scale, 'scale', 'Must be between 0 and 6');
    }
    return Currency._(code: normalizedCode, scale: scale);
  }

  const Currency._({required this.code, required this.scale});

  final String code;
  final int scale;

  @override
  bool operator ==(Object other) {
    return other is Currency && other.code == code && other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(code, scale);

  @override
  String toString() => 'Currency(code: $code, scale: $scale)';
}
