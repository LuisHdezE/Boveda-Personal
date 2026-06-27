import 'package:boveda_personal/app/router/app_router.dart';
import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/dashboard/presentation/providers.dart';
import 'package:boveda_personal/features/movements/domain/entities/movement.dart';
import 'package:boveda_personal/features/settings/presentation/providers/calculator_currencies_provider.dart';
import 'package:boveda_personal/shared/presentation/widgets/expandable_fab.dart';
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
      floatingActionButton: ExpandableFab(
        distance: 72.0,
        children: [
          FloatingActionButton.small(
            heroTag: 'calc_fab',
            backgroundColor: AppColors.surfaceHigh,
            onPressed: () => context.push('/calculator'),
            child: const Icon(Icons.calculate_outlined, color: AppColors.wealth),
          ),
          FloatingActionButton.small(
            heroTag: 'conv_fab',
            backgroundColor: AppColors.surfaceHigh,
            onPressed: () => context.push('/converter'),
            child: const Icon(Icons.currency_exchange_outlined, color: AppColors.wealth),
          ),
          FloatingActionButton.small(
            heroTag: 'sim_fab',
            backgroundColor: AppColors.surfaceHigh,
            onPressed: () => context.push('/simulator'),
            child: const Icon(Icons.analytics_outlined, color: AppColors.wealth),
          ),
          FloatingActionButton.small(
            heroTag: 'debts_fab',
            backgroundColor: AppColors.surfaceHigh,
            onPressed: () => context.push('/debts'),
            child: const Icon(Icons.money_off_outlined, color: AppColors.wealth),
          ),
          FloatingActionButton.small(
            heroTag: 'subs_fab',
            backgroundColor: AppColors.surfaceHigh,
            onPressed: () => context.push('/subscriptions'),
            child: const Icon(Icons.event_repeat_outlined, color: AppColors.wealth),
          ),
        ],
      ),
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
          SizedBox(height: 120), // Padding for bottom nav bar
        ],
      ),
    );
  }
}

class _BalanceCard extends ConsumerStatefulWidget {
  const _BalanceCard();

  @override
  ConsumerState<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends ConsumerState<_BalanceCard> {
  bool _showInSecondary = false;

  @override
  Widget build(BuildContext context) {
    final balancesAsync = ref.watch(accountBalancesProvider);
    final settingsAsync = ref.watch(appSettingsProvider);
    final currenciesAsync = ref.watch(calculatorCurrenciesProvider);

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
                      onTap: () {
                        setState(() {
                          _showInSecondary = !_showInSecondary;
                        });
                      },
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
                          Icons.swap_horiz,
                          color: AppColors.wealth,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Dynamic Balance Calculation
                Builder(builder: (context) {
                  if (balancesAsync.isLoading || settingsAsync.isLoading || currenciesAsync.isLoading) {
                    return const CircularProgressIndicator(strokeWidth: 2);
                  }

                  final balances = balancesAsync.asData?.value ?? [];
                  final settings = settingsAsync.asData?.value;
                  final currencies = currenciesAsync.asData?.value ?? [];

                  if (settings == null || currencies.isEmpty) {
                    return Text('...', style: Theme.of(context).textTheme.displayLarge);
                  }

                  double totalUsd = 0.0;

                  for (final b in balances) {
                    final currInfo = currencies.firstWhere(
                      (c) => c.currency.code == b.currency.code,
                      orElse: () => currencies.first,
                    );
                    final unitsPerUsd = currInfo.unitsPerUsd.toDouble();
                    final amount = b.balance.minorUnits / 100.0;
                    if (unitsPerUsd > 0) {
                      totalUsd += amount / unitsPerUsd;
                    }
                  }

                  String displayCode = 'USD';
                  double displayAmount = totalUsd;

                  if (_showInSecondary) {
                    displayCode = settings.primaryCurrencyCode;
                    final targetCurrInfo = currencies.firstWhere(
                      (c) => c.currency.code == displayCode,
                      orElse: () => currencies.first,
                    );
                    displayAmount = totalUsd * targetCurrInfo.unitsPerUsd.toDouble();
                  }

                  final amountParts = displayAmount.toStringAsFixed(2).split('.');
                  final integerPart = amountParts[0].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
                  final decimalPart = amountParts.length > 1 ? amountParts[1] : '00';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$displayCode ',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.wealth.withValues(alpha: 0.7),
                                ),
                          ),
                          Text(
                            '\$',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.wealth.withValues(alpha: 0.7),
                                ),
                          ),
                          Text(
                            integerPart,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppColors.wealth,
                                ),
                          ),
                          Text(
                            '.$decimalPart',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.wealth.withValues(alpha: 0.7),
                                ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 24),
                balancesAsync.when(
                  data: (balances) {
                    if (balances.isEmpty) {
                      return Text('No hay cuentas configuradas.', style: Theme.of(context).textTheme.bodyMedium);
                    }
                    return Row(
                      children: balances.map((b) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _CurrencyBalance(
                            currency: b.currency.code,
                            amount: '\$${(b.balance.minorUnits / 100).toStringAsFixed(2)}',
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const Text('Error cargando saldos'),
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

class _SummaryRow extends ConsumerWidget {
  const _SummaryRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    
    return summaryAsync.when(
      data: (summary) {
        final incomeAmount = summary.income / 100;
        final expenseAmount = summary.expense / 100;
        final savingsAmount = incomeAmount - expenseAmount;
        
        return Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.arrow_upward,
                iconColor: AppColors.income,
                title: 'Ingresos',
                amount: '+\$${incomeAmount.toStringAsFixed(2)}',
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
                amount: '-\$${expenseAmount.toStringAsFixed(2)}',
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
                amount: '\$${savingsAmount.toStringAsFixed(2)}',
                amountColor: AppColors.onSurface,
                onTap: () {},
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
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

class _RecentMovementsSection extends ConsumerWidget {
  const _RecentMovementsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentMovementsProvider);
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
        recentAsync.when(
          data: (movements) {
            if (movements.isEmpty) {
              return Center(
                child: Text('No hay movimientos recientes', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
              );
            }
            return Column(
              children: movements.map((m) {
                final isExpense = m.type == MovementType.expense;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _MovementTile(
                    icon: isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                    title: m.note ?? (isExpense ? 'Gasto' : 'Ingreso'),
                    category: 'Movimiento', // TODO: Fetch category name
                    amount: '${isExpense ? '-' : '+'}\$${(m.amount.minorUnits / 100).toStringAsFixed(2)}',
                    isExpense: isExpense,
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
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
