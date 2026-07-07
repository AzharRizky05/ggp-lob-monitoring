import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'history_detail_dialog.dart';

class HistoryHeader extends StatelessWidget {
  final bool isOperator;

  const HistoryHeader({
    super.key,
    this.isOperator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
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
          ),
        ),
        FilledButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const HistoryDetailDialog(),
            );
          },
          icon: const Icon(Icons.receipt_long),
          label: const Text("Detail Batch"),
        ),
      ],
    );
  }
}