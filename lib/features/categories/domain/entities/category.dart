enum CategoryMovementType {
  income,
  expense,
  both;

  static CategoryMovementType fromStorage(String value) {
    return values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw FormatException('Unknown category type: $value'),
    );
  }
}

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    required this.movementType,
    required this.isSystem,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String icon;
  final int colorValue;
  final CategoryMovementType movementType;
  final bool isSystem;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool supports(String movementTypeName) {
    return movementType == CategoryMovementType.both ||
        movementType.name == movementTypeName;
  }

  Category copyWith({
    String? name,
    String? icon,
    int? colorValue,
    CategoryMovementType? movementType,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
      movementType: movementType ?? this.movementType,
      isSystem: isSystem,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.colorValue == colorValue &&
        other.movementType == movementType &&
        other.isSystem == isSystem &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        icon,
        colorValue,
        movementType,
        isSystem,
        isActive,
        createdAt,
        updatedAt,
      );
}
