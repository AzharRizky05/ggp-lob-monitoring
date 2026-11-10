class UserProfile {
  final String id;
  final String authId;
  final String fullName;
  final String email;
  final String? phone;
  final int roleId;
  final String roleName;
  final bool isActive;
  final DateTime? createdAt;

  const UserProfile({
    required this.id,
    required this.authId,
    required this.fullName,
    required this.email,
    this.phone,
    required this.roleId,
    required this.roleName,
    required this.isActive,
    this.createdAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> json) {
    final roleName = (json['role_name'] ?? json['roles']?['role_name'] ?? '')
        .toString();

    return UserProfile(
      id: json['id'].toString(),
      authId: json['auth_id'].toString(),
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      roleId: json['role_id'] ?? 0,
      roleName: roleName,
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString())
          ?.toLocal(),
    );
  }
}