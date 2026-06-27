import 'package:boveda_personal/core/database/dao/category_dao.dart';
import 'package:boveda_personal/features/categories/data/models/category_model.dart';
import 'package:boveda_personal/features/categories/domain/entities/category.dart';
import 'package:boveda_personal/features/categories/domain/repositories/category_repository.dart';
import 'package:collection/collection.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._dao);

  final CategoryDao _dao;

  @override
  Future<Category?> findById(String id) async {
    final list = await _dao.list(activeOnly: false);
    final row = list.firstWhereOrNull((row) => row['id'] == id);
    if (row == null) return null;
    return CategoryModel.fromRow(row).toEntity();
  }

  @override
  Future<List<Category>> list({
    CategoryMovementType? movementType,
    bool activeOnly = true,
  }) async {
    final rows = await _dao.list(
      movementType: movementType?.name,
      activeOnly: activeOnly,
    );
    return rows.map((row) => CategoryModel.fromRow(row).toEntity()).toList();
  }

  @override
  Future<void> save(Category category) async {
    await _dao.insert(CategoryModel.fromEntity(category).toRow());
  }

  @override
  Future<void> setActive(String id, {required bool active}) async {
    await _dao.setActive(id, active: active);
  }
}
