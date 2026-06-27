import 'package:boveda_personal/core/database/app_database.dart';
import 'package:boveda_personal/core/database/dao/category_dao.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/categories/data/repositories/category_repository_impl.dart';
import 'package:boveda_personal/features/categories/domain/entities/category.dart';
import 'package:boveda_personal/features/categories/domain/repositories/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryDaoProvider = Provider<CategoryDao>((ref) {
  final db = ref.watch(bovedaDatabaseProvider);
  return CategoryDao(db);
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dao = ref.watch(categoryDaoProvider);
  return CategoryRepositoryImpl(dao);
});

final categoriesProvider = FutureProvider.family<List<Category>, CategoryMovementType?>((ref, movementType) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.list(movementType: movementType, activeOnly: true);
});
