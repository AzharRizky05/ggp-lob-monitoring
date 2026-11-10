import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

class OperatorSummaryCards extends StatelessWidget {
  final int totalBatches;
  final int activeBatches;
  final int inReview;
  final int completedBatches;
  final int needsAttention;
  final bool loading;

  const OperatorSummaryCards({
    super.key,
    this.totalBatches = 0,
    this.activeBatches = 0,
    this.inReview = 0,
    this.completedBatches = 0,
    this.needsAttention = 0,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = totalBatches == 0 &&
        activeBatches == 0 &&
        inReview == 0 &&
        completedBatches == 0 &&
        needsAttention == 0;

    if (!loading && isEmpty) {
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

    String value(int number) => loading ? "--" : number.toString();

    final items = [
      _CardData(
        title: "Production Batch Saya",
        value: value(totalBatches),
        subtitle: "Semua batch yang Anda buat",
        icon: Icons.inventory_2_rounded,
        color: AppColors.primary,
      ),
      _CardData(
        title: "Sedang Diproses",
        value: value(activeBatches),
        subtitle: "Batch dalam proses produksi",
        icon: Icons.precision_manufacturing_rounded,
        color: Colors.orange,
      ),
      _CardData(
        title: "Menunggu QC / Approval",
        value: value(inReview),
        subtitle: "Menunggu pemeriksaan atau persetujuan",
        icon: Icons.science_rounded,
        color: Colors.amber.shade700,
      ),
      _CardData(
        title: "Completed",
        value: value(completedBatches),
        subtitle: "Batch telah selesai diproduksi",
        icon: Icons.task_alt_rounded,
        color: Colors.green,
      ),
      _CardData(
        title: "Tidak Lolos",
        value: value(needsAttention),
        subtitle: "QC Failed atau ditolak Supervisor",
        icon: Icons.warning_amber_rounded,
        color: Colors.red,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1100
            ? 5
            : width >= 800
                ? 3
                : width >= 520
                    ? 2
                    : 1;

        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            mainAxisExtent: 140,
          ),
          children: items.map((item) => _SummaryCard(data: item)).toList(),
        );
      },
    );
  }
}

class _CardData {
  const _CardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final _CardData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: data.color.withValues(alpha: 0.15),
              child: Icon(data.icon, color: data.color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.value,
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: data.color,
                    ),
                  ),
                  Text(
                    data.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade500,
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