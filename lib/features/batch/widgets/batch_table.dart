import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/batch_provider.dart';
import '../models/batch_model.dart';
import 'add_batch_dialog.dart';
import 'batch_status_chip.dart';

class BatchTable extends StatelessWidget {
  const BatchTable({
    super.key,
    this.batches = const [],
    this.loading = false,
    this.isOperator = false,
  });

  final List<BatchModel> batches;
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
            DataColumn(label: Text("Batch Code")),
            DataColumn(label: Text("Production Date")),
            DataColumn(label: Text("Operator")),
            DataColumn(label: Text("Target Volume")),
            DataColumn(label: Text("Status")),
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
          ],
        ),
      ];
    }

    if (batches.isEmpty) {
      return const [
        DataRow(
          cells: [
            DataCell(Text("No production batch available")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
            DataCell(Text("")),
          ],
        ),
      ];
    }

    return batches.map((batch) {
      return DataRow(
        cells: [
          DataCell(
            Text(batch.batchCode),
          ),

          DataCell(
            Text(
              "${batch.productionDate.day}/${batch.productionDate.month}/${batch.productionDate.year}",
            ),
          ),

          DataCell(
            Text(batch.operatorName),
          ),

          DataCell(
            Text(
              "${batch.targetVolume.toStringAsFixed(0)} L",
            ),
          ),

          DataCell(
            BatchStatusChip(
              status: batch.status,
            ),
          ),

          DataCell(
            Row(
              children: [
                IconButton(
                  tooltip: "Detail",
                  onPressed: () {
                    _showDetail(context, batch);
                  },
                  icon: const Icon(Icons.visibility_outlined),
                ),
                IconButton(
                  tooltip: "Edit",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AddBatchDialog(
                        batch: batch,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                ),
                if (!isOperator || batch.status == "Draft")
                  IconButton(
                    tooltip: "Delete",
                    onPressed: () {
                      _showDelete(context, batch);
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  )
                else
                  Tooltip(
                    message: "Hanya batch Draft yang bisa dihapus",
                    child: IconButton(
                      tooltip: "Delete",
                      onPressed: null,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  void _showDetail(BuildContext context, BatchModel batch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Detail Batch Produksi"),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text("Batch Code: ${batch.batchCode}"),
              Text("Tanggal Produksi: ${batch.productionDate.day}/${batch.productionDate.month}/${batch.productionDate.year}"),
              Text("Operator: ${batch.operatorName}"),
              Text("Target Volume: ${batch.targetVolume.toStringAsFixed(0)} L"),
              Text("Status: ${batch.status}"),
              Text("Catatan: ${batch.notes}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _showDelete(BuildContext context, BatchModel batch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Batch"),  
        content: const Text("Apakah yakin menghapus batch ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              context.read<BatchProvider>().deleteBatch(batch.id);
              Navigator.pop(context);
            },
            child: const Text(
              "YA",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
