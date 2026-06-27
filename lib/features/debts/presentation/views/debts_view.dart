import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';

class DebtsView extends StatelessWidget {
  const DebtsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Deudas',
      showBackButton: true,
      showBottomNav: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add debt
        },
        backgroundColor: AppColors.wealth,
        child: const Icon(Icons.add, color: AppColors.surfaceHighest),
      ),
      child: Center(
        child: Text(
          'En construcción',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
