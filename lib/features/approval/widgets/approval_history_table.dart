import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/approval_provider.dart';
import '../models/approval_history_model.dart';
import 'approval_detail_dialog.dart';
import 'approval_status_chip.dart';

class ApprovalHistoryTable extends StatefulWidget {
  const ApprovalHistoryTable({super.key, this.query = ''});

  /// Kata kunci pencarian dari halaman (kode batch, operator, atau supervisor).
  final String query;

  @override
  State<ApprovalHistoryTable> createState() => _ApprovalHistoryTableState();
}

class _ApprovalHistoryTableState extends State<ApprovalHistoryTable> {
  static const _statusOptions = ['Semua', 'Approved', 'Rejected'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ApprovalProvider>().loadApprovalHistory();
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day/$month/${local.year}';
  }

  bool _matches(ApprovalHistoryModel item) {
    final query = widget.query.trim().toLowerCase();
    if (query.isEmpty) return true;

    return item.batchCode.toLowerCase().contains(query) ||
        item.operatorName.toLowerCase().contains(query) ||
        item.supervisorName.toLowerCase().contains(query);
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
      return const _StateCard(child: CircularProgressIndicator());
    }

    if (provider.histories.isEmpty) {
      return const _StateCard(child: Text("Belum ada riwayat approval."));
    }

    final histories = provider.histories.where(_matches).toList();

    if (histories.isEmpty) {
      return const _StateCard(
        child: Text("Tidak ada riwayat yang sesuai pencarian."),
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
          rows: histories.map((item) {
            return DataRow(
              cells: [
                DataCell(Text(item.batchCode)),
                DataCell(Text(item.operatorName)),
                DataCell(ApprovalStatusChip(status: item.approvalStatus)),
                DataCell(Text(item.supervisorName)),
                DataCell(Text(_formatDate(item.approvedAt))),
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