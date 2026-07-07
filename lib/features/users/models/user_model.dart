class UserModel {
  final String id;
  final String nama;
  final String email;
  final String role;
  final String status;
  final DateTime terakhirLogin;

  const UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
    required this.status,
    required this.terakhirLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      terakhirLogin:
          DateTime.tryParse(json['terakhir_login'] ?? '') ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'role': role,
      'status': status,
      'terakhir_login':
          terakhirLogin.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? nama,
    String? email,
    String? role,
    String? status,
    DateTime? terakhirLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      terakhirLogin:
          terakhirLogin ?? this.terakhirLogin,
    );
  }
}