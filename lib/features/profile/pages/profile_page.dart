import 'package:flutter/material.dart';

import '../../../core/responsive/responsive_builder.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/layout/app_layout.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_information_card.dart';
import '../widgets/profile_security_card.dart';
import '../widgets/profile_summary_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _handleEditProfile(BuildContext context) {
    // TODO: buka dialog/halaman Edit Profile
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Profile - belum diimplementasikan')),
    );
  }

  Future<void> _handleChangePassword(
    BuildContext context,
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    // TODO: hubungkan ke Supabase auth, mis:
    // await SupabaseService.client.auth.updateUser(
    //   UserAttributes(password: newPassword),
    // );
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diubah (dummy)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Profile',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeader(),
            const SizedBox(height: AppSpacing.xxl),
            ProfileSummaryCard(
              onEditProfile: () => _handleEditProfile(context),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _buildContentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    final infoCard = ProfileInformationCard(
      onEditProfile: () => _handleEditProfile(context),
    );
    final securityCard = ProfileSecurityCard(
      onChangePassword: (current, newPass, confirm) =>
          _handleChangePassword(context, current, newPass, confirm),
    );

    // Desktop & tablet: dua kolom berdampingan.
    // Mobile: satu kolom.
    if (!ResponsiveBuilder.isMobile(context)) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: infoCard),
            const SizedBox(width: AppSpacing.xxl),
            Expanded(child: securityCard),
          ],
        ),
      );
    }

    return Column(
      children: [
        infoCard,
        const SizedBox(height: AppSpacing.xxl),
        securityCard,
      ],
    );
  }
}