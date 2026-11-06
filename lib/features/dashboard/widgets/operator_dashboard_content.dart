import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dashboard_data.dart';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// =========================
          /// HEADER
          /// =========================
          Text(
            "Selamat Datang 👋",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Dashboard Operator Produksi",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Kelola batch produksi, lakukan monitoring proses, dan pastikan seluruh tahapan produksi berjalan sesuai SOP.",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 30),

          /// =========================
          /// SUMMARY
          /// =========================
          Text(
            "Ringkasan Produksi",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          OperatorSummaryCards(
            totalBatches: data?.summary.totalBatches ?? 0,
            activeBatches: data?.summary.activeBatches ?? 0,
            completedBatches: data?.summary.completedBatches ?? 0,
            pendingApprovals: data?.summary.waitingQc ?? 0,
            loading: loading,
          ),

          const SizedBox(height: 30),

          /// =========================
          /// PETUNJUK OPERATOR
          /// =========================
          Text(
            "Alur Kerja Operator",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          LayoutBuilder(
            builder: (context, constraints) {

              final mobile = constraints.maxWidth < 900;

              return GridView.count(
                crossAxisCount: mobile ? 1 : 2,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                childAspectRatio: mobile ? 3.2 : 2.7,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: [

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

                ],
              );
            },
          ),

          const SizedBox(height: 32),

          /// =========================
          /// RECENT ACTIVITY
          /// =========================
          Text(
            "Batch Terbaru",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 16),

          OperatorRecentActivity(
            items: data?.recentBatches ?? const [],
            loading: loading,
          ),

          const SizedBox(height: 24),
        ],
      ),
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
              child: Icon(
                icon,
                color: color,
              ),
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