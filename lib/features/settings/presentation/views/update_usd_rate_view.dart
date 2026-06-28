import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/features/settings/presentation/providers.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateUsdRateView extends ConsumerStatefulWidget {
  const UpdateUsdRateView({super.key});

  @override
  ConsumerState<UpdateUsdRateView> createState() => _UpdateUsdRateViewState();
}

class _UpdateUsdRateViewState extends ConsumerState<UpdateUsdRateView> {
  final _rateController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _rateController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(updateRateNotifierProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: AppColors.expense),
        );
      }
      if (next.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tasa actualizada exitosamente'), backgroundColor: AppColors.income),
        );
        ref.read(updateRateNotifierProvider.notifier).resetSuccess();
        _rateController.clear();
      }
    });

    final state = ref.watch(updateRateNotifierProvider);

    return MainScaffold(
      title: 'Tasa de Cambio',
      showBackButton: true,
      showBottomNav: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // Rate Card
          Stack(
            children: [
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'TASA ACTUAL',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 1.5,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '1',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.wealth,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'USD',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '=',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(width: 12),
                        Consumer(
                          builder: (context, ref, _) {
                            final secCode = ref.watch(appSettingsProvider).value?.secondaryCurrencyCode ?? 'CUP';
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '850.50',
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        color: AppColors.onSurface,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  secCode,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.tertiary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.trending_up, color: AppColors.tertiary, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '+2.5% última semana',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.tertiary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topLeft,
                      radius: 1.5,
                      colors: [
                        AppColors.wealth.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Input Section
          Consumer(
            builder: (context, ref, _) {
              final secCode = ref.watch(appSettingsProvider).value?.secondaryCurrencyCode ?? 'CUP';
              return Text(
                'NUEVA TASA ($secCode)',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.5,
                    ),
              );
            },
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: _isFocused ? 0.1 : 0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Stack(
              children: [
                TextField(
                  controller: _rateController,
                  focusNode: _focusNode,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.onSurface,
                      ),
                  decoration: InputDecoration(
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '\$',
                        style: TextStyle(fontSize: 22, color: AppColors.wealth, fontWeight: FontWeight.bold),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    suffixIcon: Consumer(
                      builder: (context, ref, _) {
                        final secCode = ref.watch(appSettingsProvider).value?.secondaryCurrencyCode ?? 'CUP';
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            secCode,
                            style: const TextStyle(fontSize: 22, color: AppColors.onSurfaceVariant),
                          ),
                        );
                      }
                    ),
                    suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    hintText: '850.50',
                    hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.2),
                        ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2,
                    color: _isFocused ? AppColors.wealth : Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: state.isLoading
                ? null
                : () {
                    final secCode = ref.read(appSettingsProvider).value?.secondaryCurrencyCode ?? 'CUP';
                    ref.read(updateRateNotifierProvider.notifier).save(
                          baseCurrency: secCode,
                          quoteCurrency: 'USD',
                          rateText: _rateController.text,
                        );
                  },
            icon: state.isLoading 
              ? const SizedBox(
                  width: 20, 
                  height: 20, 
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)
                ) 
              : const Icon(Icons.sync, color: Colors.black),
            label: Text(
              state.isLoading ? 'ACTUALIZANDO...' : 'ACTUALIZAR TASA',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.wealth,
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: AppColors.wealth.withValues(alpha: 0.15),
            ),
          ),
          const SizedBox(height: 40),
          // History Section
          Row(
            children: [
              const Icon(Icons.history, color: AppColors.wealth, size: 20),
              const SizedBox(width: 8),
              Text(
                'Historial Reciente',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                _HistoryItem(
                  rate: '850.50',
                  date: 'Hoy, 10:30 AM',
                  diff: '15.00',
                  isUp: true,
                  source: 'Auto',
                ),
                const Divider(color: Colors.white10, height: 1),
                _HistoryItem(
                  rate: '835.50',
                  date: '24 Oct, 09:15 AM',
                  diff: '5.50',
                  isUp: false,
                  source: 'Manual',
                ),
                const Divider(color: Colors.white10, height: 1),
                _HistoryItem(
                  rate: '841.00',
                  date: '20 Oct, 14:00 PM',
                  diff: 'Base',
                  isUp: null,
                  source: 'Sistema',
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.rate,
    required this.date,
    required this.diff,
    required this.isUp,
    required this.source,
  });

  final String rate;
  final String date;
  final String diff;
  final bool? isUp;
  final String source;

  @override
  Widget build(BuildContext context) {
    Color? diffColor;
    IconData diffIcon;
    
    if (isUp == true) {
      diffColor = AppColors.tertiary;
      diffIcon = Icons.arrow_upward;
    } else if (isUp == false) {
      diffColor = AppColors.expense;
      diffIcon = Icons.arrow_downward;
    } else {
      diffColor = AppColors.onSurfaceVariant;
      diffIcon = Icons.horizontal_rule;
    }

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$rate CUP',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                ),
                Text(
                  date,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(diffIcon, color: diffColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      diff,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: diffColor,
                          ),
                    ),
                  ],
                ),
                Text(
                  source,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
