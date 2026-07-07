import 'package:go_router/go_router.dart';

import '../../features/approval/pages/approval_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/splash_page.dart';
import '../../features/batch/pages/batch_page.dart';
import '../../features/dashboard/pages/dashboard_page.dart';
import '../../features/history/pages/history_page.dart';
import '../../features/monitoring/pages/monitoring_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/quality_control/pages/qc_page.dart';
import '../../features/reports/pages/report_page.dart';
import '../../features/settings/pages/settings_page.dart';
import '../../features/users/pages/user_page.dart';
import 'route_name.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteName.splash,
  routes: [
    GoRoute(
      path: RouteName.splash,
      builder: (context, state) => const SplashPage(),
    ),

    GoRoute(
      path: RouteName.login,
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: RouteName.dashboard,
      builder: (context, state) => const DashboardPage(),
    ),

    GoRoute(
      path: RouteName.batch,
      builder: (context, state) => const BatchPage(),
    ),

    GoRoute(
      path: RouteName.monitoring,
      builder: (context, state) => const MonitoringPage(),
    ),

    GoRoute(
      path: RouteName.qc,
      builder: (context, state) => const QcPage(),
    ),

    GoRoute(
      path: RouteName.approval,
      builder: (context, state) => const ApprovalPage(),
    ),

    GoRoute(
      path: RouteName.history,
      builder: (context, state) => const HistoryPage(),
    ),

    GoRoute(
      path: RouteName.report,
      builder: (context, state) => const ReportPage(),
    ),

    GoRoute(
      path: RouteName.profile,
      builder: (context, state) => const ProfilePage(),
    ),

    GoRoute(
      path: RouteName.users,
      builder: (context, state) => const UsersPage(),
    ),

    GoRoute(
      path: RouteName.settings,
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);