const List<String> reportMonthNames = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

const List<String> reportMonthShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

/// Contoh: 2480 -> "2.480 L"
String formatVolumeLiter(double value) {
  final whole = value == value.roundToDouble();
  final text = whole ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
  final parts = text.split('.');
  final integerPart = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
  return parts.length > 1 ? '$integerPart,${parts[1]} L' : '$integerPart L';
}

/// Pilihan filter status batch pada halaman laporan.
class ReportStatusOption {
  const ReportStatusOption(this.label, this.statuses);

  final String label;

  /// null berarti semua status.
  final Set<String>? statuses;

  static const List<ReportStatusOption> options = [
    ReportStatusOption('Semua', null),
    ReportStatusOption('Sedang Produksi', {
      'Draft',
      'Preparation',
      'Mixing',
      'Fermentation',
      'Filtering',
      'Packaging',
    }),
    ReportStatusOption('Menunggu QC', {'QC Pending'}),
    ReportStatusOption('QC Failed', {'QC Failed'}),
    ReportStatusOption('Menunggu Approval', {'Waiting Approval', 'QC Passed'}),
    ReportStatusOption('Selesai', {'Completed', 'Approved'}),
    ReportStatusOption('Ditolak', {'Rejected'}),
  ];

  static ReportStatusOption byLabel(String label) {
    return options.firstWhere(
      (option) => option.label == label,
      orElse: () => options.first,
    );
  }
}

/// Satu baris batch pada laporan.
class ReportRow {
  const ReportRow({
    required this.batchId,
    required this.batchCode,
    required this.operatorName,
    required this.productionDate,
    required this.shift,
    required this.tank,
    required this.volume,
    required this.qcResult,
    required this.status,
    required this.supervisorName,
  });

  final String batchId;
  final String batchCode;
  final String operatorName;
  final DateTime? productionDate;
  final String shift;
  final String tank;
  final double volume;
  final String qcResult;
  final String status;
  final String supervisorName;

  bool get isCompleted => status == 'Completed' || status == 'Approved';
  bool get isRejected => status == 'Rejected';

  String get productionDateLabel {
    final date = productionDate;
    if (date == null) return '-';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String get volumeLabel => formatVolumeLiter(volume);
}

/// Jumlah batch disetujui dan ditolak pada satu bulan.
class MonthlyApprovalPoint {
  const MonthlyApprovalPoint({
    required this.label,
    required this.approved,
    required this.rejected,
  });

  final String label;
  final int approved;
  final int rejected;
}

class ReportSummary {
  const ReportSummary({
    required this.total,
    required this.completed,
    required this.rejected,
    required this.qcPassRate,
    required this.totalVolume,
  });

  const ReportSummary.empty()
      : total = 0,
        completed = 0,
        rejected = 0,
        qcPassRate = null,
        totalVolume = 0;

  final int total;
  final int completed;
  final int rejected;

  /// 0.0 sampai 1.0, null jika belum ada hasil QC.
  final double? qcPassRate;

  final double totalVolume;
}