import 'dart:ui';

import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import './custom_icon_widget.dart';

class AppNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    if (isTablet) {
      return _buildNavigationRail(context);
    }
    return _buildBottomNav(context);
  }

  Widget _buildBottomNav(BuildContext context) {
    // V3 Liquid Glass — BackdropFilter blur + animated pill — LOCKED
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xCC0D1117),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF2D3548), width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(102),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, 0, 'dashboard', 'Dashboard'),
                  _buildNavItem(context, 1, 'bug_report', 'Findings'),
                  _buildNavItem(context, 2, 'article', 'Reports'),
                  _buildNavItem(context, 3, 'construction', 'Tools'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    String icon,
    String label,
  ) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryMuted : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isActive ? AppTheme.primary : AppTheme.textMuted,
              size: 22,
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isActive ? AppTheme.primary : AppTheme.textMuted,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 0.2,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: AppTheme.surfaceDark,
      indicatorColor: AppTheme.primaryMuted,
      selectedIconTheme: const IconThemeData(color: AppTheme.primary, size: 22),
      unselectedIconTheme: const IconThemeData(
        color: AppTheme.textMuted,
        size: 22,
      ),
      selectedLabelTextStyle: const TextStyle(
        color: AppTheme.primary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: const TextStyle(
        color: AppTheme.textMuted,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_rounded),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bug_report_rounded),
          label: Text('Findings'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.article_rounded),
          label: Text('Reports'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.construction_rounded),
          label: Text('Tools'),
        ),
      ],
    );
  }
}

class MainScaffold extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  // TODO: Replace with Riverpod/Bloc for production

  void _onNavTap(int index) {
    final routes = [
      AppRoutes.dashboardScreen,
      AppRoutes.findingsScreen,
      AppRoutes.reportsScreen,
      AppRoutes.toolsScreen,
    ];
    if (index != widget.currentIndex) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routes[index],
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    if (isTablet) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Row(
          children: [
            AppNavigationWidget(
              currentIndex: widget.currentIndex,
              onTap: _onNavTap,
            ),
            const VerticalDivider(width: 0.5, color: Color(0xFF1E2433)),
            Expanded(child: widget.child),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: AppNavigationWidget(
        currentIndex: widget.currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
