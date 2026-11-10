import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import 'add_user_dialog.dart';
import 'role_chip.dart';

class UserTable extends StatelessWidget {
  const UserTable({super.key});

  Future<void> _toggleActive(
    BuildContext context,
    UserProvider provider,
    UserModel user,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(user.isActive ? "Nonaktifkan Pengguna" : "Aktifkan Pengguna"),
        content: Text(
          user.isActive
              ? "${user.fullName} tidak akan dapat login sampai diaktifkan kembali."
              : "${user.fullName} akan dapat login kembali.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Batal"),
          ),
          FilledButton(
            style: user.isActive
                ? FilledButton.styleFrom(backgroundColor: Colors.red)
                : null,
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(user.isActive ? "Nonaktifkan" : "Aktifkan"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success = await provider.toggleActive(user);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? (user.isActive
                  ? "${user.fullName} dinonaktifkan."
                  : "${user.fullName} diaktifkan.")
              : provider.actionError ?? "Gagal mengubah status pengguna.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, _) {
        if (provider.loading) {
          return const _StateCard(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return _StateCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Gagal memuat data pengguna."),
                const SizedBox(height: 8),
                Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: provider.loadData,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        }

        final users = provider.users;

        if (users.isEmpty) {
          return _StateCard(
            child: Text(
              provider.totalUsers == 0
                  ? "Belum ada pengguna."
                  : "Tidak ada pengguna yang sesuai filter.",
            ),
          );
        }

        final selfId = context.read<AuthProvider>().userProfile?.id;

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
                DataColumn(label: Text("Nama")),
                DataColumn(label: Text("Email")),
                DataColumn(label: Text("Telepon")),
                DataColumn(label: Text("Role")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("Dibuat")),
                DataColumn(label: Text("Aksi")),
              ],
              rows: users.map((user) {
                final isSelf = user.id == selfId;

                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        user.fullName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    DataCell(Text(user.email)),
                    DataCell(Text(user.phoneLabel)),
                    DataCell(RoleChip(role: user.roleName)),
                    DataCell(
                      Chip(
                        backgroundColor: user.isActive
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        avatar: Icon(
                          user.isActive ? Icons.check_circle : Icons.cancel,
                          size: 18,
                          color: user.isActive ? Colors.green : Colors.red,
                        ),
                        label: Text(user.statusLabel),
                      ),
                    ),
                    DataCell(Text(user.createdLabel)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            tooltip: "Edit",
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => showUserDialog(context, user: user),
                          ),
                          IconButton(
                            tooltip: isSelf
                                ? "Tidak dapat menonaktifkan akun sendiri"
                                : (user.isActive ? "Nonaktifkan" : "Aktifkan"),
                            icon: Icon(
                              user.isActive
                                  ? Icons.block_outlined
                                  : Icons.restart_alt,
                              color: isSelf
                                  ? Colors.grey
                                  : (user.isActive ? Colors.red : Colors.green),
                            ),
                            onPressed: isSelf
                                ? null
                                : () => _toggleActive(context, provider, user),
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
      },
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(child: child),
      ),
    );
  }
}