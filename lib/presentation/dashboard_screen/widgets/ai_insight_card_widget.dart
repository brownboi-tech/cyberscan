import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

// AI Insight Hero Card — from Image 2 AIAnalysisCard anatomy — LOCKED
// Anatomy: date badge top-left + action chip top-right + bold title + AI icon right side
class AiInsightCardWidget extends StatelessWidget {
  final int urgentCount;
  final int totalFindings;

  const AiInsightCardWidget({
    super.key,
    required this.urgentCount,
    required this.totalFindings,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1A1F2E).withAlpha(230),
                AppTheme.primaryContainer.withAlpha(77),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.primary.withAlpha(51),
              width: 0.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: date badge + AI-Report chip
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFF2D3548),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CustomIconWidget(
                                iconName: 'schedule',
                                color: AppTheme.textMuted,
                                size: 10,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '5 May 2026',
                                style: GoogleFonts.ibmPlexMono(
                                  color: AppTheme.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryMuted,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.primary.withAlpha(77),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            'AI-Report',
                            style: GoogleFonts.ibmPlexMono(
                              color: AppTheme.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Subtitle
                    Text(
                      "Today's AI Analysis",
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Bold title
                    Text(
                      urgentCount > 0
                          ? 'You Have $urgentCount Issues\nRequiring Triage.'
                          : 'All Systems Nominal.\nNo Critical Issues.',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Stats row
                    Row(
                      children: [
                        _StatPill(
                          label: '$totalFindings Findings',
                          color: AppTheme.accent,
                        ),
                        const SizedBox(width: 6),
                        _StatPill(
                          label: 'Gemini Pro',
                          color: AppTheme.accentBlue,
                          iconName: 'auto_awesome',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // AI icon right side
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.primaryMuted,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.primary.withAlpha(77),
                    width: 0.5,
                  ),
                ),
                child: const Center(
                  child: CustomIconWidget(
                    iconName: 'psychology',
                    color: AppTheme.primary,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final Color color;
  final String? iconName;

  const _StatPill({required this.label, required this.color, this.iconName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(77), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconName != null) ...[
            CustomIconWidget(iconName: iconName!, color: color, size: 10),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
