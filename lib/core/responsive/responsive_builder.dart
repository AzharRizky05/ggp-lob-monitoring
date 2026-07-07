import 'package:flutter/material.dart';

import 'breakpoints.dart';

class ResponsiveBuilder {
  ResponsiveBuilder._();

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < Breakpoints.mobile;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.mobile &&
        MediaQuery.of(context).size.width < Breakpoints.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.tablet;
  }
}