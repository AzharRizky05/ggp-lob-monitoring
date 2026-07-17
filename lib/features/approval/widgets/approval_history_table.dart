import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/approval_provider.dart';
import 'approval_detail_dialog.dart';
import 'approval_status_chip.dart';

class ApprovalHistoryTable extends StatefulWidget {
  const ApprovalHistoryTable({super.key});

  @override
  State<ApprovalHistoryTable> createState() => _ApprovalHistoryTableState();
}

class _ApprovalHistoryTableState extends State<ApprovalHistoryTable> {
  static const _statusOptions = ['Semua', 'Approved', 'Rejected', 'Completed'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApprovalProvider>().loadApprovalHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApprovalProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Filter Status",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: provider.historyStatusFilter,
                  items: _statusOptions
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      provider.loadApprovalHistory(status: value);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildContent(provider),
          ],
        );
      },
    );
  }

  Widget _buildContent(ApprovalProvider provider) {
    if (provider.historyLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (provider.histories.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: Text("Belum ada riwayat approval.")),
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
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Supervisor")),
            DataColumn(label: Text("Tanggal Approval")),
            DataColumn(label: Text("Aksi")),
          ],
          rows: provider.histories.map((item) {
            return DataRow(
              cells: [
                DataCell(Text(item.batchCode)),
                DataCell(Text(item.operatorName)),
                DataCell(ApprovalStatusChip(status: item.status)),
                DataCell(Text(item.supervisorName)),
                DataCell(
                  Text(
                    "${item.approvedAt.day}/${item.approvedAt.month}/${item.approvedAt.year}",
                  ),
                ),
                DataCell(
                  IconButton(
                    tooltip: "Detail",
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => ApprovalDetailDialog(history: item),
                      );
                    },
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