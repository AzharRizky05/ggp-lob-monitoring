import 'package:flutter/material.dart';

class ApprovalSearch extends StatefulWidget {
  const ApprovalSearch({super.key});

  @override
  State<ApprovalSearch> createState() => _ApprovalSearchState();
}

class _ApprovalSearchState extends State<ApprovalSearch> {
  String status = "Semua";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Cari kode batch atau operator...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 220,
          child: DropdownButtonFormField<String>(
            initialValue: status,
            decoration: InputDecoration(
              labelText: "Status Approval",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(
                value: "Semua",
                child: Text("Semua"),
              ),
              DropdownMenuItem(
                value: "Pending",
                child: Text("Pending"),
              ),
              DropdownMenuItem(
                value: "Disetujui",
                child: Text("Disetujui"),
              ),
              DropdownMenuItem(
                value: "Ditolak",
                child: Text("Ditolak"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                status = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}