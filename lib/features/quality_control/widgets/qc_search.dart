import 'package:flutter/material.dart';

class QcSearch extends StatelessWidget {
  final TextEditingController controller;
  final String selectedResult;
  final ValueChanged<String?> onResultChanged;

  const QcSearch({
    super.key,
    required this.controller,
    required this.selectedResult,
    required this.onResultChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Cari kode batch atau petugas QC...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: selectedResult,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: "Semua",
                child: Text("Semua Hasil"),
              ),
              DropdownMenuItem(
                value: "PASS",
                child: Text("PASS"),
              ),
              DropdownMenuItem(
                value: "FAIL",
                child: Text("FAIL"),
              ),
              DropdownMenuItem(
                value: "PENDING",
                child: Text("PENDING"),
              ),
            ],
            onChanged: onResultChanged,
          ),
        ),
      ],
    );
  }
}