import 'package:flutter/material.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({super.key});

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  String role = "Semua";
  String status = "Semua";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            decoration: InputDecoration(
              hintText: "Cari nama pengguna atau email...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              isDense: true,
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: role,
            decoration: InputDecoration(
              labelText: "Role",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(
                value: "Semua",
                child: Text("Semua Role"),
              ),
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
            onChanged: (value) {
              setState(() {
                role = value!;
              });
            },
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: status,
            decoration: InputDecoration(
              labelText: "Status",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(
                value: "Semua",
                child: Text("Semua Status"),
              ),
              DropdownMenuItem(
                value: "Aktif",
                child: Text("Aktif"),
              ),
              DropdownMenuItem(
                value: "Nonaktif",
                child: Text("Nonaktif"),
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