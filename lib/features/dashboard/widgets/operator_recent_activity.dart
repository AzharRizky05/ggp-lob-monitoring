import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../batch/widgets/batch_status_chip.dart';
import '../models/dashboard_data.dart';

class OperatorRecentActivity extends StatelessWidget {
  const OperatorRecentActivity({
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
                  "Batch Terbaru",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go(RouteName.batch),
                  child: const Text("Lihat Semua"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Memuat batch terbaru...'),
              )
            else if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Belum ada batch. Buat batch pertama Anda di menu Production Batch.',
                ),
              )
            else
              for (int i = 0; i < items.length; i++) ...[
                _tile(items[i]),
                if (i < items.length - 1) const Divider(),
              ],
          ],
        ),
      ),
    );
  }

  Widget _tile(RecentBatchItem item) {
    final color = _statusColor(item.status);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(Icons.inventory_2_outlined, color: color),
      ),
      title: Text(
        item.batchCode,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: BatchStatusChip(status: item.status),
        ),
      ),
      trailing: Text(
        _formatTime(item.updatedAt),
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Rejected':
      case 'QC Failed':
        return Colors.red;
      case 'Waiting Approval':
        return Colors.purple;
      case 'QC Pending':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String _formatTime(String raw) {
    final date = DateTime.tryParse(raw)?.toLocal();
    if (date == null) return raw;

    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year} '
        '${two(date.hour)}:${two(date.minute)}';
  }
}