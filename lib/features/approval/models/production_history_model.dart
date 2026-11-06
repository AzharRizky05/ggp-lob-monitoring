class ProductionHistoryModel {
  final String id;
  final String batchId;
  final String batchCode;
  final String operatorName;
  final DateTime? completedAt;
  final String approvedById;
  final String approvedByName;
  final double finalVolume;
  final String qcResult;
  final String remarks;

  const ProductionHistoryModel({
    required this.id,
    required this.batchId,
    required this.batchCode,
    required this.operatorName,
    required this.completedAt,
    required this.approvedById,
    required this.approvedByName,
    required this.finalVolume,
    required this.qcResult,
    required this.remarks,
  });

  factory ProductionHistoryModel.fromMap(Map<String, dynamic> map) {
    return ProductionHistoryModel(
      id: (map['id'] ?? '').toString(),
      batchId: (map['batch_id'] ?? '').toString(),
      batchCode: (map['batch_code'] ?? '-').toString(),
      operatorName: (map['operator_name'] ?? '-').toString(),
      completedAt: map['completed_at'] != null
          ? DateTime.tryParse(map['completed_at'].toString())
          : null,
      approvedById: (map['approved_by'] ?? '').toString(),
      approvedByName: (map['approved_by_name'] ?? '-').toString(),
      finalVolume: (map['final_volume'] as num?)?.toDouble() ?? 0,
      qcResult: (map['qc_result'] ?? '-').toString(),
      remarks: (map['remarks'] ?? '').toString(),
    );
  }
}