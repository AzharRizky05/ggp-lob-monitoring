import 'package:flutter/material.dart';

import '../features/monitoring/models/monitoring_model.dart';
import '../repositories/monitoring_repository.dart';

class MonitoringProvider extends ChangeNotifier {
  MonitoringProvider() {
    loadMonitoring();
  }

  final MonitoringRepository _repository = MonitoringRepository();

  bool _loading = false;
  List<MonitoringModel> _monitoring = [];
  String? _errorMessage;

  bool get loading => _loading;

  List<MonitoringModel> get monitoring => _monitoring;

  String? get errorMessage => _errorMessage;

  Future<void> loadMonitoring() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _monitoring = await _repository.getMonitoring();
    } catch (e) {
      _monitoring = [];
      _errorMessage = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> createMonitoring(
    MonitoringModel monitoring,
  ) async {
    try {
      _loading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.createMonitoring(
        monitoring,
      );

      _monitoring = await _repository.getMonitoring();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }


  Future<bool> updateMonitoring(
    MonitoringModel monitoring,
  ) async {
    try {
      _loading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.updateMonitoring(
        monitoring,
      );

      _monitoring = await _repository.getMonitoring();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteMonitoring(
    String id,
  ) async {
    try {
      _loading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.deleteMonitoring(id);

      _monitoring = await _repository.getMonitoring();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadMonitoring();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}