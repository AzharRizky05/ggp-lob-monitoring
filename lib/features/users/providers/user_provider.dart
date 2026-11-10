import 'package:flutter/foundation.dart';

import '../../../repositories/user_repository.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    loadData();
  }

  static const String allLabel = 'Semua';
  static const List<String> statusOptions = [allLabel, 'Aktif', 'Nonaktif'];

  final UserRepository _repository = UserRepository();

  bool _loading = false;
  bool _saving = false;
  bool _disposed = false;
  int _requestId = 0;

  String? _errorMessage;
  String? _actionError;

  List<UserModel> _users = [];
  List<RoleOption> _roles = [];

  String _searchQuery = '';
  String _roleFilter = allLabel;
  String _statusFilter = allLabel;

  bool get loading => _loading;
  bool get saving => _saving;
  String? get errorMessage => _errorMessage;
  String? get actionError => _actionError;
  List<RoleOption> get roles => List.unmodifiable(_roles);
  int get totalUsers => _users.length;
  String get roleFilter => _roleFilter;
  String get statusFilter => _statusFilter;

  List<UserModel> get users {
    final query = _searchQuery.trim().toLowerCase();

    return _users.where((user) {
      if (_roleFilter != allLabel && user.roleName != _roleFilter) return false;
      if (_statusFilter != allLabel && user.statusLabel != _statusFilter) {
        return false;
      }
      if (query.isEmpty) return true;

      return user.fullName.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> loadData() async {
    final requestId = ++_requestId;

    _loading = true;
    _errorMessage = null;
    _notify();

    try {
      final users = await _repository.getUsers();
      final roles = await _repository.getRoles();
      if (requestId != _requestId) return;

      _users = users;
      _roles = roles;
    } catch (e) {
      if (requestId != _requestId) return;
      _users = [];
      _errorMessage = e.toString();
      debugPrint('UserProvider.loadData: $e');
    } finally {
      if (requestId == _requestId) {
        _loading = false;
        _notify();
      }
    }
  }

  Future<bool> createUser({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    required int roleId,
    required bool isActive,
  }) {
    return _runAction(
      () => _repository.createUser(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        roleId: roleId,
        isActive: isActive,
      ),
    );
  }

  Future<bool> updateUser({
    required String id,
    required String fullName,
    String? phone,
    required int roleId,
    required bool isActive,
  }) {
    return _runAction(
      () => _repository.updateUser(
        id: id,
        fullName: fullName,
        phone: phone,
        roleId: roleId,
        isActive: isActive,
      ),
    );
  }

  Future<bool> toggleActive(UserModel user) {
    return _runAction(
      () => _repository.updateUser(
        id: user.id,
        fullName: user.fullName,
        phone: user.phone,
        roleId: user.roleId,
        isActive: !user.isActive,
      ),
    );
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    _notify();
  }

  void setRoleFilter(String value) {
    _roleFilter = value;
    _notify();
  }

  void setStatusFilter(String value) {
    _statusFilter = value;
    _notify();
  }

  Future<bool> _runAction(Future<void> Function() action) async {
    _saving = true;
    _actionError = null;
    _notify();

    try {
      await action();
    } catch (e) {
      _actionError = e.toString().replaceFirst('Exception: ', '');
      _saving = false;
      _notify();
      return false;
    }

    try {
      _users = await _repository.getUsers();
    } catch (e) {
      debugPrint('UserProvider reload: $e');
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