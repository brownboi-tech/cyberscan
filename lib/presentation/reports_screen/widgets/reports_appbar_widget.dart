import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class ReportsAppBarWidget extends StatelessWidget {
  final int reportCount;

  const ReportsAppBarWidget({super.key, required this.reportCount});

  @override
  Widget build(BuildContext context) {
    // V3 Glassmorphism AppBar — BackdropFilter blur, transparent — LOCKED
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: const Color(0xB3080B12),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reports',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'AI-assisted analysis via Gemini',
                    style: GoogleFonts.ibmPlexMono(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Gemini model indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withAlpha(26),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.accentBlue.withAlpha(77),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomIconWidget(
                      iconName: 'auto_awesome',
                      color: AppTheme.accentBlue,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Gemini',
                      style: GoogleFonts.ibmPlexMono(
                        color: AppTheme.accentBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
