import 'package:flutter/material.dart';

class MaintenanceSearch extends StatefulWidget {
  const MaintenanceSearch({super.key});

  @override
  State<MaintenanceSearch> createState() => _MaintenanceSearchState();
}

class _MaintenanceSearchState extends State<MaintenanceSearch> {
  String status = "Semua";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Cari aset atau teknisi...",
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
            initialValue: status,
            decoration: InputDecoration(
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
                value: "Berjalan",
                child: Text("Berjalan"),
              ),
              DropdownMenuItem(
                value: "Selesai",
                child: Text("Selesai"),
              ),
              DropdownMenuItem(
                value: "Dijadwalkan",
                child: Text("Dijadwalkan"),
              ),
            ],
            onChanged: (v) {
              setState(() {
                status = v!;
              });
            },
          ),
        ),
      ],
    );
  }
}