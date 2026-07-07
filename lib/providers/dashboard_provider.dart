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

  bool get loading => _loading;
  DashboardData? get data => _data;
  String? get errorMessage => _errorMessage;

  Future<void> loadDashboardData() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _data = await _repository.getDashboardData();
    } catch (e) {
      _errorMessage = e.toString();
      _data = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
