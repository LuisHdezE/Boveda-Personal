import 'package:boveda_personal/core/database/row_converters.dart';
import 'package:boveda_personal/core/database/sql_row.dart';
import 'package:boveda_personal/features/categories/domain/entities/category.dart';

class CategoryModel {
  const CategoryModel(this.entity);

  final Category entity;

  factory CategoryModel.fromEntity(Category entity) => CategoryModel(entity);

  factory CategoryModel.fromRow(Map<String, Object?> row) {
    return CategoryModel(
      Category(
        id: row.requiredString('id'),
        name: row.requiredString('name'),
        icon: row.requiredString('icon'),
        colorValue: row.requiredInt('color'),
        movementType: CategoryMovementType.fromStorage(
          row.requiredString('movement_type'),
        ),
        isSystem: row.requiredBool('is_system'),
        isActive: row.requiredBool('is_active'),
        createdAt: row.requiredDate('created_at'),
        updatedAt: row.requiredDate('updated_at'),
      ),
    );
  }

  Category toEntity() => entity;

  Map<String, Object?> toRow() => {
        'id': entity.id,
        'name': entity.name,
        'icon': entity.icon,
        'color': entity.colorValue,
        'movement_type': entity.movementType.name,
        'is_system': RowConverters.boolToSql(entity.isSystem),
        'is_active': RowConverters.boolToSql(entity.isActive),
        'created_at': RowConverters.dateToSql(entity.createdAt),
        'updated_at': RowConverters.dateToSql(entity.updatedAt),
      };
}
