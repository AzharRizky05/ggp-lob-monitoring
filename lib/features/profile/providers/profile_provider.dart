import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();

  DateTime? _joinedAt;
  bool _savingProfile = false;
  bool _changingPassword = false;
  String? _errorMessage;

  DateTime? get joinedAt => _joinedAt;
  bool get savingProfile => _savingProfile;
  bool get changingPassword => _changingPassword;
  String? get errorMessage => _errorMessage;

  Future<void> loadJoinedDate(String userId) async {
    try {
      _joinedAt = await _repository.getJoinedDate(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('ProfileProvider.loadJoinedDate: $e');
    }
  }

  Future<bool> updateProfile({
    required String userId,
    required String fullName,
    String? phone,
  }) async {
    _savingProfile = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateProfile(
        userId: userId,
        fullName: fullName,
        phone: phone,
      );
      return true;
    } catch (e) {
      _errorMessage = _clean(e);
      return false;
    } finally {
      _savingProfile = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    _changingPassword = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.changePassword(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return true;
    } catch (e) {
      _errorMessage = _clean(e);
      return false;
    } finally {
      _changingPassword = false;
      notifyListeners();
    }
  }

  String _clean(Object error) => error.toString().replaceFirst('Exception: ', '');
}