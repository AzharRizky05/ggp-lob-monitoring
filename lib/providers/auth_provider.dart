import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/router/route_name.dart';
import '../features/auth/models/user_profile.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _listenToAuthChanges();
    initialize();
  }

  final AuthRepository _repository = AuthRepository();
  StreamSubscription<AuthState>? _authSubscription;

  bool _loading = false;
  bool _isInitializing = false;
  bool _isAuthenticated = false;
  UserProfile? _userProfile;
  String? _errorMessage;

  bool get loading => _loading;
  bool get isInitializing => _isInitializing;
  bool get isAuthenticated => _isAuthenticated;
  UserProfile? get userProfile => _userProfile;
  String? get errorMessage => _errorMessage;

  User? get currentUser => _repository.currentUser;

  String get homeRoute {
    final role = (_userProfile?.roleName ?? '').toLowerCase();

    if (role.contains('supervisor')) {
      return RouteName.approval;
    }

    if (role.contains('qc') || role.contains('quality')) {
      return RouteName.qc;
    }

    if (role.contains('operator') || role.contains('production')) {
      return RouteName.batch;
    }

    return RouteName.dashboard;
  }

  Future<void> initialize() async {
    if (_isInitializing) {
      return;
    }

    _isInitializing = true;
    notifyListeners();

    try {
      await _loadCurrentSession();
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> _loadCurrentSession() async {
    final user = currentUser;

    if (user == null) {
      _userProfile = null;
      _isAuthenticated = false;
      notifyListeners();
      return;
    }

    _userProfile = await _repository.getCurrentUserProfile(authId: user.id);
    _isAuthenticated = true;
    notifyListeners();
  }

  void _listenToAuthChanges() {
    _authSubscription = _repository.authState.listen((_) async {
      await _loadCurrentSession();
    });
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _loading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _repository.signIn(
        email: email,
        password: password,
      );

      if (response.user == null) {
        _errorMessage = 'Email atau password salah.';
        return false;
      }

      await _loadCurrentSession();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.signOut();
    _userProfile = null;
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}