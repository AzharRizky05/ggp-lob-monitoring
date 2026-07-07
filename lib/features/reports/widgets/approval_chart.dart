import 'package:flutter/material.dart';

class ApprovalChart extends StatelessWidget {
  const ApprovalChart({super.key});

  @override
  Widget build(BuildContext context) {
    final selesai = 110;
    final berjalan = 10;
    final terlambat = 5;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Status Produksi Batch",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              title: const Text("Selesai"),
              trailing: Text(
                "$selesai Batch",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.autorenew,
                color: Colors.orange,
              ),
              title: const Text("Berjalan"),
              trailing: Text(
                "$berjalan Batch",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
              ),
              title: const Text("Terlambat"),
              trailing: Text(
                "$terlambat Batch",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}