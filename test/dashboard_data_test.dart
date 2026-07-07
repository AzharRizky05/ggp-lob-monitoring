import 'package:flutter_test/flutter_test.dart';
import 'package:ggp_lob_monitoring/features/dashboard/models/dashboard_data.dart';

void main() {
  group('DashboardData', () {
    test('parses summary, monthly production, and recent batches from maps', () {
      final data = DashboardData.fromMaps(
        summaryMap: {
          'total_batches': 12,
          'active_batches': 4,
          'completed_batches': 7,
          'pending_approvals': 3,
        },
        monthlyMaps: [
          {'month_name': 'Jan', 'total_volume': 10},
          {'month_name': 'Feb', 'total_volume': 14},
        ],
        recentMaps: [
          {
            'batch_code': 'LOB-2026-001',
            'status': 'active',
            'updated_at': '2026-07-02T10:00:00Z',
            'operator_name': 'Budi',
          },
        ],
      );

      expect(data.summary.totalBatches, 12);
      expect(data.summary.activeBatches, 4);
      expect(data.summary.pendingApprovals, 3);
      expect(data.monthlyProduction.first.label, 'Jan');
      expect(data.monthlyProduction.first.value, 10);
      expect(data.recentBatches.first.batchCode, 'LOB-2026-001');
      expect(data.recentBatches.first.operatorName, 'Budi');
    });
  });
}
