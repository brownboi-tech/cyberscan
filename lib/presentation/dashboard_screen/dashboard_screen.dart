
import '../../core/app_export.dart';
import './widgets/ai_insight_card_widget.dart';
import './widgets/dashboard_appbar_widget.dart';
import './widgets/kpi_grid_widget.dart';
import './widgets/recent_scan_jobs_widget.dart';
import './widgets/scan_activity_chart_widget.dart';

// TODO: Replace with Riverpod/Bloc for production

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  // Domain models — map-first pattern
  late List<Map<String, dynamic>> _scanJobMaps;
  late List<Map<String, dynamic>> _findingMaps;
  late List<Map<String, dynamic>> _targetMaps;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    // TODO: Replace with real API call — CyberScanRepository.getScanJobs()
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _scanJobMaps = _mockScanJobs;
      _findingMaps = _mockFindings;
      _targetMaps = _mockTargets;
    });
  }

  // ── Mock data ──────────────────────────────────────────────
  final List<Map<String, dynamic>> _mockTargets = [
    {
      'id': 't1',
      'name': 'Acme Corp Web',
      'url': 'https://acme.test',
      'createdAt': '2026-05-01T09:00:00Z',
    },
    {
      'id': 't2',
      'name': 'Nexus API Gateway',
      'url': 'https://api.nexus.internal',
      'createdAt': '2026-05-03T11:00:00Z',
    },
    {
      'id': 't3',
      'name': 'Vault Auth Service',
      'url': 'https://auth.vault.io',
      'createdAt': '2026-05-04T14:00:00Z',
    },
  ];

  final List<Map<String, dynamic>> _mockScanJobs = [
    {
      'id': 'j1',
      'targetId': 't1',
      'targetName': 'Acme Corp Web',
      'status': 'running',
      'startedAt': '2026-05-05T10:00:00Z',
      'severitySummary': {'critical': 1, 'high': 2, 'medium': 3, 'low': 1},
    },
    {
      'id': 'j2',
      'targetId': 't1',
      'targetName': 'Acme Corp Web',
      'status': 'completed',
      'startedAt': '2026-05-05T08:00:00Z',
      'severitySummary': {'critical': 0, 'high': 1, 'medium': 2, 'low': 4},
    },
    {
      'id': 'j3',
      'targetId': 't2',
      'targetName': 'Nexus API Gateway',
      'status': 'queued',
      'startedAt': '2026-05-05T10:45:00Z',
      'severitySummary': {'critical': 0, 'high': 0, 'medium': 0, 'low': 0},
    },
    {
      'id': 'j4',
      'targetId': 't3',
      'targetName': 'Vault Auth Service',
      'status': 'failed',
      'startedAt': '2026-05-05T07:30:00Z',
      'severitySummary': {'critical': 0, 'high': 0, 'medium': 1, 'low': 0},
    },
    {
      'id': 'j5',
      'targetId': 't2',
      'targetName': 'Nexus API Gateway',
      'status': 'completed',
      'startedAt': '2026-05-04T16:00:00Z',
      'severitySummary': {'critical': 2, 'high': 3, 'medium': 1, 'low': 2},
    },
  ];

  final List<Map<String, dynamic>> _mockFindings = [
    {
      'id': 'f1',
      'scanJobId': 'j2',
      'title': 'SQL Injection',
      'severity': 'critical',
      'summary': 'Unsanitized query parameter in /api/users endpoint',
      'remediation': 'Use parameterized queries',
    },
    {
      'id': 'f2',
      'scanJobId': 'j2',
      'title': 'Missing CSP Header',
      'severity': 'medium',
      'summary': 'No Content-Security-Policy header detected',
      'remediation': 'Add a strict Content-Security-Policy',
    },
    {
      'id': 'f3',
      'scanJobId': 'j5',
      'title': 'Insecure Direct Object Reference',
      'severity': 'critical',
      'summary': 'User IDs exposed in API response without auth check',
      'remediation': 'Implement proper authorization checks',
    },
    {
      'id': 'f4',
      'scanJobId': 'j5',
      'title': 'Broken Authentication',
      'severity': 'critical',
      'summary': 'Session tokens not invalidated on logout',
      'remediation': 'Invalidate tokens server-side on logout',
    },
    {
      'id': 'f5',
      'scanJobId': 'j5',
      'title': 'Outdated TLS Version',
      'severity': 'high',
      'summary': 'Server supports TLS 1.0 and 1.1',
      'remediation': 'Disable TLS 1.0/1.1, enforce TLS 1.2+',
    },
    {
      'id': 'f6',
      'scanJobId': 'j1',
      'title': 'Open Redirect',
      'severity': 'high',
      'summary': 'Redirect URL parameter not validated',
      'remediation': 'Whitelist allowed redirect destinations',
    },
    {
      'id': 'f7',
      'scanJobId': 'j2',
      'title': 'Verbose Error Messages',
      'severity': 'low',
      'summary': 'Stack traces exposed in 500 responses',
      'remediation': 'Configure custom error pages',
    },
  ];

  // ── Computed metrics ────────────────────────────────────────
  int get _activeCount =>
      _scanJobMaps.where((j) => j['status'] == 'running').length;
  int get _queuedCount =>
      _scanJobMaps.where((j) => j['status'] == 'queued').length;
  int get _completedCount =>
      _scanJobMaps.where((j) => j['status'] == 'completed').length;
  int get _criticalCount =>
      _findingMaps.where((f) => f['severity'] == 'critical').length;

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 0,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            DashboardAppBarWidget(
              onNotificationTap: () {},
              onAnalyticsTap: () {},
            ),
            Expanded(
              child: _isLoading
                  ? const DashboardSkeletonWidget()
                  : _hasError
                  ? _buildErrorState()
                  : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppTheme.primary,
      backgroundColor: AppTheme.surfaceVariant,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Title — from Image 2 skeleton: large title below AppBar
                _buildTitle(),
                const SizedBox(height: 16),

                // KPI 2×2 grid — from Image 2 two-column stat cards pattern
                KpiGridWidget(
                  activeCount: _activeCount,
                  queuedCount: _queuedCount,
                  completedCount: _completedCount,
                  criticalCount: _criticalCount,
                ),
                const SizedBox(height: 12),

                // AI insight hero card — from Image 2 AIAnalysisCard anatomy
                AiInsightCardWidget(
                  urgentCount: _criticalCount + _activeCount,
                  totalFindings: _findingMaps.length,
                ),
                const SizedBox(height: 12),

                // Bar chart — scan activity
                ScanActivityChartWidget(scanJobs: _scanJobMaps),
                const SizedBox(height: 12),

                // Recent scan jobs list
                RecentScanJobsWidget(
                  scanJobs: _scanJobMaps,
                  targets: _targetMaps,
                ),
                // Bottom padding for nav bar
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
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
            text: 'Dashboard',
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

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: AppTheme.textMuted,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              "Couldn't load dashboard",
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Pull down to try again or check your connection.",
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.primary, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
