import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ApprovalPendingCard extends StatelessWidget {
  const ApprovalPendingCard({
    super.key,
    this.pendingCount = 0,
    this.loading = false,
  });

  final int pendingCount;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final approvals = [
      (
        batch: "Pending Approval",
        operator: loading ? "Memuat" : "Total: $pendingCount",
        tahap: loading ? "Sedang memuat data" : "Menunggu supervisor",
      ),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.approval_rounded,
                  color: AppColors.primary,
                ),
                SizedBox(width: 8),
                Text(
                  "Approval Supervisor",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            ...approvals.map(
              (item) => Card(
                elevation: 0,
                color: Colors.grey.shade50,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.batch,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text("Operator : ${item.operator}"),
                      Text("Tahapan : ${item.tahap}"),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              icon: const Icon(Icons.check),
                              label: const Text("Approve"),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              icon: const Icon(Icons.close),
                              label: const Text("Reject"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}