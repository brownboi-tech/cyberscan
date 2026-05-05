import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

// V3 Glassmorphism AppBar — BackdropFilter blur, transparent — LOCKED
class DashboardAppBarWidget extends StatelessWidget {
  final VoidCallback onNotificationTap;
  final VoidCallback onAnalyticsTap;

  const DashboardAppBarWidget({
    super.key,
    required this.onNotificationTap,
    required this.onAnalyticsTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: const Color(0xB3080B12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                // App wordmark
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryMuted,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.primary.withAlpha(102),
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: CustomIconWidget(
                          iconName: 'radar',
                          color: AppTheme.primary,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'CYBER',
                      style: GoogleFonts.ibmPlexMono(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'SCAN',
                      style: GoogleFonts.ibmPlexMono(
                        color: AppTheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Timestamp
                Text(
                  '07:53 UTC',
                  style: GoogleFonts.ibmPlexMono(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 12),
                // Notification button
                _AppBarActionButton(
                  iconName: 'notifications',
                  onTap: onNotificationTap,
                  hasBadge: true,
                ),
                const SizedBox(width: 8),
                // Analytics button
                _AppBarActionButton(
                  iconName: 'analytics',
                  onTap: onAnalyticsTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarActionButton extends StatelessWidget {
  final String iconName;
  final VoidCallback onTap;
  final bool hasBadge;

  const _AppBarActionButton({
    required this.iconName,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2D3548), width: 0.5),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.textSecondary,
                size: 18,
              ),
            ),
          ),
          if (hasBadge)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.critical,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
