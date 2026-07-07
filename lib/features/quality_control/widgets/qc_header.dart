import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'add_qc_dialog.dart';

class QcHeader extends StatelessWidget {
  final bool isQc;

  const QcHeader({
    super.key,
    this.isQc = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Quality Control",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Melakukan pemeriksaan kualitas setiap batch Liquid Organic Biofertilizer (LOB). "
                "Petugas Quality Control memverifikasi parameter hasil produksi sebelum batch "
                "diteruskan ke tahap Approval atau dikembalikan apabila tidak memenuhi standar.",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 24),

        if (isQc)
          FilledButton.icon(
            icon: const Icon(Icons.science_outlined),
            label: const Text("Input Hasil QC"),
            onPressed: () {
              debugPrint("================================");
              debugPrint("TOMBOL INPUT QC DITEKAN");
              debugPrint("================================");

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  debugPrint("================================");
                  debugPrint("MEMBUAT AddQcDialog");
                  debugPrint("================================");

                  return const AddQcDialog();
                },
              );
            },
          ),
      ],
    );
  }
}