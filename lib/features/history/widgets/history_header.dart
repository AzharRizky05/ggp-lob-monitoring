import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Riwayat Produksi",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Seluruh batch produksi yang telah selesai beserta hasil Quality Control dan approval supervisor.",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}