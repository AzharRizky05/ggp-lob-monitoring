import 'package:flutter/material.dart';

import '../features/quality_control/models/qc_model.dart';
import '../repositories/qc_repository.dart';

class QcProvider extends ChangeNotifier {
  QcProvider() {
    loadQualityControls();
  }

  final QcRepository _repository = QcRepository();

  bool _loading = false;
  List<QcModel> _qualityControls = [];
  String? _errorMessage;

  bool get loading => _loading;

  List<QcModel> get qualityControls => _qualityControls;

  String? get errorMessage => _errorMessage;

  Future<void> loadQualityControls() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _qualityControls = await _repository.getQualityControls();
    } catch (e) {
      _qualityControls = [];
      _errorMessage = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> createQc(
    QcModel qc,
  ) async {
    debugPrint("========== PROVIDER CREATE QC ==========");

    if (_loading) {
      debugPrint("SUDAH LOADING -> BATAL");
      return false;
    }

    try {
      _loading = true;
      _errorMessage = null;
      notifyListeners();

      debugPrint("MEMANGGIL REPOSITORY");

      await _repository.createQc(qc);

      debugPrint("REPOSITORY SELESAI");

      _qualityControls = await _repository.getQualityControls();

      debugPrint("LOAD DATA QC SELESAI");

      return true;
    } catch (e) {
      debugPrint("PROVIDER ERROR");
      debugPrint(e.toString());

      _errorMessage = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> updateQc(
    QcModel qc,
  ) async {
    try {
      _loading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.updateQc(qc);

      _qualityControls = await _repository.getQualityControls();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteQc(
    String id,
  ) async {
    try {
      _loading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.deleteQc(id);

      _qualityControls = await _repository.getQualityControls();

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
    await loadQualityControls();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}