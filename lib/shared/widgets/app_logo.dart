import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AppLogo({
    super.key,
    this.size = 80,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: Icon(
            Icons.eco,
            color: Colors.white,
            size: size * 0.6,
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 12),
          Text(
            'LOB Monitoring',
            style: AppTextStyles.heading2,
          ),
          Text(
            'Great Giant Pineapple',
            style: AppTextStyles.caption,
          ),
        ]
      ],
    );
  }
}