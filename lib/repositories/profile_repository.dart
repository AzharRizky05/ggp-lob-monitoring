import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';

class ProfileRepository {
  ProfileRepository();

  final SupabaseClient _client = SupabaseService.client;

  /// Tanggal akun dibuat (kolom users.created_at).
  Future<DateTime?> getJoinedDate(String userId) async {
    final row = await _client
        .from('users')
        .select('created_at')
        .eq('id', userId)
        .maybeSingle();

    if (row == null) return null;
    return DateTime.tryParse((row['created_at'] ?? '').toString())?.toLocal();
  }

  Future<void> updateProfile({
    required String userId,
    required String fullName,
    String? phone,
  }) async {
    try {
      final updated = await _client
          .from('users')
          .update({
            'full_name': fullName,
            'phone': phone,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', userId)
          .select('id');

      // Kalau RLS memblokir, Supabase tidak error tapi tidak ada baris yang berubah.
      if (updated.isEmpty) {
        throw Exception(
          'Perubahan tidak tersimpan. Periksa izin (RLS) pada tabel users.',
        );
      }
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Memverifikasi password lama, lalu menggantinya dengan yang baru.
  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: currentPassword,
      );
    } on AuthException {
      throw Exception('Password saat ini salah.');
    }

    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw Exception(e.message);
    }
  }
}