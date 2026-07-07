import 'package:flutter/material.dart';

import '../models/sidebar_menu.dart';
import '../router/route_name.dart';

class SidebarMenuData {
  SidebarMenuData._();

  /// ==========================================================
  /// Administrator
  /// ==========================================================
  static const List<SidebarMenu> administrator = [
    SidebarMenu(
      icon: Icons.dashboard_rounded,
      title: "Dashboard",
      route: RouteName.dashboard,
    ),
    SidebarMenu(
      icon: Icons.inventory_2_rounded,
      title: "Production Batch",
      route: RouteName.batch,
    ),
    SidebarMenu(
      icon: Icons.monitor_heart_rounded,
      title: "Production Monitoring",
      route: RouteName.monitoring,
    ),
    SidebarMenu(
      icon: Icons.science_rounded,
      title: "Quality Control",
      route: RouteName.qc,
    ),
    SidebarMenu(
      icon: Icons.verified_user_rounded,
      title: "Approval",
      route: RouteName.approval,
    ),
    SidebarMenu(
      icon: Icons.history_rounded,
      title: "Production History",
      route: RouteName.history,
    ),
    SidebarMenu(
      icon: Icons.bar_chart_rounded,
      title: "Reports",
      route: RouteName.report,
    ),
    SidebarMenu(
      icon: Icons.people_alt_rounded,
      title: "User Management",
      route: RouteName.users,
    ),
    SidebarMenu(
      icon: Icons.settings_rounded,
      title: "Settings",
      route: RouteName.settings,
    ),
    SidebarMenu(
      icon: Icons.person_rounded,
      title: "Profile",
      route: RouteName.profile,
    ),
  ];

  /// ==========================================================
  /// Operator Produksi
  /// ==========================================================
  static const List<SidebarMenu> operator = [
    SidebarMenu(
      icon: Icons.dashboard_rounded,
      title: "Dashboard",
      route: RouteName.dashboard,
    ),
    SidebarMenu(
      icon: Icons.inventory_2_rounded,
      title: "Production Batch",
      route: RouteName.batch,
    ),
    SidebarMenu(
      icon: Icons.monitor_heart_rounded,
      title: "Production Monitoring",
      route: RouteName.monitoring,
    ),
    SidebarMenu(
      icon: Icons.history_rounded,
      title: "Production History",
      route: RouteName.history,
    ),
    SidebarMenu(
      icon: Icons.person_rounded,
      title: "Profile",
      route: RouteName.profile,
    ),
  ];

  /// ==========================================================
  /// Quality Control
  /// ==========================================================
  static const List<SidebarMenu> qualityControl = [
    SidebarMenu(
      icon: Icons.dashboard_rounded,
      title: "Dashboard",
      route: RouteName.dashboard,
    ),
    SidebarMenu(
      icon: Icons.monitor_heart_rounded,
      title: "Production Monitoring",
      route: RouteName.monitoring,
    ),
    SidebarMenu(
      icon: Icons.science_rounded,
      title: "Quality Control",
      route: RouteName.qc,
    ),
    SidebarMenu(
      icon: Icons.history_rounded,
      title: "Production History",
      route: RouteName.history,
    ),
    SidebarMenu(
      icon: Icons.person_rounded,
      title: "Profile",
      route: RouteName.profile,
    ),
  ];

  /// ==========================================================
  /// Supervisor
  /// ==========================================================
  static const List<SidebarMenu> supervisor = [
    SidebarMenu(
      icon: Icons.dashboard_rounded,
      title: "Dashboard",
      route: RouteName.dashboard,
    ),
    SidebarMenu(
      icon: Icons.monitor_heart_rounded,
      title: "Production Monitoring",
      route: RouteName.monitoring,
    ),
    SidebarMenu(
      icon: Icons.verified_user_rounded,
      title: "Approval",
      route: RouteName.approval,
    ),
    SidebarMenu(
      icon: Icons.history_rounded,
      title: "Production History",
      route: RouteName.history,
    ),
    SidebarMenu(
      icon: Icons.bar_chart_rounded,
      title: "Reports",
      route: RouteName.report,
    ),
    SidebarMenu(
      icon: Icons.person_rounded,
      title: "Profile",
      route: RouteName.profile,
    ),
  ];

  /// ==========================================================
  /// Get Sidebar berdasarkan Role
  /// ==========================================================
  static List<SidebarMenu> getMenus(String? role) {
    if (role == null) return operator;

    final value = role.trim().toLowerCase();

    switch (value) {
      case 'administrator':
        return administrator;

      case 'operator produksi':
      case 'operator':
        return operator;

      case 'quality control':
      case 'qc':
        return qualityControl;

      case 'supervisor':
        return supervisor;

      default:
        if (value.contains('administrator')) {
          return administrator;
        }

        if (value.contains('operator')) {
          return operator;
        }

        if (value.contains('quality')) {
          return qualityControl;
        }

        if (value.contains('qc')) {
          return qualityControl;
        }

        if (value.contains('supervisor')) {
          return supervisor;
        }

        return operator;
    }
  }
}