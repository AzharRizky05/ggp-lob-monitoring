class UserModel {
  const UserModel({
    required this.id,
    required this.authId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.roleId,
    required this.roleName,
    required this.isActive,
    required this.createdAt,
  });

  final String id;
  final String authId;
  final String fullName;
  final String email;
  final String? phone;
  final int roleId;
  final String roleName;
  final bool isActive;
  final DateTime? createdAt;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final role = map['roles'];

    return UserModel(
      id: (map['id'] ?? '').toString(),
      authId: (map['auth_id'] ?? '').toString(),
      fullName: (map['full_name'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      phone: map['phone']?.toString(),
      roleId: (map['role_id'] as num?)?.toInt() ?? 0,
      roleName: role is Map ? (role['role_name'] ?? '-').toString() : '-',
      isActive: map['is_active'] == true,
      createdAt:
          DateTime.tryParse((map['created_at'] ?? '').toString())?.toLocal(),
    );
  }

  String get statusLabel => isActive ? 'Aktif' : 'Nonaktif';

  String get phoneLabel {
    final value = phone?.trim() ?? '';
    return value.isEmpty ? '-' : value;
  }

  String get createdLabel {
    final date = createdAt;
    if (date == null) return '-';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

/// Pilihan role untuk dropdown (dari tabel roles).
class RoleOption {
  const RoleOption({required this.id, required this.name});

  final int id;
  final String name;
}