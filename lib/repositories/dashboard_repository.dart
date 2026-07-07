import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../features/dashboard/models/dashboard_data.dart';

class DashboardRepository {
  DashboardRepository();

  final SupabaseClient _client = SupabaseService.client;

  Future<DashboardData> getDashboardData() async {
    final summaryResponse = await _client
        .from('dashboard_summary')
        .select('*')
        .maybeSingle();

    final monthlyResponse = await _client
        .from('monthly_production')
        .select('*')
        .order('month_index');

    final recentResponse = await _client
        .from('dashboard_recent_batches')
        .select('*')
        .order('updated_at', ascending: false)
        .limit(5);

    final summaryMap = Map<String, dynamic>.from(summaryResponse ?? {});
    final monthlyMaps = monthlyResponse
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    final recentMaps = recentResponse
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return DashboardData.fromMaps(
      summaryMap: summaryMap,
      monthlyMaps: monthlyMaps,
      recentMaps: recentMaps,
    );
  }
}


