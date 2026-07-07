import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'add_maintenance_dialog.dart';

class MaintenanceHeader extends StatelessWidget {
  const MaintenanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pemeliharaan Aset",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Kelola seluruh aktivitas pemeliharaan aset perusahaan.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.build_circle_outlined),
          label: const Text("Tambah Pemeliharaan"),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AddMaintenanceDialog(),
            );
          },
        ),
      ],
    );
  }
}