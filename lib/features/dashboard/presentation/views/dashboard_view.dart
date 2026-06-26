import 'package:boveda_personal/app/router/app_router.dart';
import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainScaffold(
      title: 'Bóveda Personal',
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: const [
          _BalanceCard(),
          SizedBox(height: 24),
          _SummaryRow(),
          SizedBox(height: 24),
          _ChartSection(),
          SizedBox(height: 24),
          _RecentMovementsSection(),
          SizedBox(height: 24),
          _ToolsSection(),
          SizedBox(height: 80), // Padding for bottom nav bar
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.wealth.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SALDO TOTAL',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 2,
                          ),
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.wealth.withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: AppColors.wealth,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '\$',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.wealth.withValues(alpha: 0.7),
                          ),
                    ),
                    Text(
                      '142,500',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppColors.wealth,
                          ),
                    ),
                    Text(
                      '.00',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.wealth.withValues(alpha: 0.7),
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _CurrencyBalance(currency: 'USD', amount: '\$12,450.00'),
                    Container(
                      height: 16,
                      width: 1,
                      color: Colors.white.withValues(alpha: 0.1),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    _CurrencyBalance(currency: 'ARS', amount: '\$1,250,000'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyBalance extends StatelessWidget {
  const _CurrencyBalance({
    required this.currency,
    required this.amount,
  });

  final String currency;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          currency,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
        const SizedBox(width: 8),
        Text(
          amount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.arrow_upward,
            iconColor: AppColors.income,
            title: 'Ingresos',
            amount: '+\$4,200',
            amountColor: AppColors.income,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            icon: Icons.arrow_downward,
            iconColor: AppColors.expense,
            title: 'Gastos',
            amount: '-\$1,850',
            amountColor: AppColors.expense,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            icon: Icons.savings,
            iconColor: AppColors.onSurface,
            title: 'Ahorro',
            amount: '\$2,350',
            amountColor: AppColors.onSurface,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.amount,
    required this.amountColor,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String amount;
  final Color amountColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: amountColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Evolución del Patrimonio',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '1M',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.wealth.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
            child: CustomPaint(
              painter: _MockChartPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MockChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.wealth
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.cubicTo(
      size.width * 0.2, size.height * 0.5,
      size.width * 0.3, size.height * 0.7,
      size.width * 0.5, size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.7, size.height * 0.1,
      size.width * 0.8, size.height * 0.3,
      size.width, size.height * 0.2,
    );

    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;
    final dotStroke = Paint()
      ..color = AppColors.wealth
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 4, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 4, dotStroke);

    canvas.drawCircle(Offset(size.width, size.height * 0.2), 4, dotPaint);
    canvas.drawCircle(Offset(size.width, size.height * 0.2), 4, dotStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RecentMovementsSection extends StatelessWidget {
  const _RecentMovementsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Movimientos Recientes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => context.push(AppRoutes.history),
              child: Text(
                'Ver todos',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.wealth,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _MovementTile(
          icon: Icons.restaurant,
          title: 'Cena La Mar',
          category: 'Restaurantes',
          amount: '-\$125.00',
          isExpense: true,
        ),
        const SizedBox(height: 8),
        const _MovementTile(
          icon: Icons.work,
          title: 'Honorarios Consultoría',
          category: 'Ingresos',
          amount: '+\$2,500.00',
          isExpense: false,
        ),
        const SizedBox(height: 8),
        const _MovementTile(
          icon: Icons.shopping_cart,
          title: 'Supermercado',
          category: 'Gastos Fijos',
          amount: '-\$340.50',
          isExpense: true,
        ),
      ],
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({
    required this.icon,
    required this.title,
    required this.category,
    required this.amount,
    required this.isExpense,
  });

  final IconData icon;
  final String title;
  final String category;
  final String amount;
  final bool isExpense;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      onTap: () {},
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Icon(
              icon,
              color: AppColors.onSurfaceVariant,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  category,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isExpense ? AppColors.expense : AppColors.income,
                ),
          ),
        ],
      ),
    );
  }
}

class _ToolsSection extends StatelessWidget {
  const _ToolsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Herramientas',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _ToolCard(
                icon: Icons.calculate_outlined,
                title: 'Calculadora',
                onTap: () => context.push('/calculator'),
              ),
              const SizedBox(width: 12),
              _ToolCard(
                icon: Icons.currency_exchange_outlined,
                title: 'Conversor',
                onTap: () => context.push('/converter'),
              ),
              const SizedBox(width: 12),
              _ToolCard(
                icon: Icons.analytics_outlined,
                title: 'Simulador',
                onTap: () => context.push('/simulator'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        onTap: onTap,
        child: Column(
          children: [
            Icon(icon, color: AppColors.wealth, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
