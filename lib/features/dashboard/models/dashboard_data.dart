class DashboardSummary {
  const DashboardSummary({
    required this.totalBatches,
    required this.activeBatches,
    required this.completedBatches,
    required this.pendingApprovals,
  });

  final int totalBatches;
  final int activeBatches;
  final int completedBatches;
  final int pendingApprovals;

  factory DashboardSummary.fromMap(Map<String, dynamic> map) {
    return DashboardSummary(
      totalBatches: _toInt(map['total_batches']),
      activeBatches: _toInt(map['active_batches']),
      completedBatches: _toInt(map['completed_batches']),
      pendingApprovals: _toInt(map['pending_approvals']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class MonthlyProductionPoint {
  const MonthlyProductionPoint({
    required this.label,
    required this.value,
  });

  final String label;
  final double value;

  factory MonthlyProductionPoint.fromMap(Map<String, dynamic> map) {
    return MonthlyProductionPoint(
      label: (map['month_name'] ?? '').toString(),
      value: (map['total_volume'] is num)
          ? (map['total_volume'] as num).toDouble()
          : 0,
    );
  }
}

class RecentBatchItem {
  const RecentBatchItem({
    required this.batchCode,
    required this.status,
    required this.updatedAt,
    required this.operatorName,
  });

  final String batchCode;
  final String status;
  final String updatedAt;
  final String operatorName;

  factory RecentBatchItem.fromMap(Map<String, dynamic> map) {
    return RecentBatchItem(
      batchCode: (map['batch_code'] ?? '').toString(),
      status: (map['status'] ?? '').toString(),
      updatedAt: (map['updated_at'] ?? '').toString(),
      operatorName: (map['operator_name'] ?? '').toString(),
    );
  }
}

class DashboardData {
  const DashboardData({
    required this.summary,
    required this.monthlyProduction,
    required this.recentBatches,
  });

  final DashboardSummary summary;
  final List<MonthlyProductionPoint> monthlyProduction;
  final List<RecentBatchItem> recentBatches;

  factory DashboardData.fromMaps({
    required Map<String, dynamic> summaryMap,
    required List<Map<String, dynamic>> monthlyMaps,
    required List<Map<String, dynamic>> recentMaps,
  }) {
    return DashboardData(
      summary: DashboardSummary.fromMap(summaryMap),
      monthlyProduction: monthlyMaps
          .map(MonthlyProductionPoint.fromMap)
          .toList(),
      recentBatches: recentMaps.map(RecentBatchItem.fromMap).toList(),
    );
  }
}
