import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/layout/app_layout.dart';
import '../widgets/approval_header.dart';
import '../widgets/approval_history_table.dart';
import '../widgets/approval_search.dart';
import '../widgets/approval_table.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({super.key});

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: "Persetujuan",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ApprovalHeader(),
            const SizedBox(height: 24),
            _buildTabSelector(),
            const SizedBox(height: 24),
            if (_selectedTab == 0) ...[
              const ApprovalSearch(),
              const SizedBox(height: 24),
              const ApprovalTable(),
            ] else
              const ApprovalHistoryTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Row(
      children: [
        _buildTabButton("Menunggu Approval", 0),
        const SizedBox(width: 12),
        _buildTabButton("Riwayat Approval", 1),
      ],
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _selectedTab == index;

    return OutlinedButton(
      onPressed: () => setState(() => _selectedTab = index),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : Colors.white,
        foregroundColor: isSelected ? Colors.white : AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label),
    );
  }
}