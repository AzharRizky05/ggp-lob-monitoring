import 'package:flutter/material.dart';

import '../../../core/responsive/responsive_builder.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/outline_button.dart';
import '../../../shared/widgets/cards/section_card.dart';
import '../models/profile_dummy_data.dart';

/// Card horizontal di bagian atas halaman Profile.
class ProfileSummaryCard extends StatelessWidget {
  final VoidCallback onEditProfile;

  const ProfileSummaryCard({super.key, required this.onEditProfile});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBuilder.isMobile(context);

    final avatarAndInfo = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.primary,
          backgroundImage: ProfileDummyData.photoUrl != null
              ? NetworkImage(ProfileDummyData.photoUrl!)
              : null,
          child: ProfileDummyData.photoUrl == null
              ? Text(
                  ProfileDummyData.initial,
                  style: AppTextStyles.heading2.copyWith(color: Colors.white),
                )
              : null,
        ),
        const SizedBox(width: AppSpacing.lg),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ProfileDummyData.fullName, style: AppTextStyles.title),
              const SizedBox(height: 2),
              Text(ProfileDummyData.email, style: AppTextStyles.caption),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  _RoleBadge(label: ProfileDummyData.role),
                  _StatusBadge(label: ProfileDummyData.status),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final editButton = OutlineButton(
      text: 'Edit Profil',
      icon: Icons.edit_outlined,
      onPressed: onEditProfile,
    );

    return SectionCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatarAndInfo,
                const SizedBox(height: AppSpacing.lg),
                SizedBox(width: double.infinity, child: editButton),
              ],
            )
          : Row(
              children: [
                Expanded(child: avatarAndInfo),
                editButton,
              ],
            ),
    );
  }
}

/// Badge outline untuk Role — mengikuti style badge putih berbingkai
/// seperti pada modul Settings.
class _RoleBadge extends StatelessWidget {
  final String label;

  const _RoleBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.admin_panel_settings, size: 16, color: AppColors.info),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge filled hijau untuk Status — mengikuti style badge "Aktif"
/// seperti pada modul Settings.
class _StatusBadge extends StatelessWidget {
  final String label;

  const _StatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.xxl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 16, color: AppColors.success),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}