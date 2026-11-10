import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class UserSearch extends StatelessWidget {
  const UserSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    final roleItems = [
      UserProvider.allLabel,
      ...provider.roles.map((role) => role.name),
    ];

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            onChanged: context.read<UserProvider>().setSearchQuery,
            decoration: InputDecoration(
              hintText: "Cari nama atau email...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 220,
          child: DropdownButtonFormField<String>(
            initialValue: provider.roleFilter,
            decoration: InputDecoration(
              labelText: "Role",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              isDense: true,
            ),
            items: roleItems
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) {
              if (value != null) provider.setRoleFilter(value);
            },
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 180,
          child: DropdownButtonFormField<String>(
            initialValue: provider.statusFilter,
            decoration: InputDecoration(
              labelText: "Status",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              isDense: true,
            ),
            items: UserProvider.statusOptions
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (value) {
              if (value != null) provider.setStatusFilter(value);
            },
          ),
        ),
      ],
    );
  }
}