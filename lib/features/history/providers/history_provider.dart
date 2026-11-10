import 'package:flutter/material.dart';

import '../../../repositories/history_repository.dart';
import '../models/history_model.dart';

class HistoryProvider extends ChangeNotifier {
  HistoryProvider() {
    loadData();
  }

  final HistoryRepository _repository = HistoryRepository();

  bool _loading = false;
  String? _errorMessage;
  List<HistoryModel> _histories = [];
  String _searchQuery = '';

  /// Rentang tanggal selesai. null berarti semua tanggal.
  DateTimeRange? _range;

  bool get isLoading => _loading;
  String? get errorMessage => _errorMessage;
  DateTimeRange? get range => _range;

  List<HistoryModel> get histories {
    final query = _searchQuery.trim().toLowerCase();

    return _histories.where((item) {
      if (!_matchesRange(item.completedAt)) return false;
      if (query.isEmpty) return true;

      return item.batchCode.toLowerCase().contains(query) ||
          item.operatorName.toLowerCase().contains(query) ||
          item.approvedByName.toLowerCase().contains(query);
    }).toList();
  }

  bool _matchesRange(DateTime? date) {
    final range = _range;
    if (range == null) return true;
    if (date == null) return false;

    // Dibandingkan per hari penuh, jadi tanggal akhir ikut dihitung sampai 23:59.
    final start = DateTime(range.start.year, range.start.month, range.start.day);
    final endExclusive = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
    ).add(const Duration(days: 1));

    return !date.isBefore(start) && date.isBefore(endExclusive);
  }

  Future<void> loadData() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _histories = await _repository.getHistories();
    } catch (e) {
      _histories = [];
      _errorMessage = e.toString();
      debugPrint('HistoryProvider.loadData: $e');
    }

    _loading = false;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setRange(DateTimeRange? value) {
    _range = value;
    notifyListeners();
  }

  void clearRange() => setRange(null);
}