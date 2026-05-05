import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/status_badge_widget.dart';

// ReportCard — V2 Glassmorphism card — BackdropFilter + semi-transparent — LOCKED
// Anatomy: AI summary section + top fix section + model badge
class ReportCardWidget extends StatelessWidget {
  final Map<String, dynamic> report;
  final bool isExpanded;
  final VoidCallback onToggle;

  const ReportCardWidget({
    super.key,
    required this.report,
    required this.isExpanded,
    required this.onToggle,
  });

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  Color get _riskColor {
    final score = report['riskScore'] as int? ?? 0;
    if (score >= 75) return AppTheme.critical;
    if (score >= 50) return AppTheme.high;
    if (score >= 25) return AppTheme.medium;
    return AppTheme.low;
  }

  @override
  Widget build(BuildContext context) {
    final modelUsed = report['modelUsed'] as String? ?? 'gemini-flash';
    final riskScore = report['riskScore'] as int? ?? 0;
    final status = report['status'] as String? ?? 'completed';
    final findingCounts = report['findingCounts'] as Map<String, dynamic>;
    final isGeminiPro = modelUsed == 'gemini-pro';
    final isFailed = status == 'failed';

    return GestureDetector(
      onTap: onToggle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: isFailed ? const Color(0x1AFF3B30) : AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isFailed
                    ? AppTheme.critical.withAlpha(77)
                    : isGeminiPro
                    ? AppTheme.accentBlue.withAlpha(77)
                    : const Color(0xFF2D3548),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Card header ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: date + model badge + status
                      Row(
                        children: [
                          // Date badge — from Image 2 AIAnalysisCard anatomy
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
                                  _formatDate(report['scanDate'] as String),
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
                          // Model badge — action chip top-right from Image 2
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: isGeminiPro
                                  ? AppTheme.accentBlue.withAlpha(26)
                                  : AppTheme.primaryMuted,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isGeminiPro
                                    ? AppTheme.accentBlue.withAlpha(102)
                                    : AppTheme.primary.withAlpha(77),
                                width: 0.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'auto_awesome',
                                  color: isGeminiPro
                                      ? AppTheme.accentBlue
                                      : AppTheme.primary,
                                  size: 10,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  modelUsed,
                                  style: GoogleFonts.ibmPlexMono(
                                    color: isGeminiPro
                                        ? AppTheme.accentBlue
                                        : AppTheme.primary,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          StatusBadgeWidget(label: status, small: true),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Target name + risk score row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report['targetName'] as String,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Job ${report['scanJobId']}',
                                  style: GoogleFonts.ibmPlexMono(
                                    color: AppTheme.textMuted,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Risk score badge
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _riskColor.withAlpha(26),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _riskColor.withAlpha(77),
                                width: 0.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$riskScore',
                                  style: GoogleFonts.ibmPlexMono(
                                    color: _riskColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                                Text(
                                  'RISK',
                                  style: TextStyle(
                                    color: _riskColor.withAlpha(179),
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Severity pills row
                      Row(
                        children: [
                          _MiniSeverityPill(
                            label: 'C',
                            count: findingCounts['critical'] as int,
                            color: AppTheme.critical,
                          ),
                          const SizedBox(width: 4),
                          _MiniSeverityPill(
                            label: 'H',
                            count: findingCounts['high'] as int,
                            color: AppTheme.high,
                          ),
                          const SizedBox(width: 4),
                          _MiniSeverityPill(
                            label: 'M',
                            count: findingCounts['medium'] as int,
                            color: AppTheme.medium,
                          ),
                          const SizedBox(width: 4),
                          _MiniSeverityPill(
                            label: 'L',
                            count: findingCounts['low'] as int,
                            color: AppTheme.low,
                          ),
                          const Spacer(),
                          // Expand chevron
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: const CustomIconWidget(
                              iconName: 'chevron_down',
                              color: AppTheme.textMuted,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // ── Expanded content ─────────────────────────
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildExpandedContent(),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 280),
                  sizeCurve: Curves.easeOutCubic,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Divider
        Container(height: 0.5, color: const Color(0xFF2D3548)),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AI Summary section
              Row(
                children: [
                  const CustomIconWidget(
                    iconName: 'psychology',
                    color: AppTheme.primary,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'AI Summary',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withAlpha(13),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primary.withAlpha(38),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  report['aiSummary'] as String,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Top Fix section
              Row(
                children: [
                  const CustomIconWidget(
                    iconName: 'bolt',
                    color: AppTheme.accent,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Top Fix',
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(13),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.accent.withAlpha(51),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        report['topFix'] as String,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Action row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const CustomIconWidget(
                        iconName: 'download',
                        color: AppTheme.textSecondary,
                        size: 14,
                      ),
                      label: const Text(
                        'Export PDF',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        side: const BorderSide(
                          color: Color(0xFF2D3548),
                          width: 0.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const CustomIconWidget(
                        iconName: 'bug_report',
                        color: Color(0xFF001A0D),
                        size: 14,
                      ),
                      label: const Text(
                        'View Findings',
                        style: TextStyle(
                          color: Color(0xFF001A0D),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniSeverityPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _MiniSeverityPill({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withAlpha(77), width: 0.5),
      ),
      child: Text(
        '$label:$count',
        style: GoogleFonts.ibmPlexMono(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
