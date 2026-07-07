import 'package:flutter/material.dart';

class BatchSearch extends StatelessWidget {
  const BatchSearch({super.key});

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
            initialValue: "Semua",
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
                value: "Persiapan Bahan",
                child: Text("Persiapan Bahan"),
              ),
              DropdownMenuItem(
                value: "Pencampuran",
                child: Text("Pencampuran"),
              ),
              DropdownMenuItem(
                value: "Fermentasi",
                child: Text("Fermentasi"),
              ),
              DropdownMenuItem(
                value: "Quality Control",
                child: Text("Quality Control"),
              ),
              DropdownMenuItem(
                value: "Pengemasan",
                child: Text("Pengemasan"),
              ),
              DropdownMenuItem(
                value: "Selesai",
                child: Text("Selesai"),
              ),
            ],
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}