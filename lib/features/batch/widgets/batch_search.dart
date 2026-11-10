import 'package:flutter/material.dart';

class BatchSearch extends StatelessWidget {
  const BatchSearch({
    super.key,
    required this.controller,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  final TextEditingController controller;
  final String selectedStatus;
  final ValueChanged<String?> onStatusChanged;

  static const List<String> _statuses = [
    "Semua",
    "Draft",
    "Preparation",
    "Mixing",
    "Fermentation",
    "Filtering",
    "Packaging",
    "QC Pending",
    "QC Failed",
    "Waiting Approval",
    "Rejected",
    "Completed",
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Cari kode batch atau operator...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 240,
          child: DropdownButtonFormField<String>(
            initialValue: selectedStatus,
            decoration: InputDecoration(
              labelText: "Status Produksi",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            items: _statuses
                .map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ),
                )
                .toList(),
            onChanged: onStatusChanged,
          ),
        ),
      ],
    );
  }
}