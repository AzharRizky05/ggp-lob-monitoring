import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({super.key});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool maintenanceNotification = true;
  bool qcNotification = true;
  bool approvalNotification = true;
  bool reportNotification = false;
  bool emailNotification = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pengaturan Notifikasi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 24),

            SwitchListTile(
              value: maintenanceNotification,
              onChanged: (value) {
                setState(() {
                  maintenanceNotification = value;
                });
              },
              secondary: const Icon(Icons.build_outlined),
              title: const Text("Notifikasi Pemeliharaan"),
              subtitle: const Text(
                "Pemberitahuan jadwal maintenance aset.",
              ),
            ),

            const Divider(),

            SwitchListTile(
              value: qcNotification,
              onChanged: (value) {
                setState(() {
                  qcNotification = value;
                });
              },
              secondary: const Icon(Icons.verified_outlined),
              title: const Text("Notifikasi Quality Control"),
              subtitle: const Text(
                "Informasi hasil inspeksi QC terbaru.",
              ),
            ),

            const Divider(),

            SwitchListTile(
              value: approvalNotification,
              onChanged: (value) {
                setState(() {
                  approvalNotification = value;
                });
              },
              secondary: const Icon(Icons.fact_check_outlined),
              title: const Text("Notifikasi Approval"),
              subtitle: const Text(
                "Pemberitahuan approval dari Supervisor.",
              ),
            ),

            const Divider(),

            SwitchListTile(
              value: reportNotification,
              onChanged: (value) {
                setState(() {
                  reportNotification = value;
                });
              },
              secondary: const Icon(Icons.bar_chart_outlined),
              title: const Text("Notifikasi Laporan"),
              subtitle: const Text(
                "Pengingat laporan mingguan dan bulanan.",
              ),
            ),

            const Divider(),

            SwitchListTile(
              value: emailNotification,
              onChanged: (value) {
                setState(() {
                  emailNotification = value;
                });
              },
              secondary: const Icon(Icons.email_outlined),
              title: const Text("Email Notification"),
              subtitle: const Text(
                "Kirim pemberitahuan melalui email.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}