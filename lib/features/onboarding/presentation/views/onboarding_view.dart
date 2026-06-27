import 'dart:ui';

import 'package:boveda_personal/app/router/app_router.dart';
import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/domain/value_objects/currency.dart';
import 'package:boveda_personal/core/domain/value_objects/money.dart';
import 'package:boveda_personal/features/onboarding/domain/entities/onboarding_setup.dart';
import 'package:boveda_personal/features/onboarding/presentation/providers.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rateController = TextEditingController(text: '1000.0');
  final _usdBalanceController = TextEditingController(text: '0.00');
  final _cupBalanceController = TextEditingController(text: '0.00');

  bool _isUsdMain = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _rateController.dispose();
    _usdBalanceController.dispose();
    _cupBalanceController.dispose();
    super.dispose();
  }

  void _onFinish() async {
    final cup = Currency(code: 'CUP', scale: 2);
    final usd = Currency(code: 'USD', scale: 2);

    final primaryCurrency = _isUsdMain ? usd : cup;
    final secondaryCurrency = _isUsdMain ? cup : usd;

    try {
      final initialExchangeRate = Decimal.parse(_rateController.text);
      final primaryMinor = (double.parse(_isUsdMain ? _usdBalanceController.text : _cupBalanceController.text) * 100).toInt();
      final secondaryMinor = (double.parse(_isUsdMain ? _cupBalanceController.text : _usdBalanceController.text) * 100).toInt();

      final setup = OnboardingSetup(
        displayName: _nameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        primaryCurrency: primaryCurrency,
        secondaryCurrency: secondaryCurrency,
        initialExchangeRate: initialExchangeRate,
        primaryOpeningBalance: Money(minorUnits: primaryMinor, currency: primaryCurrency),
        secondaryOpeningBalance: Money(minorUnits: secondaryMinor, currency: secondaryCurrency),
        locale: 'es_AR',
      );

      await ref.read(onboardingNotifierProvider.notifier).configure(setup);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en los datos ingresados: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(onboardingNotifierProvider, (previous, next) {
      if (next.completed && mounted) {
        context.go(AppRoutes.login);
      }
      if (next.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    });

    final onboardingState = ref.watch(onboardingNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Subtle Background Ambient Glow
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 2 - 200,
            child: Container(
              width: 400,
              height: 384,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.wealth.withValues(alpha: 0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: const SizedBox(),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Onboarding Header
                        Row(
                          children: [
                            const Icon(Icons.account_balance_wallet, color: AppColors.wealth, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'BÓVEDA PERSONAL',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppColors.wealth,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Configuración Inicial',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Establece tus credenciales y saldos iniciales para comenzar.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Section 1: Identidad
                        _SectionCard(
                          title: 'Identidad',
                          icon: Icons.badge_outlined,
                          indicatorColor: AppColors.surfaceHighest.withValues(alpha: 0.5),
                          children: [
                            _buildInputField(
                              controller: _nameController,
                              label: 'Nombre Completo',
                              hint: 'Ej. Juan Pérez',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _usernameController,
                              label: 'Nombre de Usuario',
                              hint: 'usuario123',
                              icon: Icons.alternate_email,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _passwordController,
                              label: 'Contraseña Maestra',
                              hint: '••••••••',
                              icon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: AppColors.outlineVariant,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Section 2: Configuración Financiera
                        _SectionCard(
                          title: 'Preferencias',
                          icon: Icons.settings_outlined,
                          indicatorColor: AppColors.surfaceHighest.withValues(alpha: 0.5),
                          children: [
                            _buildLabel('Moneda Principal'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _SegmentButton(
                                      title: 'USD',
                                      icon: Icons.attach_money,
                                      isSelected: _isUsdMain,
                                      onTap: () => setState(() => _isUsdMain = true),
                                    ),
                                  ),
                                  Expanded(
                                    child: _SegmentButton(
                                      title: 'ARS',
                                      isSelected: !_isUsdMain,
                                      onTap: () => setState(() => _isUsdMain = false),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _rateController,
                              label: 'Tasa de Cambio Inicial (USD a CUP)',
                              hint: 'Ej. 1050.50',
                              icon: Icons.currency_exchange,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Section 3: Saldos Iniciales
                        _SectionCard(
                          title: 'Saldos Iniciales',
                          icon: Icons.account_balance_outlined,
                          indicatorColor: AppColors.wealth.withValues(alpha: 0.3),
                          iconColor: AppColors.wealth,
                          children: [
                            _buildInputField(
                              controller: _usdBalanceController,
                              label: 'Saldo Inicial (USD)',
                              hint: '0.00',
                              prefixText: '\$',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              controller: _cupBalanceController,
                              label: 'Saldo Inicial (CUP)',
                              hint: '0.00',
                              prefixText: '\$',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 120), // padding for bottom action
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed Bottom Action Area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.8),
                    border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
                  ),
                  child: SafeArea(
                    top: false,
                    child: InkWell(
                      onTap: onboardingState.isLoading ? null : _onFinish,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.wealth,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.wealth.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (onboardingState.isLoading)
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF3C2F00),
                                ),
                              )
                            else ...[
                              Text(
                                'Finalizar',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF3C2F00), // on-secondary
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.check_circle, color: Color(0xFF3C2F00)),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    IconData? icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? prefixText,
    TextInputType? keyboardType,
    TextAlign textAlign = TextAlign.start,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textAlign: textAlign,
          style: const TextStyle(color: AppColors.onSurface, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.outlineVariant)
                : null,
            prefix: prefixText != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8, left: 16),
                    child: Text(prefixText, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16)),
                  )
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.08),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.wealth),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color indicatorColor;
  final Color? iconColor;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.indicatorColor,
    this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Left Indicator
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  color: indicatorColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: iconColor ?? AppColors.outlineVariant, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.onSurface,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...children,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.title,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.wealth : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? const Color(0xFF3C2F00) : AppColors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              title,
              style: TextStyle(
                color: isSelected ? const Color(0xFF3C2F00) : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
