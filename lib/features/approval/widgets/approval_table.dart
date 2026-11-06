import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/approval_provider.dart';
import '../../../providers/auth_provider.dart';
import '../models/approval_model.dart';
import 'approval_action_dialog.dart';
import 'approval_status_chip.dart';

class ApprovalTable extends StatefulWidget {
  const ApprovalTable({super.key});

  @override
  State<ApprovalTable> createState() => _ApprovalTableState();
}

class _ApprovalTableState extends State<ApprovalTable> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApprovalProvider>().loadApprovals();
    });
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          FilledButton(
            style: confirmColor == null
                ? null
                : FilledButton.styleFrom(backgroundColor: confirmColor),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _decide(
    ApprovalProvider provider,
    ApprovalModel item, {
    required bool approve,
  }) async {
    final supervisorId = context.read<AuthProvider>().userProfile?.id;
    if (supervisorId == null) {
      _showMessage("Sesi supervisor tidak ditemukan.");
      return;
    }

    final confirmed = await _confirm(
      title: approve ? "Approve Batch?" : "Reject Batch?",
      message: approve
          ? "Batch ${item.batchCode} akan dinyatakan selesai dan masuk Production History."
          : "Batch ${item.batchCode} akan ditolak.",
      confirmLabel: approve ? "Approve" : "Reject",
      confirmColor: approve ? Colors.green : Colors.red,
    );

    if (!confirmed || !mounted) return;

    final success = approve
        ? await provider.approveBatch(
            batchId: item.batchId,
            supervisorId: supervisorId,
          )
        : await provider.rejectBatch(
            batchId: item.batchId,
            supervisorId: supervisorId,
          );

    if (!mounted) return;

    _showMessage(
      success
          ? (approve
              ? "Batch berhasil disetujui dan diselesaikan."
              : "Batch berhasil ditolak.")
          : provider.errorMessage ?? "Gagal memproses batch.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApprovalProvider>(
      builder: (context, provider, _) {
        if (provider.loading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (provider.approvals.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Text("Belum ada batch yang menunggu approval."),
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
                DataColumn(label: Text("Kode Batch")),
                DataColumn(label: Text("Operator")),
                DataColumn(label: Text("pH")),
                DataColumn(label: Text("QC Result")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("Tanggal")),
                DataColumn(label: Text("Aksi")),
              ],
              rows: provider.approvals.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item.batchCode)),
                    DataCell(Text(item.operatorName)),
                    DataCell(Text(item.ph.toStringAsFixed(2))),
                    DataCell(Text(item.qcResult)),
                    DataCell(ApprovalStatusChip(status: item.status)),
                    DataCell(
                      Text(
                        "${item.productionDate.day}/${item.productionDate.month}/${item.productionDate.year}",
                      ),
                    ),
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
                                    ApprovalActionDialog(approval: item),
                              );
                            },
                          ),
                          IconButton(
                            tooltip: "Approve",
                            color: Colors.green,
                            icon: const Icon(Icons.check_circle),
                            onPressed: () =>
                                _decide(provider, item, approve: true),
                          ),
                          IconButton(
                            tooltip: "Reject",
                            color: Colors.red,
                            icon: const Icon(Icons.cancel),
                            onPressed: () =>
                                _decide(provider, item, approve: false),
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
      },
    );
  }
}