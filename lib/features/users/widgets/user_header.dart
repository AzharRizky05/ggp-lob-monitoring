import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class UserHeader extends StatelessWidget {
  final VoidCallback? onAdd;

  const UserHeader({
    super.key,
    this.onAdd,
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
                "Manajemen Pengguna",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Kelola akun Administrator, Operator Produksi, Quality Control, dan Supervisor pada sistem LOB Production Monitoring.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.person_add_alt_1_outlined),
          label: const Text("Tambah Pengguna"),
        ),
      ],
    );
  }
}