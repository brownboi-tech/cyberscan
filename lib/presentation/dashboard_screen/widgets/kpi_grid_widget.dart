import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

// KPI 2×2 grid — from Image 2 two-column stat cards anatomy — LOCKED
class KpiGridWidget extends StatelessWidget {
  final int activeCount;
  final int queuedCount;
  final int completedCount;
  final int criticalCount;

  const KpiGridWidget({
    super.key,
    required this.activeCount,
    required this.queuedCount,
    required this.completedCount,
    required this.criticalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                label: 'Active Scans',
                value: activeCount,
                iconName: 'radar',
                accentColor: AppTheme.primary,
                trend: '+1 since 06:00',
                trendUp: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _KpiCard(
                label: 'Queued Jobs',
                value: queuedCount,
                iconName: 'hourglass',
                accentColor: AppTheme.accent,
                trend: 'Awaiting slot',
                trendUp: null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                label: 'Completed',
                value: completedCount,
                iconName: 'done_all',
                accentColor: AppTheme.accentBlue,
                trend: 'Last 24h',
                trendUp: null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _KpiCard(
                label: 'Critical Finds',
                value: criticalCount,
                iconName: 'warning',
                accentColor: AppTheme.critical,
                trend: criticalCount > 0 ? 'Needs triage' : 'All clear',
                trendUp: criticalCount > 0 ? false : null,
                isAlert: criticalCount > 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final int value;
  final String iconName;
  final Color accentColor;
  final String trend;
  final bool? trendUp;
  final bool isAlert;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.iconName,
    required this.accentColor,
    required this.trend,
    required this.trendUp,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAlert ? AppTheme.criticalMuted : AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAlert
              ? AppTheme.critical.withAlpha(102)
              : const Color(0xFF2D3548),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(26),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: accentColor,
                    size: 14,
                  ),
                ),
              ),
              if (trendUp != null)
                CustomIconWidget(
                  iconName: trendUp! ? 'trending_up' : 'trending_down',
                  color: trendUp! ? AppTheme.primary : AppTheme.critical,
                  size: 14,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: GoogleFonts.ibmPlexMono(
              color: isAlert ? AppTheme.critical : AppTheme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            trend,
            style: TextStyle(
              color: isAlert ? AppTheme.critical : AppTheme.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
