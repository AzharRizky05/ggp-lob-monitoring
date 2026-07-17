import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/cards/section_card.dart';
import '../../../shared/widgets/textfields/custom_text_field.dart';

/// Card kanan: Keamanan Akun (form ubah password).
class ProfileSecurityCard extends StatefulWidget {
  final Future<void> Function(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) onChangePassword;

  const ProfileSecurityCard({super.key, required this.onChangePassword});

  @override
  State<ProfileSecurityCard> createState() => _ProfileSecurityCardState();
}

class _ProfileSecurityCardState extends State<ProfileSecurityCard> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSubmitting = false;
  String? _confirmError;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final isFormValid = _formKey.currentState!.validate();
    final passwordsMatch =
        _newPasswordController.text == _confirmPasswordController.text;

    setState(() {
      _confirmError =
          passwordsMatch ? null : 'Konfirmasi password tidak cocok';
    });

    if (!isFormValid || !passwordsMatch) return;

    setState(() => _isSubmitting = true);
    try {
      await widget.onChangePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
        _confirmPasswordController.text,
      );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _currentPasswordController,
              hintText: 'Masukkan password saat ini',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureCurrent,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureCurrent
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('Password Baru', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.xs),
            CustomTextField(
              controller: _newPasswordController,
              hintText: 'Masukkan password baru',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureNew,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNew
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('Konfirmasi Password Baru', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.xs),
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: 'Konfirmasi password baru',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            if (_confirmError != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                _confirmError!,
                style: AppTextStyles.caption.copyWith(color: AppColors.danger),
              ),
            ],

            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              text: 'Ubah Password',
              onPressed: _handleSubmit,
              loading: _isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}