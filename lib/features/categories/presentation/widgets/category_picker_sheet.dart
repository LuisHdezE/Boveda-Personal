import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/features/categories/domain/entities/category.dart';
import 'package:boveda_personal/features/categories/presentation/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryPickerSheet extends ConsumerWidget {
  const CategoryPickerSheet({
    super.key,
    required this.movementType,
    this.selectedId,
    required this.onSelected,
  });

  final CategoryMovementType movementType;
  final String? selectedId;
  final ValueChanged<Category> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCategories = ref.watch(categoriesProvider(movementType));

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Seleccionar Categoría',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: asyncCategories.when(
              data: (categories) {
                if (categories.isEmpty) {
                  return const Center(
                    child: Text('No hay categorías disponibles.'),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category.id == selectedId;
                    return InkWell(
                      onTap: () => onSelected(category),
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: [
                          Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.wealth.withValues(alpha: 0.2)
                                  : AppColors.surfaceContainer,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.wealth.withValues(alpha: 0.5)
                                    : AppColors.outlineVariant,
                              ),
                            ),
                            child: Icon(
                              _getIcon(category.icon),
                              color: isSelected ? AppColors.wealth : AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String iconName) {
    // Basic mapping, can be expanded
    switch (iconName) {
      case 'restaurant': return Icons.restaurant;
      case 'directions_car': return Icons.directions_car;
      case 'favorite': return Icons.favorite;
      case 'movie': return Icons.movie;
      case 'home': return Icons.home;
      case 'shopping_bag': return Icons.shopping_bag;
      default: return Icons.category;
    }
  }
}
