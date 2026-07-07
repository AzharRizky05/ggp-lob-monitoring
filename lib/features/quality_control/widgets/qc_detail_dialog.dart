import 'package:flutter/material.dart';

class QcDetailDialog extends StatelessWidget {
  const QcDetailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Detail Quality Control"),
      content: SizedBox(
        width: 550,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.qr_code),
                title: Text("Kode Batch"),
                subtitle: Text("LOB-2026-001"),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.person_outline),
                title: Text("Petugas QC"),
                subtitle: Text("Siti Rahma"),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.science_outlined),
                title: Text("pH Akhir"),
                subtitle: Text("6.8"),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.verified_outlined),
                title: Text("Hasil Uji"),
                subtitle: Text("Sesuai Standar"),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.assignment_turned_in_outlined),
                title: Text("Status"),
                subtitle: Text("Lulus"),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.note_alt_outlined),
                title: Text("Catatan"),
                subtitle: Text(
                  "Seluruh parameter kualitas memenuhi standar produksi.",
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        FilledButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          label: const Text("Tutup"),
        ),
      ],
    );
  }
}