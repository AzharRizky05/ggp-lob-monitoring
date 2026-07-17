import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// Header halaman Profile: judul + tanggal hari ini.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile', style: AppTextStyles.heading2),
        const SizedBox(height: AppSpacing.xs),
        Text(today, style: AppTextStyles.caption),
      ],
    );
  }
}