/// Dummy data sementara untuk halaman Profile.
/// Nanti tinggal diganti dengan data dari UserProfile (Supabase)
/// via AuthProvider tanpa mengubah widget yang memakainya.
class ProfileDummyData {
  ProfileDummyData._();

  static const String fullName = 'Administrator';
  static const String email = 'admin@lobmonitoring.com';
  static const String role = 'Administrator';
  static const String status = 'Aktif';
  static const String joinedDate = '06 July 2026';
  static const String? photoUrl = null;

  static String get initial =>
      fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
}