import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/api_config.dart';

/// Error standar dari endpoint (format error PostgREST/Supabase).
class ApiException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  ApiException(this.message, {this.code, this.statusCode});

  @override
  String toString() => message;
}

/// Satu-satunya pintu keluar untuk memanggil endpoint REST.
/// Repository memakai ini, UI/Provider tidak boleh memanggil langsung.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  /// Token dari login via endpoint (diisi pada tahap AuthRepository).
  String? _accessToken;

  void setToken(String? token) => _accessToken = token;

  /// Sementara: kalau belum ada token dari login REST, pakai sesi login
  /// yang sudah ada, supaya halaman Batch bisa dites lebih dulu.
  String? get _token =>
      _accessToken ?? Supabase.instance.client.auth.currentSession?.accessToken;

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.restUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'apikey': ApiConfig.anonKey,
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

  /// GET -> mengembalikan List atau Map hasil decode JSON.
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) {
    return _send('GET', path, query: query);
  }

  /// POST (tambah data)
  Future<dynamic> post(String path, {required Object data}) {
    return _send('POST', path,
        data: data, headers: {'Prefer': 'return=minimal'});
  }

  /// PATCH (ubah data). Mengembalikan baris yang berubah;
  /// list kosong berarti tidak ada yang berubah (biasanya diblokir RLS).
  Future<List<dynamic>> patch(String path,
      {required Map<String, dynamic> query, required Object data}) async {
    final res = await _send(
      'PATCH',
      path,
      query: query,
      data: data,
      headers: {'Prefer': 'return=representation'},
    );
    return res as List<dynamic>;
  }

  /// DELETE. Mengembalikan baris yang terhapus; list kosong = tidak ada yang terhapus.
  Future<List<dynamic>> delete(String path,
      {required Map<String, dynamic> query}) async {
    final res = await _send(
      'DELETE',
      path,
      query: query,
      headers: {'Prefer': 'return=representation'},
    );
    return res as List<dynamic>;
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? query,
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: query,
        options: Options(method: method, headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body is Map) {
        throw ApiException(
          body['message']?.toString() ?? 'Terjadi kesalahan pada server.',
          code: body['code']?.toString(),
          statusCode: e.response?.statusCode,
        );
      }
      throw ApiException(
        'Tidak dapat terhubung ke server. Periksa koneksi internet.',
        statusCode: e.response?.statusCode,
      );
    }
  }
}