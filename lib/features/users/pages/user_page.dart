import 'package:flutter/material.dart';

import '../../../shared/widgets/layout/app_layout.dart';
import '../widgets/add_user_dialog.dart';
import '../widgets/user_header.dart';
import '../widgets/user_search.dart';
import '../widgets/user_table.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Manajemen Pengguna",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserHeader(
              onAdd: () {
                showDialog(
                  context: context,
                  builder: (_) => const AddUserDialog(),
                );
              },
            ),

            const SizedBox(height: 24),

            const UserSearch(),

            const SizedBox(height: 24),

            const UserTable(),
          ],
        ),
      ),
    );
  }
}