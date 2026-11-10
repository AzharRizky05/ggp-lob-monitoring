import 'package:flutter/foundation.dart';

import '../../../repositories/company_repository.dart';
import '../models/company_settings.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    loadCompany();
  }

  final CompanyRepository _repository = CompanyRepository();

  bool _loading = false;
  bool _saving = false;
  bool _disposed = false;
  int _requestId = 0;

  String? _errorMessage;
  String? _actionError;
  CompanySettings? _company;

  bool get loading => _loading;
  bool get saving => _saving;
  String? get errorMessage => _errorMessage;
  String? get actionError => _actionError;
  CompanySettings get company => _company ?? const CompanySettings();

  Future<void> loadCompany() async {
    final requestId = ++_requestId;

    _loading = true;
    _errorMessage = null;
    _notify();

    try {
      final result = await _repository.getCompany();
      if (requestId != _requestId) return;
      _company = result;
    } catch (e) {
      if (requestId != _requestId) return;
      _errorMessage = e.toString();
      debugPrint('SettingsProvider.loadCompany: $e');
    } finally {
      if (requestId == _requestId) {
        _loading = false;
        _notify();
      }
    }
  }

  Future<bool> saveCompany({
    required String companyName,
    String? factoryName,
    String? department,
    String? address,
    String? phone,
    String? email,
  }) async {
    _saving = true;
    _actionError = null;
    _notify();

    try {
      await _repository.saveCompany(
        CompanySettings(
          id: _company?.id,
          companyName: companyName,
          factoryName: factoryName,
          department: department,
          address: address,
          phone: phone,
          email: email,
        ),
      );
    } catch (e) {
      _actionError = e.toString().replaceFirst('Exception: ', '');
      _saving = false;
      _notify();
      return false;
    }

    try {
      _company = await _repository.getCompany();
    } catch (e) {
      debugPrint('SettingsProvider reload: $e');
    }

    _saving = false;
    _notify();
    return true;
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