import 'package:flutter/material.dart';

class HistorySearch extends StatefulWidget {
  const HistorySearch({super.key});

  @override
  State<HistorySearch> createState() => _HistorySearchState();
}

class _HistorySearchState extends State<HistorySearch> {
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
          width: 240,
          child: DropdownButtonFormField<String>(
            initialValue: status,
            decoration: InputDecoration(
              labelText: "Status Produksi",
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
                value: "Proses",
                child: Text("Proses"),
              ),
              DropdownMenuItem(
                value: "Selesai",
                child: Text("Selesai"),
              ),
              DropdownMenuItem(
                value: "Ditolak",
                child: Text("Ditolak"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                status = value ?? "Semua";
              });
            },
          ),
        ),
      ],
    );
  }
}