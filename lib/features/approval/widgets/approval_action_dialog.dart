import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/approval_provider.dart';
import '../../../providers/auth_provider.dart';
import '../models/approval_model.dart';
import 'batch_timeline.dart';

class ApprovalActionDialog extends StatefulWidget {
  final ApprovalModel approval;

  const ApprovalActionDialog({super.key, required this.approval});

  @override
  State<ApprovalActionDialog> createState() => _ApprovalActionDialogState();
}

class _ApprovalActionDialogState extends State<ApprovalActionDialog> {
  final TextEditingController _noteController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String? _currentSupervisorId(BuildContext context) {
    return context.read<AuthProvider>().userProfile?.id;
  }

  Future<void> _approve() async {
    final supervisorId = _currentSupervisorId(context);
    if (supervisorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sesi supervisor tidak ditemukan.")),
      );
      return;
    }

    setState(() => _loading = true);
    final provider = context.read<ApprovalProvider>();

    final success = await provider.approveBatch(
      batchId: widget.approval.batchId,
      supervisorId: supervisorId,
      comments: _noteController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Batch berhasil disetujui.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? "Gagal melakukan approval.")),
      );
    }
  }

  Future<void> _reject() async {
    final supervisorId = _currentSupervisorId(context);
    if (supervisorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sesi supervisor tidak ditemukan.")),
      );
      return;
    }

    setState(() => _loading = true);
    final provider = context.read<ApprovalProvider>();

    final success = await provider.rejectBatch(
      batchId: widget.approval.batchId,
      supervisorId: supervisorId,
      comments: _noteController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Batch berhasil ditolak.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? "Gagal melakukan reject.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.approval;
    final canDecide = item.status == 'Waiting Approval';

    return AlertDialog(
      title: const Text("Approval Batch Produksi"),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BatchTimeline(status: item.status),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.qr_code),
                title: const Text("Kode Batch"),
                subtitle: Text(item.batchCode),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person_outline),
                title: const Text("Operator"),
                subtitle: Text(item.operatorName),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text("Tanggal Produksi"),
                subtitle: Text(
                  "${item.productionDate.day}/${item.productionDate.month}/${item.productionDate.year}",
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.science_outlined),
                title: const Text("pH Akhir"),
                subtitle: Text(item.ph.toStringAsFixed(2)),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.verified_outlined),
                title: const Text("Hasil QC"),
                subtitle: Text(item.qcResult),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.note_alt_outlined),
                title: const Text("Catatan QC"),
                subtitle: Text(item.qcNotes.isEmpty ? "-" : item.qcNotes),
              ),
              if (canDecide) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Catatan Supervisor",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text("Tutup"),
        ),
        if (canDecide) ...[
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: _loading ? null : _reject,
            icon: const Icon(Icons.close),
            label: const Text("Reject"),
          ),
          FilledButton.icon(
            onPressed: _loading ? null : _approve,
            icon: const Icon(Icons.check),
            label: const Text("Approve"),
          ),
        ],
      ],
    );
  }
}