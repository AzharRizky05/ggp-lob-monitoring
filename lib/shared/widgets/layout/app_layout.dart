import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive.dart';
import 'app_content.dart';
import 'app_header.dart';
import 'app_sidebar.dart';

class AppLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const AppLayout({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);

    final currentRoute =
        GoRouterState.of(context).matchedLocation;

    final sidebar = AppSidebar(
      currentRoute: currentRoute,
    );

    return Scaffold(
      drawer: mobile
          ? Drawer(
              child: sidebar,
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (!mobile) sidebar,
            Expanded(
              child: Column(
                children: [
                  AppHeader(
                    title: title,
                  ),
                  Expanded(
                    child: AppContent(
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}