import 'package:flutter/material.dart';

import '../models/qc_model.dart';
import 'qc_result_chip.dart';
import 'qc_status_chip.dart';

class QcTable extends StatelessWidget {
  final List<QcModel> qualityControls;
  final bool loading;
  final bool isQc;

  const QcTable({
    super.key,
    required this.qualityControls,
    required this.loading,
    this.isQc = false,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (qualityControls.isEmpty) {
      return const Card(
        child: SizedBox(
          height: 220,
          child: Center(
            child: Text(
              "Belum ada data Quality Control",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 56,
          dataRowMinHeight: 56,
          dataRowMaxHeight: 72,
          columns: const [
            DataColumn(label: Text("Batch")),
            DataColumn(label: Text("QC")),
            DataColumn(label: Text("pH")),
            DataColumn(label: Text("Result")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Tanggal")),
            DataColumn(label: Text("Action")),
          ],
          rows: qualityControls.map((item) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    item.batchCode,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                DataCell(
                  Text(item.qcName),
                ),

                DataCell(
                  Text(
                    item.ph.toStringAsFixed(1),
                  ),
                ),

                DataCell(
                  QcResultChip(
                    hasilUji: item.result,
                  ),
                ),

                DataCell(
                  QcStatusChip(
                    status: item.status,
                  ),
                ),

                DataCell(
                  Text(
                    "${item.inspectionDate.day}/${item.inspectionDate.month}/${item.inspectionDate.year}",
                  ),
                ),

                DataCell(
                  Row(
                    children: [
                      IconButton(
                        tooltip: "Detail",
                        icon: const Icon(
                          Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          // TODO Detail QC
                        },
                      ),

                      if (isQc)
                        IconButton(
                          tooltip: "Edit",
                          icon: const Icon(
                            Icons.edit_outlined,
                          ),
                          onPressed: () {
                            // TODO Edit QC
                          },
                        ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}