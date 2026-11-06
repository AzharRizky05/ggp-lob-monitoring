class ApprovalHistoryModel {
  final String id;
  final String batchId;
  final String batchCode;
  final DateTime productionDate;
  final String operatorName;
  final String supervisorId;
  final String supervisorName;
  final String approvalStatus;
  final String comments;
  final DateTime? approvedAt;

  const ApprovalHistoryModel({
    required this.id,
    required this.batchId,
    required this.batchCode,
    required this.productionDate,
    required this.operatorName,
    required this.supervisorId,
    required this.supervisorName,
    required this.approvalStatus,
    required this.comments,
    required this.approvedAt,
  });

  factory ApprovalHistoryModel.fromMap(Map<String, dynamic> map) {
    return ApprovalHistoryModel(
      id: (map['id'] ?? '').toString(),
      batchId: (map['batch_id'] ?? '').toString(),
      batchCode: (map['batch_code'] ?? '-').toString(),
      productionDate: DateTime.tryParse(
            map['production_date']?.toString() ?? '',
          ) ??
          DateTime.now(),
      operatorName: (map['operator_name'] ?? '-').toString(),
      supervisorId: (map['supervisor_id'] ?? '').toString(),
      supervisorName: (map['supervisor_name'] ?? '-').toString(),
      approvalStatus: (map['approval_status'] ?? 'Waiting').toString(),
      comments: (map['comments'] ?? '').toString(),
      approvedAt: map['approved_at'] != null
          ? DateTime.tryParse(map['approved_at'].toString())
          : null,
    );
  }
}