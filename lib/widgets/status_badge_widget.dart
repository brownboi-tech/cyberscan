import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final String type; // 'status' | 'severity'
  final bool small;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    this.type = 'status',
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color textColor;

    if (type == 'severity') {
      bgColor = AppTheme.severityMutedColor(label);
      textColor = AppTheme.severityColor(label);
    } else {
      switch (label.toLowerCase()) {
        case 'running':
          bgColor = const Color(0x3300FF88);
          textColor = AppTheme.primary;
          break;
        case 'queued':
          bgColor = const Color(0x33FFB800);
          textColor = AppTheme.accent;
          break;
        case 'completed':
          bgColor = const Color(0x333B82F6);
          textColor = AppTheme.accentBlue;
          break;
        case 'failed':
          bgColor = AppTheme.criticalMuted;
          textColor = AppTheme.critical;
          break;
        default:
          bgColor = const Color(0x334A5568);
          textColor = AppTheme.textSecondary;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: textColor.withAlpha(77), width: 0.5),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.ibmPlexMono(
          color: textColor,
          fontSize: small ? 9 : 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
