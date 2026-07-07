class HistoryModel {
  final String id;
  final String kodeBatch;
  final String operator;
  final DateTime tanggalProduksi;
  final String tahapanTerakhir;
  final String hasilQc;
  final String status;
  final String catatan;

  const HistoryModel({
    required this.id,
    required this.kodeBatch,
    required this.operator,
    required this.tanggalProduksi,
    required this.tahapanTerakhir,
    required this.hasilQc,
    required this.status,
    required this.catatan,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? '',
      kodeBatch: json['kode_batch'] ?? '',
      operator: json['operator'] ?? '',
      tanggalProduksi:
          DateTime.tryParse(json['tanggal_produksi'] ?? '') ??
              DateTime.now(),
      tahapanTerakhir: json['tahapan_terakhir'] ?? '',
      hasilQc: json['hasil_qc'] ?? '',
      status: json['status'] ?? '',
      catatan: json['catatan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_batch': kodeBatch,
      'operator': operator,
      'tanggal_produksi': tanggalProduksi.toIso8601String(),
      'tahapan_terakhir': tahapanTerakhir,
      'hasil_qc': hasilQc,
      'status': status,
      'catatan': catatan,
    };
  }

  HistoryModel copyWith({
    String? id,
    String? kodeBatch,
    String? operator,
    DateTime? tanggalProduksi,
    String? tahapanTerakhir,
    String? hasilQc,
    String? status,
    String? catatan,
  }) {
    return HistoryModel(
      id: id ?? this.id,
      kodeBatch: kodeBatch ?? this.kodeBatch,
      operator: operator ?? this.operator,
      tanggalProduksi: tanggalProduksi ?? this.tanggalProduksi,
      tahapanTerakhir: tahapanTerakhir ?? this.tahapanTerakhir,
      hasilQc: hasilQc ?? this.hasilQc,
      status: status ?? this.status,
      catatan: catatan ?? this.catatan,
    );
  }
}