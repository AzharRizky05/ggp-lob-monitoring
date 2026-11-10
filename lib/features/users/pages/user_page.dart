import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/layout/app_layout.dart';
import '../providers/user_provider.dart';
import '../widgets/add_user_dialog.dart';
import '../widgets/user_header.dart';
import '../widgets/user_search.dart';
import '../widgets/user_table.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const _UsersView(),
    );
  }
}

class _UsersView extends StatelessWidget {
  const _UsersView();

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
                showUserDialog(context);
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