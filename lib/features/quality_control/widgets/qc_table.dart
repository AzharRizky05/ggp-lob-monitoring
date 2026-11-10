import 'package:flutter/material.dart';

import '../../batch/widgets/batch_status_chip.dart';
import '../../history/widgets/history_status_chip.dart';
import '../models/qc_model.dart';
import 'edit_qc_dialog.dart';
import 'qc_detail_dialog.dart';

class QcTable extends StatelessWidget {
  final List<QcModel> qualityControls;
  final bool loading;
  final bool isQc;
  final String emptyMessage;

  const QcTable({
    super.key,
    required this.qualityControls,
    required this.loading,
    this.isQc = false,
    this.emptyMessage = "Belum ada data Quality Control",
  });

  /// QC hanya boleh mengoreksi hasil selama batch belum diputuskan Supervisor.
  static const Set<String> _editableStatuses = {
    'Waiting Approval',
    'QC Passed',
    'QC Failed',
  };

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (qualityControls.isEmpty) {
      return Card(
        child: SizedBox(
          height: 220,
          child: Center(
            child: Text(
              emptyMessage,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 56,
          dataRowMinHeight: 56,
          dataRowMaxHeight: 72,
          columns: const [
            DataColumn(label: Text("Batch")),
            DataColumn(label: Text("QC")),
            DataColumn(label: Text("pH")),
            DataColumn(label: Text("Result")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Tanggal")),
            DataColumn(label: Text("Action")),
          ],
          rows: qualityControls.map((item) {
            final editable = _editableStatuses.contains(item.status);

            return DataRow(
              cells: [
                DataCell(
                  Text(
                    item.batchCode,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                DataCell(Text(item.qcName)),
                DataCell(Text(item.ph.toStringAsFixed(1))),
                DataCell(HistoryStatusChip(status: item.result)),
                DataCell(BatchStatusChip(status: item.status)),
                DataCell(Text(_formatDate(item.inspectionDate))),
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
                            builder: (_) => QcDetailDialog(qc: item),
                          );
                        },
                      ),
                      if (isQc)
                        IconButton(
                          tooltip: editable
                              ? "Edit"
                              : "Tidak dapat diedit: batch sudah diputuskan Supervisor",
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: editable
                              ? () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => EditQcDialog(qc: item),
                                  );
                                }
                              : null,
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