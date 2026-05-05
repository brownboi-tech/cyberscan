import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/status_badge_widget.dart';

class RecentScanJobsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> scanJobs;
  final List<Map<String, dynamic>> targets;

  const RecentScanJobsWidget({
    super.key,
    required this.scanJobs,
    required this.targets,
  });

  String _targetName(String targetId) {
    final t = targets.firstWhere(
      (t) => t['id'] == targetId,
      orElse: () => {'name': 'Unknown Target'},
    );
    return t['name'] as String;
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return '--:--';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header — from Image 2 SectionHeader anatomy
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Scan Jobs',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF2D3548), width: 0.5),
              ),
              child: Text(
                '${scanJobs.length} Jobs',
                style: GoogleFonts.ibmPlexMono(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Job cards — V1 Rich Data Row — LOCKED
        ...scanJobs
            .take(5)
            .map(
              (job) => _ScanJobCard(
                job: job,
                targetName: _targetName(job['targetId'] as String),
                formattedTime: _formatTime(job['startedAt'] as String),
              ),
            ),
      ],
    );
  }
}

class _ScanJobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final String targetName;
  final String formattedTime;

  const _ScanJobCard({
    required this.job,
    required this.targetName,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    final status = job['status'] as String;
    final severity = job['severitySummary'] as Map<String, dynamic>;
    final isRunning = status == 'running';
    final isFailed = status == 'failed';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isFailed ? AppTheme.criticalMuted : AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isFailed
                ? AppTheme.critical.withAlpha(77)
                : isRunning
                ? AppTheme.primary.withAlpha(51)
                : const Color(0xFF2D3548),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Status indicator dot
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRunning
                        ? AppTheme.primary
                        : isFailed
                        ? AppTheme.critical
                        : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(width: 8),
                // Target name
                Expanded(
                  child: Text(
                    targetName,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Status badge
                StatusBadgeWidget(label: status, small: true),
                const SizedBox(width: 8),
                // Time
                Text(
                  formattedTime,
                  style: GoogleFonts.ibmPlexMono(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            if ((severity['critical'] as int? ?? 0) > 0 ||
                (severity['high'] as int? ?? 0) > 0) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 16),
                  _SeverityPill(
                    label: 'C',
                    count: severity['critical'] as int? ?? 0,
                    color: AppTheme.critical,
                  ),
                  const SizedBox(width: 4),
                  _SeverityPill(
                    label: 'H',
                    count: severity['high'] as int? ?? 0,
                    color: AppTheme.high,
                  ),
                  const SizedBox(width: 4),
                  _SeverityPill(
                    label: 'M',
                    count: severity['medium'] as int? ?? 0,
                    color: AppTheme.medium,
                  ),
                  const SizedBox(width: 4),
                  _SeverityPill(
                    label: 'L',
                    count: severity['low'] as int? ?? 0,
                    color: AppTheme.low,
                  ),
                ],
              ),
            ],
            if (isRunning) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: null,
                  backgroundColor: AppTheme.surfaceVariant,
                  color: AppTheme.primary,
                  minHeight: 2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SeverityPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _SeverityPill({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(77), width: 0.5),
      ),
      child: Text(
        '$label:$count',
        style: GoogleFonts.ibmPlexMono(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
