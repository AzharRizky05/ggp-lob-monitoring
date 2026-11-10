import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../features/users/models/user_model.dart';

class UserRepository {
  UserRepository();

  final SupabaseClient _client = SupabaseService.client;

  // Diambil dari file .env, sama seperti yang dipakai Supabase.initialize di main.dart.
  String get _supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  String get _supabaseKey => dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';

  Future<List<UserModel>> getUsers() async {
    final response = await _client
        .from('users')
        .select('''
          id, auth_id, full_name, email, phone, role_id, is_active, created_at,
          roles!users_role_id_fkey(role_name)
        ''')
        .order('full_name');

    return (response as List)
        .map((e) => UserModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<RoleOption>> getRoles() async {
    final response =
        await _client.from('roles').select('id, role_name').order('id');

    return (response as List)
        .map(
          (e) => RoleOption(
            id: (e['id'] as num).toInt(),
            name: (e['role_name'] ?? '').toString(),
          ),
        )
        .toList();
  }

  /// Membuat akun login, lalu menyimpan profilnya di tabel users.
  Future<void> createUser({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    required int roleId,
    required bool isActive,
  }) async {
    final authId = await _signUp(
      email: email,
      password: password,
      fullName: fullName,
    );

    try {
      await _client.from('users').upsert({
        'auth_id': authId,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'role_id': roleId,
        'is_active': isActive,
      }, onConflict: 'auth_id');
    } on PostgrestException catch (e) {
      throw Exception(
        'Akun login sudah dibuat, tetapi profil gagal disimpan: ${e.message}',
      );
    }
  }

  Future<void> updateUser({
    required String id,
    required String fullName,
    String? phone,
    required int roleId,
    required bool isActive,
  }) async {
    try {
      final updated = await _client
          .from('users')
          .update({
            'full_name': fullName,
            'phone': phone,
            'role_id': roleId,
            'is_active': isActive,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', id)
          .select('id');

      if (updated.isEmpty) {
        throw Exception(
          'Perubahan tidak tersimpan. Periksa izin (RLS) pada tabel users.',
        );
      }
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Memanggil endpoint signup Supabase Auth secara langsung (tanpa klien aplikasi),
  /// supaya sesi Administrator yang sedang login tidak tergantikan.
  Future<String> _signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    if (_supabaseUrl.isEmpty || _supabaseKey.isEmpty) {
      throw Exception(
        'Konfigurasi Supabase tidak ditemukan. Periksa SUPABASE_URL dan SUPABASE_PUBLISHABLE_KEY di file .env.',
      );
    }

    final response = await http.post(
      Uri.parse('$_supabaseUrl/auth/v1/signup'),
      headers: {
        'apikey': _supabaseKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'data': {'full_name': fullName},
      }),
    );

    final dynamic body =
        response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body is Map
          ? (body['msg'] ??
                  body['error_description'] ??
                  body['message'] ??
                  'Gagal membuat akun login.')
              .toString()
          : 'Gagal membuat akun login.';
      throw Exception(_translateAuthError(message));
    }

    final user = (body is Map && body['user'] is Map) ? body['user'] : body;
    final id = user is Map ? user['id'] : null;

    if (id == null) {
      throw Exception('Akun login tidak berhasil dibuat.');
    }
    return id.toString();
  }

  String _translateAuthError(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('already registered') || lower.contains('already exists')) {
      return 'Email sudah terdaftar.';
    }
    if (lower.contains('rate limit')) {
      return 'Batas pengiriman email Supabase tercapai. Matikan "Confirm email" di pengaturan Authentication, atau coba lagi nanti.';
    }
    if (lower.contains('password')) {
      return 'Password tidak memenuhi syarat (minimal 6 karakter).';
    }
    return message;
  }
}