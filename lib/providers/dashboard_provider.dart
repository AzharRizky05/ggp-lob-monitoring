import 'package:flutter/material.dart';

import '../features/dashboard/models/dashboard_data.dart';
import '../repositories/dashboard_repository.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider() {
    loadDashboardData();
  }

  final DashboardRepository _repository = DashboardRepository();

  bool _loading = false;
  DashboardData? _data;
  String? _errorMessage;
  int _requestId = 0;

  bool get loading => _loading;
  DashboardData? get data => _data;
  String? get errorMessage => _errorMessage;

  /// [operatorId] diisi untuk role Operator.
  Future<void> loadDashboardData({String? operatorId}) async {
    final requestId = ++_requestId;

    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result =
          await _repository.getDashboardData(operatorId: operatorId);
      if (requestId != _requestId) return;
      _data = result;
    } catch (e) {
      if (requestId != _requestId) return;
      _errorMessage = e.toString();
      _data = null;
      debugPrint('DashboardProvider.loadDashboardData: $e');
    } finally {
      if (requestId == _requestId) {
        _loading = false;
        notifyListeners();
      }
    }
  }
}