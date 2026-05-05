import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/status_badge_widget.dart';

// FindingCard — from Image 2 TaskCard anatomy adapted for security findings — LOCKED
// Anatomy: severity badge top-left + category chip top-right + title + summary excerpt + scan job ref row
class FindingCardWidget extends StatefulWidget {
  final Map<String, dynamic> finding;

  const FindingCardWidget({super.key, required this.finding});

  @override
  State<FindingCardWidget> createState() => _FindingCardWidgetState();
}

class _FindingCardWidgetState extends State<FindingCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final f = widget.finding;
    final severity = f['severity'] as String;
    final accentColor = AppTheme.severityColor(severity);
    final isCritical = severity == 'critical';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: isCritical
                    ? const Color(0x1AFF3B30)
                    : AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCritical
                      ? AppTheme.critical.withAlpha(102)
                      : const Color(0xFF2D3548),
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  // Left accent bar
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 3,
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: severity badge + category chip
                                Row(
                                  children: [
                                    StatusBadgeWidget(
                                      label: severity,
                                      type: 'severity',
                                      small: true,
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceVariant,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: const Color(0xFF2D3548),
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Text(
                                        f['category'] as String? ?? 'General',
                                        style: const TextStyle(
                                          color: AppTheme.textMuted,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (f['cve'] != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.accentBlue.withAlpha(
                                            26,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: AppTheme.accentBlue
                                                .withAlpha(77),
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Text(
                                          f['cve'] as String,
                                          style: GoogleFonts.ibmPlexMono(
                                            color: AppTheme.accentBlue,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Title
                                Text(
                                  f['title'] as String,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Summary excerpt
                                Text(
                                  f['summary'] as String,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 11,
                                    height: 1.4,
                                  ),
                                  maxLines: _isExpanded ? null : 2,
                                  overflow: _isExpanded
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                                ),
                                // Expanded: remediation
                                if (_isExpanded) ...[
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary.withAlpha(13),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppTheme.primary.withAlpha(51),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CustomIconWidget(
                                          iconName: 'bolt',
                                          color: AppTheme.primary,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Remediation',
                                                style: TextStyle(
                                                  color: AppTheme.primary,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                f['remediation'] as String,
                                                style: const TextStyle(
                                                  color: AppTheme.textSecondary,
                                                  fontSize: 11,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 8),
                                // Bottom row: scan job ref + expand indicator
                                Row(
                                  children: [
                                    const CustomIconWidget(
                                      iconName: 'radar',
                                      color: AppTheme.textMuted,
                                      size: 11,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${f['targetName']}  ·  Job ${f['scanJobId']}',
                                      style: GoogleFonts.ibmPlexMono(
                                        color: AppTheme.textMuted,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const Spacer(),
                                    AnimatedRotation(
                                      turns: _isExpanded ? 0.5 : 0,
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: const CustomIconWidget(
                                        iconName: 'chevron_down',
                                        color: AppTheme.textMuted,
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
