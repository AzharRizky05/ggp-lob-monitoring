import 'package:flutter/material.dart';

import '../../../repositories/history_repository.dart';
import '../models/history_model.dart';

class HistoryProvider extends ChangeNotifier {
  HistoryProvider() {
    loadData();
  }

  static const String periodAll = 'Semua';
  static const String periodLast7Days = '7 Hari Terakhir';
  static const String periodLast30Days = '30 Hari Terakhir';
  static const String periodThisMonth = 'Bulan Ini';

  static const List<String> periods = [
    periodAll,
    periodLast7Days,
    periodLast30Days,
    periodThisMonth,
  ];

  final HistoryRepository _repository = HistoryRepository();

  bool _loading = false;
  String? _errorMessage;
  List<HistoryModel> _histories = [];
  String _searchQuery = '';
  String _period = periodAll;

  bool get isLoading => _loading;
  String? get errorMessage => _errorMessage;
  String get period => _period;

  List<HistoryModel> get histories {
    final query = _searchQuery.trim().toLowerCase();
    final now = DateTime.now();

    return _histories.where((item) {
      if (!_matchesPeriod(item.completedAt, now)) return false;
      if (query.isEmpty) return true;

      return item.batchCode.toLowerCase().contains(query) ||
          item.operatorName.toLowerCase().contains(query) ||
          item.approvedByName.toLowerCase().contains(query);
    }).toList();
  }

  bool _matchesPeriod(DateTime? date, DateTime now) {
    if (_period == periodAll) return true;
    if (date == null) return false;

    switch (_period) {
      case periodLast7Days:
        return date.isAfter(now.subtract(const Duration(days: 7)));
      case periodLast30Days:
        return date.isAfter(now.subtract(const Duration(days: 30)));
      case periodThisMonth:
        return date.year == now.year && date.month == now.month;
      default:
        return true;
    }
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

  void setPeriod(String value) {
    _period = value;
    notifyListeners();
  }
}