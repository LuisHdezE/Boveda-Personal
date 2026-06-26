import 'package:boveda_personal/core/errors/app_failure.dart';
import 'package:boveda_personal/features/categories/domain/entities/category.dart';
import 'package:boveda_personal/features/categories/domain/repositories/category_repository.dart';

class ListCategories {
  const ListCategories(this.repository);
  final CategoryRepository repository;

  Future<List<Category>> call({
    CategoryMovementType? movementType,
    bool activeOnly = true,
  }) {
    return repository.list(movementType: movementType, activeOnly: activeOnly);
  }
}

class SaveCategory {
  const SaveCategory(this.repository);
  final CategoryRepository repository;

  Future<Category> call(Category category) async {
    if (category.name.trim().isEmpty) {
      throw const ValidationFailure('category_name_required');
    }
    await repository.save(category);
    return category;
  }
}

class SetCategoryActive {
  const SetCategoryActive(this.repository);
  final CategoryRepository repository;

  Future<void> call(String id, {required bool active}) {
    return repository.setActive(id, active: active);
  }
}
