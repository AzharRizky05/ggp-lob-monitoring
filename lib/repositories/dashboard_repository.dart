import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../features/dashboard/models/dashboard_data.dart';

class DashboardRepository {
  DashboardRepository();

  final SupabaseClient _client = SupabaseService.client;

  static const List<String> _activeStatuses = [
    'Preparation',
    'Mixing',
    'Fermentation',
    'Filtering',
    'Packaging',
  ];

  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  /// [operatorId] diisi untuk role Operator, supaya hanya batch miliknya yang dihitung.
  Future<DashboardData> getDashboardData({String? operatorId}) async {
    var query = _client.from('production_batches').select('''
      id, batch_code, status, current_volume, production_date, updated_at,
      users!production_batches_operator_id_fkey(full_name)
    ''');

    if (operatorId != null) {
      query = query.eq('operator_id', operatorId);
    }

    final response = await query.order('updated_at', ascending: false);
    final batches = (response as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    int countStatus(bool Function(String status) test) => batches
        .where((b) => test((b['status'] ?? '').toString()))
        .length;

    // Operator tidak membutuhkan angka QC, jadi query ini dilewati.
    final qc = operatorId == null
        ? await _getQcCounts()
        : const <String, int>{};

    final summary = DashboardSummary(
      totalBatches: batches.length,
      activeBatches: countStatus(_activeStatuses.contains),
      completedBatches: countStatus((s) => s == 'Completed'),
      pendingApprovals: countStatus((s) => s == 'Waiting Approval'),
      waitingQc: countStatus((s) => s == 'QC Pending'),
      rejectedBatches: countStatus((s) => s == 'Rejected'),
      qcFailedBatches: countStatus((s) => s == 'QC Failed'),
      qcPassed: qc['Passed'] ?? 0,
      qcFailed: qc['Failed'] ?? 0,
    );

    final recent = batches.take(5).map((batch) {
      final user = batch['users'];
      return RecentBatchItem(
        batchCode: (batch['batch_code'] ?? '').toString(),
        status: (batch['status'] ?? '').toString(),
        updatedAt: (batch['updated_at'] ?? '').toString(),
        operatorName: user is Map ? (user['full_name'] ?? '').toString() : '',
      );
    }).toList();

    return DashboardData(
      summary: summary,
      monthlyProduction: _buildMonthlyProduction(batches),
      recentBatches: recent,
    );
  }

  Future<Map<String, int>> _getQcCounts() async {
    try {
      final rows = await _client.from('quality_controls').select('result');
      final counts = <String, int>{'Passed': 0, 'Failed': 0};

      for (final row in rows as List) {
        final result = (row['result'] ?? '').toString();
        if (counts.containsKey(result)) {
          counts[result] = counts[result]! + 1;
        }
      }
      return counts;
    } catch (e) {
      debugPrint('DashboardRepository._getQcCounts: $e');
      return const {'Passed': 0, 'Failed': 0};
    }
  }

  /// Total volume batch yang sudah Completed, per bulan, untuk 6 bulan terakhir.
  List<MonthlyProductionPoint> _buildMonthlyProduction(
    List<Map<String, dynamic>> batches,
  ) {
    final now = DateTime.now();
    final months = List.generate(
      6,
      (index) => DateTime(now.year, now.month - (5 - index), 1),
    );

    final totals = <int, double>{
      for (final m in months) m.year * 100 + m.month: 0.0,
    };

    for (final batch in batches) {
      if (batch['status'] != 'Completed') continue;

      final date =
          DateTime.tryParse((batch['production_date'] ?? '').toString());
      if (date == null) continue;

      final key = date.year * 100 + date.month;
      if (!totals.containsKey(key)) continue;

      totals[key] = totals[key]! +
          ((batch['current_volume'] as num?)?.toDouble() ?? 0);
    }

    return months
        .map(
          (m) => MonthlyProductionPoint(
            label: _monthNames[m.month - 1],
            value: totals[m.year * 100 + m.month] ?? 0,
          ),
        )
        .toList();
  }
}