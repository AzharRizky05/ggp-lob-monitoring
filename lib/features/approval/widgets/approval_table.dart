import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/approval_provider.dart';
import '../../../providers/auth_provider.dart';
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
                final isReadyToComplete = item.status == 'Approved';

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
                                builder: (_) => ApprovalActionDialog(approval: item),
                              );
                            },
                          ),
                          if (!isReadyToComplete) ...[
                            IconButton(
                              tooltip: "Approve",
                              color: Colors.green,
                              icon: const Icon(Icons.check_circle),
                              onPressed: () async {
                                final supervisorId =
                                    context.read<AuthProvider>().userProfile?.id;
                                if (supervisorId == null) return;

                                final success = await provider.approveBatch(
                                  batchId: item.batchId,
                                  supervisorId: supervisorId,
                                );

                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? "Batch berhasil diapprove."
                                          : provider.errorMessage ?? "Gagal approve batch.",
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              tooltip: "Reject",
                              color: Colors.red,
                              icon: const Icon(Icons.cancel),
                              onPressed: () async {
                                final supervisorId =
                                    context.read<AuthProvider>().userProfile?.id;
                                if (supervisorId == null) return;

                                final success = await provider.rejectBatch(
                                  batchId: item.batchId,
                                  supervisorId: supervisorId,
                                );

                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? "Batch berhasil direject."
                                          : provider.errorMessage ?? "Gagal reject batch.",
                                    ),
                                  ),
                                );
                              },
                            ),
                          ] else
                            TextButton.icon(
                              icon: const Icon(Icons.task_alt, size: 18),
                              label: const Text("Complete"),
                              onPressed: () async {
                                final supervisorId =
                                    context.read<AuthProvider>().userProfile?.id;
                                if (supervisorId == null) return;

                                final success = await provider.completeBatch(
                                  batchId: item.batchId,
                                  supervisorId: supervisorId,
                                );

                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      success
                                          ? "Batch berhasil diselesaikan."
                                          : provider.errorMessage ?? "Gagal menyelesaikan batch.",
                                    ),
                                  ),
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
      },
    );
  }
}