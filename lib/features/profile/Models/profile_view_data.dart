import '../../auth/models/user_profile.dart';

class ProfileViewData {
  const ProfileViewData({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.joinedAt,
  });

  final String fullName;
  final String email;
  final String? phone;
  final String role;
  final bool isActive;
  final DateTime? joinedAt;

  factory ProfileViewData.from(UserProfile profile, DateTime? joinedAt) {
    return ProfileViewData(
      fullName: profile.fullName,
      email: profile.email,
      phone: profile.phone,
      role: profile.roleName,
      isActive: profile.isActive,
      joinedAt: joinedAt,
    );
  }

  static const List<String> _months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  String get initial {
    final name = fullName.trim();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String get statusLabel => isActive ? 'Aktif' : 'Nonaktif';

  String get phoneLabel {
    final value = phone?.trim() ?? '';
    return value.isEmpty ? '-' : value;
  }

  String get joinedLabel {
    final date = joinedAt;
    if (date == null) return '-';
    final day = date.day.toString().padLeft(2, '0');
    return '$day ${_months[date.month - 1]} ${date.year}';
  }
}