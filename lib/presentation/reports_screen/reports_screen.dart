
import '../../core/app_export.dart';
import './widgets/report_card_widget.dart';
import './widgets/reports_appbar_widget.dart';
import './widgets/severity_donut_chart_widget.dart';

// TODO: Replace with Riverpod/Bloc for production

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isLoading = true;
  late List<Map<String, dynamic>> _reportMaps;
  String? _expandedReportId;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    // TODO: Replace with CyberScanRepository.getReports()
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _reportMaps = _mockReportMaps;
    });
  }

  // ── Mock data (map-first) ──────────────────────────────────
  final List<Map<String, dynamic>> _mockReportMaps = [
    {
      'id': 'r1',
      'scanJobId': 'j5',
      'targetName': 'Nexus API Gateway',
      'scanDate': '2026-05-04T16:00:00Z',
      'aiSummary':
          'Critical vulnerabilities detected in authentication and authorization layers. The Nexus API Gateway exhibits three critical-severity issues: an IDOR vulnerability exposing user data, broken session invalidation allowing persistent token reuse, and sensitive PII in JWT payloads. Combined, these create a significant data breach risk. Immediate remediation of the authentication pipeline is required before the next deployment window.',
      'topFix':
          'Invalidate session tokens server-side on logout and implement JWE for sensitive JWT claims. This single fix reduces the critical attack surface by 67%.',
      'modelUsed': 'gemini-pro',
      'findingCounts': {'critical': 2, 'high': 2, 'medium': 1, 'low': 2},
      'riskScore': 87,
      'status': 'completed',
    },
    {
      'id': 'r2',
      'scanJobId': 'j2',
      'targetName': 'Acme Corp Web',
      'scanDate': '2026-05-05T08:00:00Z',
      'aiSummary':
          'Moderate risk profile with one critical SQL injection vulnerability requiring urgent attention. The application\'s input validation is weak across multiple endpoints. The missing Content-Security-Policy and verbose error messages indicate configuration-level security debt. The SQL injection in /api/users is the most severe issue and should be treated as P0.',
      'topFix':
          'Implement parameterized queries across all database-touching endpoints. This eliminates the critical SQL injection vector and reduces overall risk score from 62 to an estimated 28.',
      'modelUsed': 'gemini-pro',
      'findingCounts': {'critical': 1, 'high': 0, 'medium': 2, 'low': 1},
      'riskScore': 62,
      'status': 'completed',
    },
    {
      'id': 'r3',
      'scanJobId': 'j4',
      'targetName': 'Vault Auth Service',
      'scanDate': '2026-05-05T07:30:00Z',
      'aiSummary':
          'Scan failed before completion due to a connection timeout. Partial results indicate a CORS misconfiguration on authenticated endpoints. A full re-scan is recommended once network connectivity to the target is restored.',
      'topFix':
          'Restrict CORS to trusted origins and re-run the scan. The partial CORS finding should be addressed regardless of scan completion status.',
      'modelUsed': 'gemini-flash',
      'findingCounts': {'critical': 0, 'high': 0, 'medium': 1, 'low': 0},
      'riskScore': 18,
      'status': 'failed',
    },
  ];

  // Aggregate severity counts across all reports
  Map<String, int> get _aggregateSeverity {
    final totals = {'critical': 0, 'high': 0, 'medium': 0, 'low': 0};
    for (final r in _reportMaps) {
      final counts = r['findingCounts'] as Map<String, dynamic>;
      totals['critical'] = totals['critical']! + (counts['critical'] as int);
      totals['high'] = totals['high']! + (counts['high'] as int);
      totals['medium'] = totals['medium']! + (counts['medium'] as int);
      totals['low'] = totals['low']! + (counts['low'] as int);
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ReportsAppBarWidget(reportCount: _reportMaps.length),
            Expanded(
              child: _isLoading
                  ? _buildSkeleton()
                  : _reportMaps.isEmpty
                  ? const EmptyStateWidget(
                      iconName: 'article',
                      title: 'No Reports Yet',
                      subtitle:
                          'Complete a scan to generate an AI-assisted security report powered by Gemini.',
                    )
                  : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: _loadReports,
      color: AppTheme.primary,
      backgroundColor: AppTheme.surfaceVariant,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Section title
                _buildSectionTitle(),
                const SizedBox(height: 12),
                // Severity donut chart — aggregate across all reports
                SeverityDonutChartWidget(severityCounts: _aggregateSeverity),
                const SizedBox(height: 16),
                // Reports section header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AI-Generated Reports',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                      child: Text(
                        '${_reportMaps.length} Reports',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Report cards
                ..._reportMaps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final report = entry.value;
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 350 + index * 80),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 24 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ReportCardWidget(
                        report: report,
                        isExpanded: _expandedReportId == report['id'],
                        onToggle: () {
                          setState(() {
                            _expandedReportId =
                                _expandedReportId == report['id']
                                ? null
                                : report['id'] as String;
                          });
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Security\n',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          TextSpan(
            text: 'Reports',
            style: TextStyle(
              color: AppTheme.primary,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          LoadingSkeletonWidget(
            width: double.infinity,
            height: 160,
            borderRadius: 14,
          ),
          const SizedBox(height: 16),
          ...List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LoadingSkeletonWidget(
                width: double.infinity,
                height: 140,
                borderRadius: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
