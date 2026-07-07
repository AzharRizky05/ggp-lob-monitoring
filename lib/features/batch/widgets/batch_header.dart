import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'add_batch_dialog.dart';

class BatchHeader extends StatelessWidget {
  final bool isOperator;

  const BatchHeader({
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
                "Batch Produksi",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Kelola data batch produksi Liquid Organic Biofertilizer (LOB).",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AddBatchDialog(),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Tambah Batch"),
        ),
      ],
    );
  }
}