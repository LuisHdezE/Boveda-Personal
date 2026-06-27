import 'package:boveda_personal/app/theme/app_colors.dart';
import 'package:boveda_personal/core/providers/core_providers.dart';
import 'package:boveda_personal/features/auth/presentation/providers.dart';
import 'package:boveda_personal/shared/presentation/widgets/glass_card.dart';
import 'package:boveda_personal/shared/presentation/widgets/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileUserProvider = FutureProvider.autoDispose<Map<String, Object?>?>((ref) async {
  final session = ref.watch(sessionProvider);
  if (session.userId == null) return null;
  return ref.watch(userSettingsDaoProvider).findUserById(session.userId!);
});

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool _isEditing = false;
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _onSave(String userId) async {
    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    if (name.isEmpty || username.isEmpty) return;

    await ref.read(userSettingsDaoProvider).updateUser(userId, name, username);
    ref.invalidate(profileUserProvider);
    if (mounted) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncUser = ref.watch(profileUserProvider);
    return MainScaffold(
      title: 'Perfil',
      showBackButton: true,
      showBottomNav: false,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.wealth.withValues(alpha: 0.15),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 128,
                      height: 128,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDytY1XT87AUaq4Mx7yT3xQ-Mh0hfxG9cbjw9vIdIUWoFgqJuO1gJWfmJGG76UMyWoaKG1WhN8x9mxkNDlKAqeVfbOlNQrZSinGyuZSh0dXdEtKJ5IYZfvxq-8HvYwaJVRNxSRb4_licHD9fT4spY_fr5gT4pGotMRHIqALoGw_MuDcPmgZNx9G9POTZmMgOPp5nMscdg4RFovLWFSeJckau2pNF5N07yDmTmXFCovLPeGfB2B7FsJO7GcYVz8S1dLREGxSnQzm4o0',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.person,
                            size: 64,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                asyncUser.when(
                  data: (userMap) {
                    if (userMap == null) return const Text('Usuario no encontrado');
                    final userId = userMap['id'] as String;
                    final displayName = userMap['display_name'] as String;
                    final username = userMap['username'] as String;

                    if (!_isEditing) {
                      _nameController.text = displayName;
                      _usernameController.text = username;
                    }

                    return Column(
                      children: [
                        if (_isEditing) ...[
                          GlassCard(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: TextField(
                              controller: _nameController,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Nombre y Apellido',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GlassCard(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: TextField(
                              controller: _usernameController,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Usuario',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ] else ...[
                          Text(
                            displayName,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@$username',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.email, size: 16, color: AppColors.onSurfaceVariant),
                            const SizedBox(width: 8),
                            Text(
                              'usuario@bovedapersonal.com',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (_isEditing) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = false;
                                  });
                                },
                                child: const Text('Cancelar', style: TextStyle(color: AppColors.onSurfaceVariant)),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () => _onSave(userId),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.wealth,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                child: const Text('Guardar'),
                              ),
                            ],
                          )
                        ] else ...[
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isEditing = true;
                              });
                            },
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Editar Perfil'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.wealth,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 4,
                              shadowColor: AppColors.wealth.withValues(alpha: 0.15),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Error: $e'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Quick Stats Bento Grid
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text(
                            'Meses Activo',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '34',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppColors.wealth,
                                  height: 1,
                                ),
                          ),
                          const Spacer(),
                          Text(
                            'meses',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.sync_alt, size: 18, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text(
                            'Movimientos',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '1.2k',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppColors.onSurface,
                                  height: 1,
                                ),
                          ),
                          const Spacer(),
                          const Icon(Icons.trending_up, color: AppColors.tertiary, size: 24),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Security Level
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: const Icon(Icons.verified_user, color: AppColors.wealth, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nivel de Seguridad',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.onSurface,
                            ),
                      ),
                      Text(
                        'Biometría activada',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    'Máxima',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.tertiary,
                        ),
                  ),
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
