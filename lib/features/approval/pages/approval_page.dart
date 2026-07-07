import 'package:flutter/material.dart';

import '../../../shared/widgets/layout/app_layout.dart';
import '../widgets/approval_header.dart';
import '../widgets/approval_search.dart';
import '../widgets/approval_table.dart';

class ApprovalPage extends StatelessWidget {
  const ApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      title: "Persetujuan",
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ApprovalHeader(),

            SizedBox(height: 24),

            ApprovalSearch(),

            SizedBox(height: 24),

            ApprovalTable(),
          ],
        ),
      ),
    );
  }
}