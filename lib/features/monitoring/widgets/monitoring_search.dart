import 'package:flutter/material.dart';

class MonitoringSearch extends StatelessWidget {
  final TextEditingController controller;
  final String selectedStatus;
  final ValueChanged<String?> onStatusChanged;

  const MonitoringSearch({
    super.key,
    required this.controller,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  static const List<String> _statuses = [
    "Semua",
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
    final searchField = TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Cari Batch / Operator...",
        prefixIcon: const Icon(Icons.search_rounded),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );

    final statusField = DropdownButtonFormField<String>(
      initialValue: selectedStatus,
      decoration: InputDecoration(
        labelText: "Status Produksi",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      items: _statuses
          .map((status) => DropdownMenuItem(value: status, child: Text(status)))
          .toList(),
      onChanged: onStatusChanged,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 850) {
          return Column(
            children: [
              searchField,
              const SizedBox(height: 16),
              statusField,
            ],
          );
        }

        return Row(
          children: [
            Expanded(flex: 3, child: searchField),
            const SizedBox(width: 16),
            SizedBox(width: 250, child: statusField),
          ],
        );
      },
    );
  }
}