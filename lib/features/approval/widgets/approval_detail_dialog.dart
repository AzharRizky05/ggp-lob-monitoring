import 'package:flutter/material.dart';

import '../models/approval_history_model.dart';
import 'batch_timeline.dart';

class ApprovalDetailDialog extends StatelessWidget {
  final ApprovalHistoryModel history;

  const ApprovalDetailDialog({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Detail Approval Batch"),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BatchTimeline(status: history.approvalStatus),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.qr_code),
                title: const Text("Kode Batch"),
                subtitle: Text(history.batchCode),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person_outline),
                title: const Text("Operator"),
                subtitle: Text(history.operatorName),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text("Tanggal Produksi"),
                subtitle: Text(
                  "${history.productionDate.day}/${history.productionDate.month}/${history.productionDate.year}",
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.supervisor_account_outlined),
                title: const Text("Supervisor"),
                subtitle: Text(history.supervisorName),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.flag_outlined),
                title: const Text("Status Approval"),
                subtitle: Text(history.approvalStatus),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_available_outlined),
                title: const Text("Waktu Approval"),
                subtitle: Text(
                  history.approvedAt == null
                      ? "-"
                      : "${history.approvedAt!.day}/${history.approvedAt!.month}/${history.approvedAt!.year} "
                          "${history.approvedAt!.hour.toString().padLeft(2, '0')}:${history.approvedAt!.minute.toString().padLeft(2, '0')}",
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.note_alt_outlined),
                title: const Text("Catatan Supervisor"),
                subtitle: Text(history.comments.isEmpty ? "-" : history.comments),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Tutup"),
        ),
      ],
    );
  }
}