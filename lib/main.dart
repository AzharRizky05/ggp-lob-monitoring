import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'providers/approval_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/batch_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/monitoring_provider.dart';
import 'providers/qc_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID');

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY']!,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<DashboardProvider>(
          create: (_) => DashboardProvider(),
        ),
        ChangeNotifierProvider<BatchProvider>(
          create: (_) => BatchProvider(),
        ),
        ChangeNotifierProvider<MonitoringProvider>(
          create: (_) => MonitoringProvider(),
        ),
        ChangeNotifierProvider<QcProvider>(
          create: (_) => QcProvider(),
        ),
        ChangeNotifierProvider<ApprovalProvider>(
          create: (_) => ApprovalProvider(),
        ),
      ],
      child: const GGPLobMonitoringApp(),
    ),
  );
}

class GGPLobMonitoringApp extends StatelessWidget {
  const GGPLobMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'GGP LOB Monitoring',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}