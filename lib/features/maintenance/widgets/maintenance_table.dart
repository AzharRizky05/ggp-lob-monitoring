import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/maintenance_model.dart';
import 'maintenance_status_chip.dart';

class MaintenanceTable extends StatelessWidget {
  const MaintenanceTable({super.key});

  @override
  Widget build(BuildContext context) {
    final schedules = <MaintenanceModel>[
      MaintenanceModel(
        id: "1",
        scheduleCode: "PM-001",
        assetName: "Conveyor Belt 01",
        scheduleDate: DateTime.now(),
        personInCharge: "Budi",
        status: "Terjadwal",
        createdAt: DateTime.now(),
      ),
      MaintenanceModel(
        id: "2",
        scheduleCode: "PM-002",
        assetName: "Boiler",
        scheduleDate: DateTime.now(),
        personInCharge: "Andi",
        status: "Berjalan",
        createdAt: DateTime.now(),
      ),
      MaintenanceModel(
        id: "3",
        scheduleCode: "PM-003",
        assetName: "Pompa Air",
        scheduleDate: DateTime.now(),
        personInCharge: "Rina",
        status: "Selesai",
        createdAt: DateTime.now(),
      ),
      MaintenanceModel(
        id: "4",
        scheduleCode: "PM-004",
        assetName: "Generator",
        scheduleDate: DateTime.now(),
        personInCharge: "Eko",
        status: "Terlambat",
        createdAt: DateTime.now(),
      ),
    ];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Kode")),
            DataColumn(label: Text("Nama Aset")),
            DataColumn(label: Text("Tanggal")),
            DataColumn(label: Text("PIC")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Aksi")),
          ],
          rows: schedules.map((schedule) {
            return DataRow(
              cells: [
                DataCell(Text(schedule.scheduleCode)),
                DataCell(Text(schedule.assetName)),
                DataCell(
                  Text(
                    DateFormat(
                      'dd MMM yyyy',
                      'id_ID',
                    ).format(schedule.scheduleDate),
                  ),
                ),
                DataCell(Text(schedule.personInCharge)),
                DataCell(
                  MaintenanceStatusChip(
                    status: schedule.status,
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility_outlined),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
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