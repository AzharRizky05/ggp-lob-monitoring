import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dashboard_data.dart';
import 'dashboard_header.dart';
import 'operator_recent_activity.dart';
import 'operator_summary_cards.dart';

class OperatorDashboardContent extends StatelessWidget {
  final DashboardData? data;
  final bool loading;

  const OperatorDashboardContent({
    super.key,
    this.data,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final summary = data?.summary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER (sapaan sesuai jam, sama dengan role lain)
          const DashboardHeader(),

          const SizedBox(height: 30),

          /// SUMMARY
          Text(
            "Ringkasan Produksi",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          OperatorSummaryCards(
            totalBatches: summary?.totalBatches ?? 0,
            activeBatches: summary?.activeBatches ?? 0,
            inReview:
                (summary?.waitingQc ?? 0) + (summary?.pendingApprovals ?? 0),
            completedBatches: summary?.completedBatches ?? 0,
            needsAttention:
                (summary?.qcFailedBatches ?? 0) + (summary?.rejectedBatches ?? 0),
            loading: loading,
          ),

          const SizedBox(height: 30),

          /// PETUNJUK OPERATOR
          Text(
            "Alur Kerja Operator",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          _buildGuide(),

          const SizedBox(height: 32),

          /// BATCH TERBARU
          OperatorRecentActivity(
            items: data?.recentBatches ?? const [],
            loading: loading,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildGuide() {
    final cards = [
      _guideCard(
        color: Colors.blue,
        icon: Icons.inventory_2_rounded,
        title: "1. Production Batch",
        subtitle:
            "Pilih atau buat Batch Produksi baru sebelum proses produksi dimulai.",
      ),
      _guideCard(
        color: Colors.green,
        icon: Icons.monitor_heart_rounded,
        title: "2. Monitoring Produksi",
        subtitle:
            "Input Temperatur, pH, Brix, Volume, Flow Rate, Mixing Time, dan Fermentation Time secara berkala.",
      ),
      _guideCard(
        color: Colors.orange,
        icon: Icons.sync_alt_rounded,
        title: "3. Status Otomatis",
        subtitle:
            "Setiap monitoring yang disimpan otomatis memajukan status batch: Preparation, Mixing, Fermentation, Filtering, hingga Packaging.",
      ),
      _guideCard(
        color: Colors.purple,
        icon: Icons.task_alt_rounded,
        title: "4. Selesai Produksi",
        subtitle:
            "Setelah Packaging selesai, batch akan diteruskan ke Quality Control.",
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

        if (!wide) {
          return Column(
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                cards[i],
                if (i < cards.length - 1) const SizedBox(height: 16),
              ],
            ],
          );
        }

        // Dua kolom, tinggi tiap pasangan kartu mengikuti isinya.
        return Column(
          children: [
            for (int i = 0; i < cards.length; i += 2) ...[
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: cards[i]),
                    const SizedBox(width: 16),
                    Expanded(
                      child: i + 1 < cards.length
                          ? cards[i + 1]
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
              if (i + 2 < cards.length) const SizedBox(height: 16),
            ],
          ],
        );
      },
    );
  }

  Widget _guideCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withValues(alpha: 0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}