import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

class OperatorSummaryCards extends StatelessWidget {
  final int totalBatches;
  final int activeBatches;
  final int completedBatches;
  final int pendingApprovals;
  final bool loading;

  const OperatorSummaryCards({
    super.key,
    this.totalBatches = 0,
    this.activeBatches = 0,
    this.completedBatches = 0,
    this.pendingApprovals = 0,
    this.loading = false,
  });

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.2,
        children: List.generate(
          4,
          (index) => Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (totalBatches == 0 &&
        activeBatches == 0 &&
        completedBatches == 0 &&
        pendingApprovals == 0) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.inbox_rounded,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  "Belum ada Production Batch",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Silakan buat Production Batch baru untuk memulai proses produksi.",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 1000;
        final crossAxisCount = isMobile ? 2 : 4;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.1,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildCard(
              context,
              title: "Production Batch Saya",
              value: totalBatches.toString(),
              subtitle: "Semua batch yang Anda buat",
              icon: Icons.inventory_2_rounded,
              color: AppColors.primary,
            ),
            _buildCard(
              context,
              title: "Sedang Diproses",
              value: activeBatches.toString(),
              subtitle: "Batch dalam proses produksi",
              icon: Icons.precision_manufacturing_rounded,
              color: Colors.orange,
            ),
            _buildCard(
              context,
              title: "QC Pending",
              value: pendingApprovals.toString(),
              subtitle: "Menunggu pemeriksaan Quality Control",
              icon: Icons.science_rounded,
              color: Colors.amber,
            ),
            _buildCard(
              context,
              title: "Completed",
              value: completedBatches.toString(),
              subtitle: "Batch telah selesai diproduksi",
              icon: Icons.task_alt_rounded,
              color: Colors.green,
            ),
          ],
        );
      },
    );
  }
}