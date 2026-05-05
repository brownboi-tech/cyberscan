import 'package:flutter/material.dart';

import '../presentation/dashboard_screen/dashboard_screen.dart';
import '../presentation/findings_screen/findings_screen.dart';
import '../presentation/reports_screen/reports_screen.dart';
import '../presentation/tools_screen/tools_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String dashboardScreen = '/dashboard-screen';
  static const String findingsScreen = '/findings-screen';
  static const String reportsScreen = '/reports-screen';
  static const String toolsScreen = '/tools-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const DashboardScreen(),
    dashboardScreen: (context) => const DashboardScreen(),
    findingsScreen: (context) => const FindingsScreen(),
    reportsScreen: (context) => const ReportsScreen(),
    toolsScreen: (context) => const ToolsScreen(),
  };
}
