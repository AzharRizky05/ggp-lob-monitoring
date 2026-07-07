class ApprovalModel {
  final String id;
  final String batchId;
  final String batchCode;
  final DateTime productionDate;
  final String operatorName;
  final double ph;
  final String qcResult;
  final String status;
  final String qcNotes;

  const ApprovalModel({
    required this.id,
    required this.batchId,
    required this.batchCode,
    required this.productionDate,
    required this.operatorName,
    required this.ph,
    required this.qcResult,
    required this.status,
    required this.qcNotes,
  });

  factory ApprovalModel.fromMap(
    Map<String, dynamic> map,
  ) {
    final user = map['users'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(map['users'])
        : <String, dynamic>{};

    final qc = map['quality_controls'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(map['quality_controls'])
        : <String, dynamic>{};

    return ApprovalModel(
      id: (qc['id'] ?? '').toString(),
      batchId: (map['id'] ?? '').toString(),
      batchCode: (map['batch_code'] ?? '').toString(),
      productionDate: DateTime.tryParse(
            map['production_date']?.toString() ?? '',
          ) ??
          DateTime.now(),
      operatorName: (user['full_name'] ?? '-').toString(),
      ph: (qc['ph'] as num?)?.toDouble() ?? 0.0,
      qcResult: (qc['result'] ?? '-').toString(),
      status: (map['status'] ?? '-').toString(),
      qcNotes: (qc['notes'] ?? '-').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'batch_id': batchId,
      'batch_code': batchCode,
      'production_date': productionDate.toIso8601String(),
      'operator_name': operatorName,
      'ph': ph,
      'qc_result': qcResult,
      'status': status,
      'qc_notes': qcNotes,
    };
  }

  ApprovalModel copyWith({
    String? id,
    String? batchId,
    String? batchCode,
    DateTime? productionDate,
    String? operatorName,
    double? ph,
    String? qcResult,
    String? status,
    String? qcNotes,
  }) {
    return ApprovalModel(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      batchCode: batchCode ?? this.batchCode,
      productionDate: productionDate ?? this.productionDate,
      operatorName: operatorName ?? this.operatorName,
      ph: ph ?? this.ph,
      qcResult: qcResult ?? this.qcResult,
      status: status ?? this.status,
      qcNotes: qcNotes ?? this.qcNotes,
    );
  }
}