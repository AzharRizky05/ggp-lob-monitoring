import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/api_config.dart';
import '../core/services/api_client.dart';
import '../core/services/supabase_service.dart';
import '../features/auth/models/user_profile.dart';

class AuthRepository {
  AuthRepository();

  /// Sementara hanya dipakai sebagai penyimpan sesi (token + refresh otomatis).
  /// Akan dicabut setelah semua modul memakai endpoint.
  final SupabaseClient _client = SupabaseService.client;

  final ApiClient _api = ApiClient.instance;

  final Dio _authDio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.authUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'apikey': ApiConfig.anonKey,
        'Content-Type': 'application/json',
      },
    ),
  );

  /// Login lewat endpoint: POST /auth/v1/token?grant_type=password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _authDio.post(
        '/token',
        queryParameters: {'grant_type': 'password'},
        data: {'email': email, 'password': password},
      );

      final refreshToken = res.data['refresh_token'] as String;

      // Serahkan sesi ke SDK agar token tersimpan dan diperbarui otomatis.
      return await _client.auth.setSession(refreshToken);
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 400 || status == 401) {
        throw ApiException('Email atau password salah.', statusCode: status);
      }

      throw ApiException(
        'Tidak dapat terhubung ke server. Periksa koneksi internet.',
        statusCode: status,
      );
    }
  }

  /// Logout lewat endpoint: POST /auth/v1/logout
  Future<void> signOut() async {
    try {
      final token = _client.auth.currentSession?.accessToken;

      if (token != null) {
        await _authDio.post(
          '/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
    } catch (e) {
      debugPrint('Logout endpoint error: $e');
    }

    try {
      await _client.auth.signOut();
    } catch (_) {
      // Sesi sudah dicabut di server, cukup bersihkan sesi lokal.
    }
  }

  /// User yang sedang login
  User? get currentUser => _client.auth.currentUser;

  /// Stream perubahan status autentikasi
  Stream<AuthState> get authState => _client.auth.onAuthStateChange;

  /// Profil user dari tabel public.users
  /// GET /rest/v1/users?select=*,roles!users_role_id_fkey(role_name)&auth_id=eq.{id}
  Future<UserProfile?> getCurrentUserProfile({String? authId}) async {
    try {
      final userId = authId ?? currentUser?.id;

      if (userId == null) {
        debugPrint('User belum login.');
        return null;
      }

      final response = await _api.get(
        '/users',
        query: {
          'select': '*,roles!users_role_id_fkey(role_name)',
          'auth_id': 'eq.$userId',
          'limit': 1,
        },
      );

      final list = response as List;
      if (list.isEmpty) {
        debugPrint('Profil user tidak ditemukan untuk auth_id: $userId');
        return null;
      }

      return UserProfile.fromMap(Map<String, dynamic>.from(list.first as Map));
    } catch (e, s) {
      debugPrint('AUTH ERROR: $e');
      debugPrint(s.toString());
      return null;
    }
  }
}