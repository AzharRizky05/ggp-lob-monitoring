import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/buttons/outline_button.dart';
import '../../../shared/widgets/cards/section_card.dart';
import '../models/profile_view_data.dart';

/// Card kiri: Informasi Profil.
class ProfileInformationCard extends StatelessWidget {
  const ProfileInformationCard({
    super.key,
    required this.profile,
    required this.onEditProfile,
  });

  final ProfileViewData profile;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    final statusColor = profile.isActive ? AppColors.success : AppColors.danger;

    final rows = [
      _InfoRow(
        icon: Icons.person_outline,
        iconColor: Colors.blue,
        iconBackground: const Color(0xFFE3F2FD),
        label: 'Nama Lengkap',
        value: profile.fullName,
      ),
      _InfoRow(
        icon: Icons.mail_outline,
        iconColor: Colors.green,
        iconBackground: const Color(0xFFE8F5E9),
        label: 'Email',
        value: profile.email,
      ),
      _InfoRow(
        icon: Icons.phone_outlined,
        iconColor: Colors.teal,
        iconBackground: const Color(0xFFE0F2F1),
        label: 'Telepon',
        value: profile.phoneLabel,
      ),
      _InfoRow(
        icon: Icons.badge_outlined,
        iconColor: Colors.orange,
        iconBackground: const Color(0xFFFFF3E0),
        label: 'Role',
        value: profile.role,
      ),
      _InfoRow(
        icon: Icons.calendar_today_outlined,
        iconColor: Colors.purple,
        iconBackground: const Color(0xFFF3E5F5),
        label: 'Bergabung Sejak',
        value: profile.joinedLabel,
      ),
      _InfoRow(
        icon: Icons.verified_user_outlined,
        iconColor: statusColor,
        iconBackground: statusColor.withValues(alpha: 0.12),
        label: 'Status Akun',
        value: profile.statusLabel,
        valueColor: statusColor,
      ),
    ];

    return SectionCard(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Profil',
            style: AppTextStyles.title.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            'Kelola informasi profil dan detail akun Anda.',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.xl),
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1) ...[
              const SizedBox(height: AppSpacing.md),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
          const SizedBox(height: AppSpacing.xl),
          OutlineButton(
            text: 'Edit Profil',
            icon: Icons.edit_outlined,
            onPressed: onEditProfile,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: iconBackground,
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.body.copyWith(
                  color: valueColor ?? AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}