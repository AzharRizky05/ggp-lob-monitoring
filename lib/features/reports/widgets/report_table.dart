import 'package:flutter/material.dart';

class ReportTable extends StatelessWidget {
  const ReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Bulan")),
            DataColumn(label: Text("Pemeliharaan")),
            DataColumn(label: Text("QC")),
            DataColumn(label: Text("Approval")),
            DataColumn(label: Text("Riwayat")),
          ],
          rows: const [
            DataRow(cells: [
              DataCell(Text("Januari")),
              DataCell(Text("12")),
              DataCell(Text("11")),
              DataCell(Text("10")),
              DataCell(Text("12")),
            ]),
            DataRow(cells: [
              DataCell(Text("Februari")),
              DataCell(Text("18")),
              DataCell(Text("17")),
              DataCell(Text("16")),
              DataCell(Text("18")),
            ]),
            DataRow(cells: [
              DataCell(Text("Maret")),
              DataCell(Text("14")),
              DataCell(Text("13")),
              DataCell(Text("12")),
              DataCell(Text("14")),
            ]),
            DataRow(cells: [
              DataCell(Text("April")),
              DataCell(Text("22")),
              DataCell(Text("21")),
              DataCell(Text("20")),
              DataCell(Text("22")),
            ]),
          ],
        ),
      ),
    );
  }
}