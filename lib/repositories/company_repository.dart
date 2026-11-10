import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../features/settings/models/company_settings.dart';

class CompanyRepository {
  CompanyRepository();

  final SupabaseClient _client = SupabaseService.client;

  /// Data perusahaan berada di satu baris saja (baris dengan id terkecil).
  Future<CompanySettings?> getCompany() async {
    final row = await _client
        .from('company_settings')
        .select()
        .order('id')
        .limit(1)
        .maybeSingle();

    if (row == null) return null;
    return CompanySettings.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> saveCompany(CompanySettings data) async {
    final values = {
      ...data.toMap(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      if (data.id != null) {
        final updated = await _client
            .from('company_settings')
            .update(values)
            .eq('id', data.id!)
            .select('id');

        // Kalau RLS memblokir, Supabase tidak error tapi tidak ada baris yang berubah.
        if (updated.isEmpty) {
          throw Exception(
            'Perubahan tidak tersimpan. Periksa izin (RLS) pada tabel company_settings.',
          );
        }
      } else {
        await _client.from('company_settings').insert(values);
      }
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }
}