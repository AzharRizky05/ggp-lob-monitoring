import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/cards/section_card.dart';
import '../../../shared/widgets/textfields/custom_text_field.dart';
import '../providers/profile_provider.dart';

/// Card kanan: Keamanan Akun (form ubah password).
class ProfileSecurityCard extends StatefulWidget {
  const ProfileSecurityCard({super.key});

  @override
  State<ProfileSecurityCard> createState() => _ProfileSecurityCardState();
}

class _ProfileSecurityCardState extends State<ProfileSecurityCard> {
  static const int _minPasswordLength = 6;

  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _error;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final current = _currentController.text;
    final newPassword = _newController.text;
    final confirm = _confirmController.text;

    String? error;
    if (newPassword.length < _minPasswordLength) {
      error = 'Password baru minimal $_minPasswordLength karakter.';
    } else if (newPassword != confirm) {
      error = 'Konfirmasi password tidak cocok.';
    } else if (newPassword == current) {
      error = 'Password baru harus berbeda dari password saat ini.';
    }

    if (error != null) {
      setState(() => _error = error);
      return;
    }

    setState(() => _error = null);

    final email = context.read<AuthProvider>().userProfile?.email ?? '';
    final provider = context.read<ProfileProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final success = await provider.changePassword(
      email: email,
      currentPassword: current,
      newPassword: newPassword,
    );

    if (!mounted) return;

    if (success) {
      _currentController.clear();
      _newController.clear();
      _confirmController.clear();
      messenger.showSnackBar(
        const SnackBar(content: Text('Password berhasil diubah.')),
      );
    } else {
      setState(() => _error = provider.errorMessage ?? 'Gagal mengubah password.');
    }
  }

  Widget _toggle(bool obscure, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(
        obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: AppColors.textSecondary,
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loading =
        context.select<ProfileProvider, bool>((p) => p.changingPassword);

    return SectionCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Keamanan Akun',
              style: AppTextStyles.title.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            Text(
              'Ubah password akun Anda secara berkala untuk menjaga keamanan.',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Password Saat Ini', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.xs),
            CustomTextField(
              controller: _currentController,
              hintText: 'Masukkan password saat ini',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureCurrent,
              suffixIcon: _toggle(
                _obscureCurrent,
                () => setState(() => _obscureCurrent = !_obscureCurrent),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Password Baru', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.xs),
            CustomTextField(
              controller: _newController,
              hintText: 'Masukkan password baru',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureNew,
              suffixIcon: _toggle(
                _obscureNew,
                () => setState(() => _obscureNew = !_obscureNew),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Konfirmasi Password Baru', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.xs),
            CustomTextField(
              controller: _confirmController,
              hintText: 'Konfirmasi password baru',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureConfirm,
              suffixIcon: _toggle(
                _obscureConfirm,
                () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                _error!,
                style: AppTextStyles.caption.copyWith(color: AppColors.danger),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              text: 'Ubah Password',
              onPressed: _submit,
              loading: loading,
            ),
          ],
        ),
      ),
    );
  }
}