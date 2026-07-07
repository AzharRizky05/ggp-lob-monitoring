import 'package:flutter/material.dart';

class ReportFilter extends StatefulWidget {
  const ReportFilter({super.key});

  @override
  State<ReportFilter> createState() => _ReportFilterState();
}

class _ReportFilterState extends State<ReportFilter> {
  String bulan = "Mei";
  String tahun = "2026";
  String status = "Semua";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 220,
          child: DropdownButtonFormField<String>(
            initialValue: bulan,
            decoration: const InputDecoration(
              labelText: "Bulan",
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: "Januari", child: Text("Januari")),
              DropdownMenuItem(value: "Februari", child: Text("Februari")),
              DropdownMenuItem(value: "Maret", child: Text("Maret")),
              DropdownMenuItem(value: "April", child: Text("April")),
              DropdownMenuItem(value: "Mei", child: Text("Mei")),
              DropdownMenuItem(value: "Juni", child: Text("Juni")),
              DropdownMenuItem(value: "Juli", child: Text("Juli")),
              DropdownMenuItem(value: "Agustus", child: Text("Agustus")),
              DropdownMenuItem(value: "September", child: Text("September")),
              DropdownMenuItem(value: "Oktober", child: Text("Oktober")),
              DropdownMenuItem(value: "November", child: Text("November")),
              DropdownMenuItem(value: "Desember", child: Text("Desember")),
            ],
            onChanged: (value) {
              setState(() {
                bulan = value!;
              });
            },
          ),
        ),

        const SizedBox(width: 16),

        SizedBox(
          width: 160,
          child: DropdownButtonFormField<String>(
            initialValue: tahun,
            decoration: const InputDecoration(
              labelText: "Tahun",
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: "2025", child: Text("2025")),
              DropdownMenuItem(value: "2026", child: Text("2026")),
              DropdownMenuItem(value: "2027", child: Text("2027")),
            ],
            onChanged: (value) {
              setState(() {
                tahun = value!;
              });
            },
          ),
        ),

        const SizedBox(width: 16),

        SizedBox(
          width: 220,
          child: DropdownButtonFormField<String>(
            initialValue: status,
            decoration: const InputDecoration(
              labelText: "Status Batch",
              border: OutlineInputBorder(),
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
                value: "Terlambat",
                child: Text("Terlambat"),
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