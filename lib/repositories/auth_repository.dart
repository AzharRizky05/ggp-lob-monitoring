import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../features/auth/models/user_profile.dart';

class AuthRepository {
  AuthRepository();

  final SupabaseClient _client = SupabaseService.client;

  /// Login menggunakan email & password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Logout
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// User yang sedang login pada Supabase Auth
  User? get currentUser => _client.auth.currentUser;

  /// Stream perubahan status autentikasi
  Stream<AuthState> get authState => _client.auth.onAuthStateChange;

  /// Mengambil profil user dari tabel public.users
  Future<UserProfile?> getCurrentUserProfile({String? authId}) async {
    try {
      final userId = authId ?? currentUser?.id;

      if (userId == null) {
        debugPrint("❌ User belum login.");
        return null;
      }

      final response = await _client
          .from('users')
          .select('''
            *,
            roles!users_role_id_fkey (
              role_name
            )
          ''')
          .eq('auth_id', userId)
          .single();

      debugPrint("======================================");
      debugPrint("AUTH ID : $userId");
      debugPrint("SUPABASE RESPONSE :");
      debugPrint(response.toString());
      debugPrint("======================================");

      final profile = UserProfile.fromMap(response);

      debugPrint("=========== USER PROFILE ===========");
      debugPrint("Full Name : ${profile.fullName}");
      debugPrint("Email     : ${profile.email}");
      debugPrint("Role ID   : ${profile.roleId}");
      debugPrint("Role Name : ${profile.roleName}");
      debugPrint("Active    : ${profile.isActive}");
      debugPrint("====================================");

      return profile;
    } catch (e, s) {
      debugPrint("=========== AUTH ERROR ===========");
      debugPrint(e.toString());
      debugPrint(s.toString());
      debugPrint("==================================");

      return null;
    }
  }
}