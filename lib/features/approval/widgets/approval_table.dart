import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/approval_provider.dart';
import '../../../providers/auth_provider.dart';
import '../models/approval_model.dart';
import 'approval_action_dialog.dart';
import 'approval_status_chip.dart';

class ApprovalTable extends StatefulWidget {
  const ApprovalTable({super.key, this.query = ''});

  /// Kata kunci pencarian dari halaman (kode batch atau operator).
  final String query;

  @override
  State<ApprovalTable> createState() => _ApprovalTableState();
}

class _ApprovalTableState extends State<ApprovalTable> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ApprovalProvider>().loadApprovals();
    });
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  bool _matches(ApprovalModel item) {
    final query = widget.query.trim().toLowerCase();
    if (query.isEmpty) return true;

    return item.batchCode.toLowerCase().contains(query) ||
        item.operatorName.toLowerCase().contains(query);
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
          return const _StateCard(child: CircularProgressIndicator());
        }

        if (provider.approvals.isEmpty) {
          return const _StateCard(
            child: Text("Belum ada batch yang menunggu approval."),
          );
        }

        final approvals = provider.approvals.where(_matches).toList();

        if (approvals.isEmpty) {
          return const _StateCard(
            child: Text("Tidak ada batch yang sesuai pencarian."),
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
              rows: approvals.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item.batchCode)),
                    DataCell(Text(item.operatorName)),
                    DataCell(Text(item.ph.toStringAsFixed(2))),
                    DataCell(Text(item.qcResult)),
                    DataCell(ApprovalStatusChip(status: item.status)),
                    DataCell(Text(_formatDate(item.productionDate))),
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