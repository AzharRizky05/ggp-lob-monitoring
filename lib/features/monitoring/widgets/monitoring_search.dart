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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 850;

        if (mobile) {
          return Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Cari Batch / Operator...",
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: selectedStatus,
                decoration: InputDecoration(
                  labelText: "Status Produksi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Semua",
                    child: Text("Semua"),
                  ),
                  DropdownMenuItem(
                    value: "Preparation",
                    child: Text("Preparation"),
                  ),
                  DropdownMenuItem(
                    value: "Mixing",
                    child: Text("Mixing"),
                  ),
                  DropdownMenuItem(
                    value: "Fermentation",
                    child: Text("Fermentation"),
                  ),
                  DropdownMenuItem(
                    value: "Filtering",
                    child: Text("Filtering"),
                  ),
                  DropdownMenuItem(
                    value: "Packaging",
                    child: Text("Packaging"),
                  ),
                  DropdownMenuItem(
                    value: "QC Pending",
                    child: Text("QC Pending"),
                  ),
                  DropdownMenuItem(
                    value: "Completed",
                    child: Text("Completed"),
                  ),
                ],
                onChanged: onStatusChanged,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Cari Batch / Operator...",
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            SizedBox(
              width: 250,
              child: DropdownButtonFormField<String>(
                initialValue: selectedStatus,
                decoration: InputDecoration(
                  labelText: "Status Produksi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Semua",
                    child: Text("Semua"),
                  ),
                  DropdownMenuItem(
                    value: "Preparation",
                    child: Text("Preparation"),
                  ),
                  DropdownMenuItem(
                    value: "Mixing",
                    child: Text("Mixing"),
                  ),
                  DropdownMenuItem(
                    value: "Fermentation",
                    child: Text("Fermentation"),
                  ),
                  DropdownMenuItem(
                    value: "Filtering",
                    child: Text("Filtering"),
                  ),
                  DropdownMenuItem(
                    value: "Packaging",
                    child: Text("Packaging"),
                  ),
                  DropdownMenuItem(
                    value: "QC Pending",
                    child: Text("QC Pending"),
                  ),
                  DropdownMenuItem(
                    value: "Completed",
                    child: Text("Completed"),
                  ),
                ],
                onChanged: onStatusChanged,
              ),
            ),
          ],
        );
      },
    );
  }
}