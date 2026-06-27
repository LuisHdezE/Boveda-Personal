import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';

class SubscriptionsView extends StatelessWidget {
  const SubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Suscripciones',
      showBackButton: true,
      showBottomNav: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add subscription
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
