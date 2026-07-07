import 'package:flutter/material.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Tambah Pengguna"),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Role",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Administrator",
                    child: Text("Administrator"),
                  ),
                  DropdownMenuItem(
                    value: "Operator Produksi",
                    child: Text("Operator Produksi"),
                  ),
                  DropdownMenuItem(
                    value: "Quality Control",
                    child: Text("Quality Control"),
                  ),
                  DropdownMenuItem(
                    value: "Supervisor",
                    child: Text("Supervisor"),
                  ),
                  DropdownMenuItem(
                    value: "Viewer",
                    child: Text("Viewer"),
                  ),
                ],
                onChanged: (_) {},
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: "Aktif",
                decoration: const InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.toggle_on_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Aktif",
                    child: Text("Aktif"),
                  ),
                  DropdownMenuItem(
                    value: "Nonaktif",
                    child: Text("Nonaktif"),
                  ),
                ],
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.save_outlined),
          label: const Text("Simpan"),
        ),
      ],
    );
  }
}