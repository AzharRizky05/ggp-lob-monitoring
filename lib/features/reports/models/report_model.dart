class ReportModel {
  final int totalBatch;
  final int batchAktif;
  final int batchSelesai;
  final int batchTerlambat;
  final int approvalPending;

  const ReportModel({
    required this.totalBatch,
    required this.batchAktif,
    required this.batchSelesai,
    required this.batchTerlambat,
    required this.approvalPending,
  });

  factory ReportModel.empty() {
    return const ReportModel(
      totalBatch: 0,
      batchAktif: 0,
      batchSelesai: 0,
      batchTerlambat: 0,
      approvalPending: 0,
    );
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      totalBatch: json['total_batch'] ?? 0,
      batchAktif: json['batch_aktif'] ?? 0,
      batchSelesai: json['batch_selesai'] ?? 0,
      batchTerlambat: json['batch_terlambat'] ?? 0,
      approvalPending: json['approval_pending'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_batch': totalBatch,
      'batch_aktif': batchAktif,
      'batch_selesai': batchSelesai,
      'batch_terlambat': batchTerlambat,
      'approval_pending': approvalPending,
    };
  }

  ReportModel copyWith({
    int? totalBatch,
    int? batchAktif,
    int? batchSelesai,
    int? batchTerlambat,
    int? approvalPending,
  }) {
    return ReportModel(
      totalBatch: totalBatch ?? this.totalBatch,
      batchAktif: batchAktif ?? this.batchAktif,
      batchSelesai: batchSelesai ?? this.batchSelesai,
      batchTerlambat: batchTerlambat ?? this.batchTerlambat,
      approvalPending: approvalPending ?? this.approvalPending,
    );
  }
}