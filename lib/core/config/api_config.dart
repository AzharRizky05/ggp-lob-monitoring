import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  ApiConfig._();

  /// Project URL (dari .env), garis miring di akhir dibuang bila ada
  static String get baseUrl =>
      dotenv.env['SUPABASE_URL']!.replaceAll(RegExp(r'/+$'), '');

  /// Key publik (dari .env), sama dengan yang dipakai Supabase.initialize
  static String get anonKey => dotenv.env['SUPABASE_PUBLISHABLE_KEY']!;

  static String get restUrl => '$baseUrl/rest/v1';
  static String get authUrl => '$baseUrl/auth/v1';
}