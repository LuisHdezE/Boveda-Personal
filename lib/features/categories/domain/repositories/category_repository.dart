import 'package:boveda_personal/features/categories/domain/entities/category.dart';

abstract interface class CategoryRepository {
  Future<Category?> findById(String id);
  Future<List<Category>> list({
    CategoryMovementType? movementType,
    bool activeOnly = true,
  });
  Future<void> save(Category category);
  Future<void> setActive(String id, {required bool active});
}
