import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'add_monitoring_dialog.dart';

class MonitoringHeader extends StatelessWidget {
  final bool isOperator;

  const MonitoringHeader({
    super.key,
    this.isOperator = false,
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
                "Production Monitoring",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Monitoring proses produksi Liquid Organic Biofertilizer (LOB) secara real-time. "
                "Operator mencatat parameter produksi pada setiap tahapan proses, "
                "Quality Control melakukan pemeriksaan kualitas, dan Supervisor memantau seluruh aktivitas produksi.",
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

        if (isOperator)
          FilledButton.icon(
            icon: const Icon(Icons.add_rounded),
            label: const Text("Tambah Monitoring"),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const AddMonitoringDialog(),
              );
            },
          ),
      ],
    );
  }
}