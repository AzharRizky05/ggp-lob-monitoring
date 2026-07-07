import 'package:flutter/material.dart';

import '../models/monitoring_model.dart';
import 'monitoring_status_chip.dart';

class MonitoringTable extends StatelessWidget {
  const MonitoringTable({
    super.key,
    this.monitoring = const [],
    this.loading = false,
    this.isOperator = false,
  });

  final List<MonitoringModel> monitoring;
  final bool loading;
  final bool isOperator;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 60,
          dataRowMinHeight: 60,
          dataRowMaxHeight: 68,
          columns: const [
            DataColumn(label: Text("Batch")),
            DataColumn(label: Text("Operator")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Temperature")),
            DataColumn(label: Text("pH")),
            DataColumn(label: Text("Brix")),
            DataColumn(label: Text("Volume")),
            DataColumn(label: Text("Action")),
          ],
          rows: _buildRows(context),
        ),
      ),
    );
  }

  List<DataRow> _buildRows(BuildContext context) {
    if (loading) {
      return const [
        DataRow(
          cells: [
            DataCell(Text("Loading...")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        ),
      ];
    }

    if (monitoring.isEmpty) {
      return const [
        DataRow(
          cells: [
            DataCell(Text("Belum ada data monitoring")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        ),
      ];
    }

    return monitoring.map((item) {
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
            Text(item.operatorName),
          ),

          DataCell(
            MonitoringStatusChip(
              status: item.status,
            ),
          ),

          DataCell(
            Text(
              "${item.temperature.toStringAsFixed(1)} °C",
            ),
          ),

          DataCell(
            Text(
              item.ph.toStringAsFixed(1),
            ),
          ),

          DataCell(
            Text(
              item.brix.toStringAsFixed(1),
            ),
          ),

          DataCell(
            Text(
              "${item.volume.toStringAsFixed(0)} L",
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
                    // TODO:
                    // Dialog Detail Monitoring
                  },
                ),

                if (isOperator)
                  IconButton(
                    tooltip: "Update Monitoring",
                    icon: const Icon(
                      Icons.edit_outlined,
                    ),
                    onPressed: () {
                      // TODO:
                      // Dialog Update Monitoring
                    },
                  ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }
}