import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});

  @override
  ConsumerState<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final FocusNode _currentFocus = FocusNode();
  final FocusNode _newFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  @override
  void dispose() {
    _currentFocus.dispose();
    _newFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Cambio de Contraseña',
      showBackButton: true,
      showBottomNav: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        children: [
          // Header
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.lock_reset,
                  size: 48,
                  color: AppColors.wealth,
                ),
                const SizedBox(height: 16),
                Text(
                  'Asegura tu bóveda con una contraseña fuerte y única.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Form Card
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _PasswordField(
                  label: 'Contraseña Actual',
                  hint: '••••••••',
                  focusNode: _currentFocus,
                  obscureText: _obscureCurrent,
                  onToggleVisibility: () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
                const Divider(color: Colors.white10, height: 1),
                _PasswordField(
                  label: 'Nueva Contraseña',
                  hint: 'Mínimo 8 caracteres',
                  focusNode: _newFocus,
                  obscureText: _obscureNew,
                  onToggleVisibility: () => setState(() => _obscureNew = !_obscureNew),
                ),
                // Checklist
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, size: 16, color: AppColors.tertiary),
                          const SizedBox(width: 8),
                          Text(
                            'Mínimo 8 caracteres',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.tertiary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.radio_button_unchecked, size: 16, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text(
                            'Un número o símbolo',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white10, height: 1),
                _PasswordField(
                  label: 'Confirmar Nueva Contraseña',
                  hint: 'Repite tu nueva contraseña',
                  focusNode: _confirmFocus,
                  obscureText: _obscureConfirm,
                  onToggleVisibility: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save, color: Colors.black),
            label: Text(
              'Actualizar Contraseña',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.label,
    required this.hint,
    required this.focusNode,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  final String label;
  final String hint;
  final FocusNode focusNode;
  final bool obscureText;
  final VoidCallback onToggleVisibility;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: _isFocused ? 0.05 : 0.02),
        border: Border(
          bottom: BorderSide(
            color: _isFocused ? AppColors.wealth : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 4, left: 16, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: _isFocused ? AppColors.wealth : AppColors.onSurfaceVariant,
                ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: widget.focusNode,
                  obscureText: widget.obscureText,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurface,
                      ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  widget.obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: widget.onToggleVisibility,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
