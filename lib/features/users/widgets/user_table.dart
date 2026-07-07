import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'add_user_dialog.dart';
import 'role_chip.dart';

class UserTable extends StatelessWidget {
  const UserTable({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      UserModel(
        id: "USR001",
        nama: "Administrator",
        email: "admin@lob.com",
        role: "Administrator",
        status: "Aktif",
        terakhirLogin: DateTime.now(),
      ),
      UserModel(
        id: "USR002",
        nama: "Budi Santoso",
        email: "operator@lob.com",
        role: "Operator Produksi",
        status: "Aktif",
        terakhirLogin: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      UserModel(
        id: "USR003",
        nama: "Siti Rahma",
        email: "qc@lob.com",
        role: "Quality Control",
        status: "Aktif",
        terakhirLogin: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      UserModel(
        id: "USR004",
        nama: "Ahmad Fauzi",
        email: "supervisor@lob.com",
        role: "Supervisor",
        status: "Aktif",
        terakhirLogin: DateTime.now().subtract(const Duration(days: 1)),
      ),
      UserModel(
        id: "USR005",
        nama: "Guest User",
        email: "viewer@lob.com",
        role: "Viewer",
        status: "Nonaktif",
        terakhirLogin: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 56,
          dataRowMinHeight: 72,
          dataRowMaxHeight: 72,
          columns: const [
            DataColumn(label: Text("ID")),
            DataColumn(label: Text("Nama")),
            DataColumn(label: Text("Email")),
            DataColumn(label: Text("Role")),
            DataColumn(label: Text("Status")),
            DataColumn(label: Text("Login Terakhir")),
            DataColumn(label: Text("Aksi")),
          ],
          rows: users.map((user) {
            return DataRow(
              cells: [
                DataCell(Text(user.id)),
                DataCell(Text(user.nama)),
                DataCell(Text(user.email)),

                DataCell(
                  RoleChip(
                    role: user.role,
                  ),
                ),

                DataCell(
                  Chip(
                    backgroundColor: user.status == "Aktif"
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    avatar: Icon(
                      user.status == "Aktif"
                          ? Icons.check_circle
                          : Icons.cancel,
                      size: 18,
                      color: user.status == "Aktif"
                          ? Colors.green
                          : Colors.red,
                    ),
                    label: Text(user.status),
                  ),
                ),

                DataCell(
                  Text(
                    "${user.terakhirLogin.day}/${user.terakhirLogin.month}/${user.terakhirLogin.year}",
                  ),
                ),

                DataCell(
                  Row(
                    children: [
                      IconButton(
                        tooltip: "Edit",
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => const AddUserDialog(),
                          );
                        },
                      ),
                      IconButton(
                        tooltip: "Hapus",
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Hapus Pengguna"),
                              content: Text(
                                "Apakah Anda yakin ingin menghapus ${user.nama}?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Batal"),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                          );
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