import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

// Section header — from Image 2 SectionHeader anatomy — LOCKED
// label + count chip + chevron toggle — full-width Row
class FindingsSectionHeaderWidget extends StatelessWidget {
  final String severity;
  final int count;
  final bool isCollapsed;
  final VoidCallback onToggle;

  const FindingsSectionHeaderWidget({
    super.key,
    required this.severity,
    required this.count,
    required this.isCollapsed,
    required this.onToggle,
  });

  String get _label => severity[0].toUpperCase() + severity.substring(1);

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.severityColor(severity);

    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Severity color bar
            Container(
              width: 3,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            // Count chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withAlpha(26),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withAlpha(77), width: 0.5),
              ),
              child: Text(
                '$count ${count == 1 ? "Issue" : "Issues"}',
                style: GoogleFonts.ibmPlexMono(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            // Chevron toggle
            AnimatedRotation(
              turns: isCollapsed ? -0.25 : 0,
              duration: const Duration(milliseconds: 200),
              child: CustomIconWidget(
                iconName: 'chevron_down',
                color: AppTheme.textMuted,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
