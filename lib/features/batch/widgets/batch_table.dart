import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/batch_provider.dart';
import '../models/batch_model.dart';
import 'add_batch_dialog.dart';
import 'batch_detail_dialog.dart';
import 'batch_status_chip.dart';

class BatchTable extends StatelessWidget {
  const BatchTable({
    super.key,
    this.batches = const [],
    this.loading = false,
    this.isOperator = false,
    this.canManage,
    this.emptyMessage = "No production batch available",
  });

  final List<BatchModel> batches;
  final bool loading;
  final bool isOperator;

  /// Boleh mengedit dan menghapus. Kalau tidak diisi, mengikuti [isOperator].
  final bool? canManage;

  final String emptyMessage;

  bool get _canManage => canManage ?? isOperator;

  /// Batch hanya boleh diedit atau dihapus selama belum diproses.
  /// Batch baru dibuat berstatus Preparation, dan status maju otomatis
  /// setiap monitoring disimpan, jadi batch yang sudah berjalan terkunci.
  static const Set<String> _editableStatuses = {'Draft', 'Preparation'};

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Future<void> _confirmDelete(BuildContext context, BatchModel batch) async {
    final provider = context.read<BatchProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Batch"),
        content: Text(
          "Batch ${batch.batchCode} akan dihapus permanen. Lanjutkan?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await provider.deleteBatch(batch.id);

    final error = provider.errorMessage?.replaceFirst('Exception: ', '');

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Batch ${batch.batchCode} berhasil dihapus."
              : (error ?? "Gagal menghapus batch."),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const _StateCard(child: CircularProgressIndicator());
    }

    if (batches.isEmpty) {
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
            DataColumn(label: Text("Batch Code")),
            DataColumn(label: Text("Production Date")),
            DataColumn(label: Text("Operator")),
            DataColumn(label: Text("Target Volume")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Action")),
          ],
          rows: batches.map((batch) {
            final editable = _editableStatuses.contains(batch.status);

            return DataRow(
              cells: [
                DataCell(Text(batch.batchCode)),
                DataCell(Text(_formatDate(batch.productionDate))),
                DataCell(Text(batch.operatorName)),
                DataCell(Text("${batch.targetVolume.toStringAsFixed(0)} L")),
                DataCell(BatchStatusChip(status: batch.status)),
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
                            builder: (_) => BatchDetailDialog(batch: batch),
                          );
                        },
                      ),
                      if (_canManage) ...[
                        IconButton(
                          tooltip: editable
                              ? "Edit"
                              : "Batch sudah diproses, tidak dapat diubah",
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: editable
                              ? () {
                                  showDialog(
                                    context: context,
                                    builder: (_) =>
                                        AddBatchDialog(batch: batch),
                                  );
                                }
                              : null,
                        ),
                        IconButton(
                          tooltip: editable
                              ? "Delete"
                              : "Hanya batch yang belum diproses yang dapat dihapus",
                          icon: Icon(
                            Icons.delete_outline,
                            color: editable ? Colors.red : Colors.grey,
                          ),
                          onPressed: editable
                              ? () => _confirmDelete(context, batch)
                              : null,
                        ),
                      ],
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