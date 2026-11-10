import 'package:flutter/material.dart';

import '../../batch/widgets/batch_status_chip.dart';
import '../models/monitoring_model.dart';
import 'edit_monitoring_dialog.dart';
import 'monitoring_detail_dialog.dart';

class MonitoringTable extends StatelessWidget {
  const MonitoringTable({
    super.key,
    this.monitoring = const [],
    this.loading = false,
    this.isOperator = false,
    this.emptyMessage = "Belum ada data monitoring.",
  });

  final List<MonitoringModel> monitoring;
  final bool loading;
  final bool isOperator;
  final String emptyMessage;

  /// Data monitoring pada batch yang sudah final tidak boleh diubah lagi.
  static const Set<String> _lockedStatuses = {'Completed', 'Rejected'};

  String _formatTime(DateTime date) {
    final local = date.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} '
        '${two(local.hour)}:${two(local.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const _StateCard(child: CircularProgressIndicator());
    }

    if (monitoring.isEmpty) {
      return _StateCard(child: Text(emptyMessage));
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 60,
          dataRowMinHeight: 60,
          dataRowMaxHeight: 68,
          columns: const [
            DataColumn(label: Text("Batch")),
            DataColumn(label: Text("Operator")),
            DataColumn(label: Text("Tahap")),
            DataColumn(label: Text("Status Batch")),
            DataColumn(label: Text("Dicatat")),
            DataColumn(label: Text("Temperature")),
            DataColumn(label: Text("pH")),
            DataColumn(label: Text("Brix")),
            DataColumn(label: Text("Volume")),
            DataColumn(label: Text("Action")),
          ],
          rows: monitoring.map((item) {
            final locked = _lockedStatuses.contains(item.status);

            return DataRow(
              cells: [
                DataCell(
                  Text(
                    item.batchCode,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(Text(item.operatorName)),
                DataCell(
                  item.stage.isEmpty
                      ? const Text("-")
                      : BatchStatusChip(status: item.stage),
                ),
                DataCell(BatchStatusChip(status: item.status)),
                DataCell(Text(_formatTime(item.recordedAt))),
                DataCell(Text("${item.temperature.toStringAsFixed(1)} °C")),
                DataCell(Text(item.ph.toStringAsFixed(1))),
                DataCell(Text(item.brix.toStringAsFixed(1))),
                DataCell(Text("${item.volume.toStringAsFixed(0)} L")),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: "Detail",
                        icon: const Icon(Icons.visibility_outlined),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                MonitoringDetailDialog(monitoring: item),
                          );
                        },
                      ),
                      if (isOperator)
                        IconButton(
                          tooltip: locked
                              ? "Data batch yang sudah final tidak dapat diubah"
                              : "Edit Monitoring",
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: locked
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (_) =>
                                        EditMonitoringDialog(monitoring: item),
                                  );
                                },
                        ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(child: child),
      ),
    );
  }
}