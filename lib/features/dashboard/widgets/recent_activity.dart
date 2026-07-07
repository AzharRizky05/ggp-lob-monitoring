import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/dashboard_data.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({
    super.key,
    this.items = const [],
    this.loading = false,
  });

  final List<RecentBatchItem> items;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Aktivitas Produksi Terbaru",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Lihat Semua"),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Memuat aktivitas terbaru...'),
              )
            else if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Belum ada aktivitas terbaru.'),
              )
            else
              ...items.asMap().entries.expand((entry) {
                final index = entry.key;
                final item = entry.value;

                return [
                  _activityTile(
                    Icons.inventory_2_outlined,
                    index.isEven ? Colors.blue : Colors.green,
                    item.status,
                    '${item.batchCode} • ${item.operatorName}',
                    item.updatedAt,
                  ),
                  if (index < items.length - 1) const Divider(),
                ];
              }),
          ],
        ),
      ),
    );
  }

  Widget _activityTile(
    IconData icon,
    Color color,
    String title,
    String subtitle,
    String time,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }
}