class ProductionHistoryModel {
  final String id;
  final String batchId;
  final String batchCode;
  final DateTime productionDate;
  final String shift;
  final String tank;
  final String operatorName;
  final DateTime completedAt;
  final String approvedBy;
  final String approverName;
  final double finalVolume;
  final String qcResult;
  final String remarks;

  const ProductionHistoryModel({
    required this.id,
    required this.batchId,
    required this.batchCode,
    required this.productionDate,
    required this.shift,
    required this.tank,
    required this.operatorName,
    required this.completedAt,
    required this.approvedBy,
    required this.approverName,
    required this.finalVolume,
    required this.qcResult,
    required this.remarks,
  });

  factory ProductionHistoryModel.fromMap(Map<String, dynamic> map) {
    return ProductionHistoryModel(
      id: (map['id'] ?? '').toString(),

      batchId: (map['batch_id'] ?? '').toString(),

      batchCode: (map['batch_code'] ?? '-').toString(),

      productionDate: DateTime.tryParse(
            map['production_date']?.toString() ?? '',
          ) ??
          DateTime.now(),

      shift: (map['shift'] ?? '-').toString(),

      tank: (map['tank'] ?? '-').toString(),

      operatorName: (map['operator_name'] ?? '-').toString(),

      completedAt: DateTime.tryParse(
            map['completed_at']?.toString() ?? '',
          ) ??
          DateTime.now(),

      approvedBy: (map['approved_by'] ?? '').toString(),

      approverName: (map['approver_name'] ?? '-').toString(),

      finalVolume: (map['final_volume'] as num?)?.toDouble() ?? 0.0,

      qcResult: (map['qc_result'] ?? '-').toString(),

      remarks: (map['remarks'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'batch_id': batchId,
      'completed_at': completedAt.toIso8601String(),
      'approved_by': approvedBy,
      'final_volume': finalVolume,
      'qc_result': qcResult,
      'remarks': remarks,
    };
  }

  ProductionHistoryModel copyWith({
    String? id,
    String? batchId,
    String? batchCode,
    DateTime? productionDate,
    String? shift,
    String? tank,
    String? operatorName,
    DateTime? completedAt,
    String? approvedBy,
    String? approverName,
    double? finalVolume,
    String? qcResult,
    String? remarks,
  }) {
    return ProductionHistoryModel(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      batchCode: batchCode ?? this.batchCode,
      productionDate: productionDate ?? this.productionDate,
      shift: shift ?? this.shift,
      tank: tank ?? this.tank,
      operatorName: operatorName ?? this.operatorName,
      completedAt: completedAt ?? this.completedAt,
      approvedBy: approvedBy ?? this.approvedBy,
      approverName: approverName ?? this.approverName,
      finalVolume: finalVolume ?? this.finalVolume,
      qcResult: qcResult ?? this.qcResult,
      remarks: remarks ?? this.remarks,
    );
  }
}