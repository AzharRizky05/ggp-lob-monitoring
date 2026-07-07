import 'package:flutter/material.dart';

import '../features/batch/models/batch_model.dart';
import '../repositories/batch_repository.dart';

class BatchProvider extends ChangeNotifier {
  BatchProvider() {
    loadBatches();
  }

  final BatchRepository _repository = BatchRepository();

  bool _loading = false;
  List<BatchModel> _batches = [];
  String? _errorMessage;

  bool get loading => _loading;

  List<BatchModel> get batches => _batches;

  String? get errorMessage => _errorMessage;

  Future<void> loadBatches() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _batches = await _repository.getBatches();
      
      // Tambahan Debugging
      debugPrint("============== BATCH ==============");
      for (final batch in _batches) {
        debugPrint(
            "${batch.batchCode} | ${batch.status} | ${batch.operatorName}");
      }
      debugPrint("Total : ${_batches.length}");
      
    } catch (e) {
      _errorMessage = e.toString();
      _batches = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> createBatch(BatchModel batch) async {
    try {
      _loading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.createBatch(batch);

      _batches = await _repository.getBatches();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> updateBatch(BatchModel batch) async {
    try {
      _loading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.updateBatch(batch);

      _batches = await _repository.getBatches();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteBatch(String id) async {
    try {
      _loading = true;
      _errorMessage = null;
      notifyListeners();

      await _repository.deleteBatch(id);

      _batches = await _repository.getBatches();

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
    await loadBatches();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}