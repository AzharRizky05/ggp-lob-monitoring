import 'package:flutter/foundation.dart';

import '../../../repositories/report_repository.dart';
import '../models/report_model.dart';

class ReportProvider extends ChangeNotifier {
  ReportProvider() {
    loadData();
  }

  final ReportRepository _repository = ReportRepository();

  bool _loading = false;
  bool _disposed = false;
  String? _errorMessage;
  int _requestId = 0;

  int _year = DateTime.now().year;
  int _month = 0; // 0 = semua bulan
  String _statusLabel = ReportStatusOption.options.first.label;

  List<ReportRow> _yearRows = [];

  bool get loading => _loading;
  String? get errorMessage => _errorMessage;
  int get year => _year;
  int get month => _month;
  String get statusLabel => _statusLabel;

  List<int> get years {
    final now = DateTime.now().year;
    return [now - 2, now - 1, now];
  }

  /// Baris yang sudah disaring bulan dan status (untuk tabel, ringkasan, export).
  List<ReportRow> get rows {
    final option = ReportStatusOption.byLabel(_statusLabel);

    return _yearRows.where((row) {
      if (_month != 0 && row.productionDate?.month != _month) return false;
      final statuses = option.statuses;
      if (statuses != null && !statuses.contains(row.status)) return false;
      return true;
    }).toList();
  }

  ReportSummary get summary {
    final data = rows;
    if (data.isEmpty) return const ReportSummary.empty();

    int completed = 0;
    int rejected = 0;
    int qcPassed = 0;
    int qcFailed = 0;
    double volume = 0;

    for (final row in data) {
      if (row.isCompleted) {
        completed++;
        volume += row.volume;
      }
      if (row.isRejected) rejected++;
      if (row.qcResult == 'Passed') {
        qcPassed++;
      } else if (row.qcResult == 'Failed') {
        qcFailed++;
      }
    }

    final qcTotal = qcPassed + qcFailed;

    return ReportSummary(
      total: data.length,
      completed: completed,
      rejected: rejected,
      qcPassRate: qcTotal == 0 ? null : qcPassed / qcTotal,
      totalVolume: volume,
    );
  }

  /// Grafik memakai seluruh batch pada tahun terpilih,
  /// tidak terpengaruh filter bulan dan status.
  List<MonthlyApprovalPoint> get monthly {
    return List.generate(12, (index) {
      final month = index + 1;
      int approved = 0;
      int rejected = 0;

      for (final row in _yearRows) {
        if (row.productionDate?.month != month) continue;
        if (row.isCompleted) approved++;
        if (row.isRejected) rejected++;
      }

      return MonthlyApprovalPoint(
        label: reportMonthShort[index],
        approved: approved,
        rejected: rejected,
      );
    });
  }

  String get exportFileName {
    final monthPart = _month == 0 ? '' : '-${_month.toString().padLeft(2, '0')}';
    return 'laporan-produksi-$_year$monthPart.csv';
  }

  Future<void> loadData() async {
    final requestId = ++_requestId;

    _loading = true;
    _errorMessage = null;
    _notify();

    try {
      final result = await _repository.getBatchesByYear(_year);
      if (requestId != _requestId) return;
      _yearRows = result;
    } catch (e) {
      if (requestId != _requestId) return;
      _yearRows = [];
      _errorMessage = e.toString();
      debugPrint('ReportProvider.loadData: $e');
    } finally {
      if (requestId == _requestId) {
        _loading = false;
        _notify();
      }
    }
  }

  void setYear(int value) {
    if (value == _year) return;
    _year = value;
    loadData();
  }

  void setMonth(int value) {
    _month = value;
    _notify();
  }

  void setStatusLabel(String value) {
    _statusLabel = value;
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}