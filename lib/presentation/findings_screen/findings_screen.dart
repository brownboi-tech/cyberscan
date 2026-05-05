
import '../../core/app_export.dart';
import './widgets/finding_card_widget.dart';
import './widgets/findings_appbar_widget.dart';
import './widgets/findings_filter_widget.dart';
import './widgets/findings_section_header_widget.dart';

// TODO: Replace with Riverpod/Bloc for production

class FindingsScreen extends StatefulWidget {
  const FindingsScreen({super.key});

  @override
  State<FindingsScreen> createState() => _FindingsScreenState();
}

class _FindingsScreenState extends State<FindingsScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  String _activeFilter = 'All';
  final Set<String> _collapsedSections = {};

  late List<Map<String, dynamic>> _allFindings;
  late AnimationController _listAnimController;

  final List<String> _filters = ['All', 'Critical', 'High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    _listAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadFindings();
  }

  @override
  void dispose() {
    _listAnimController.dispose();
    super.dispose();
  }

  Future<void> _loadFindings() async {
    setState(() => _isLoading = true);
    // TODO: Replace with CyberScanRepository.getFindings()
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _allFindings = _mockFindingMaps;
    });
    _listAnimController.forward(from: 0);
  }

  // ── Mock data (map-first) ──────────────────────────────────
  final List<Map<String, dynamic>> _mockFindingMaps = [
    {
      'id': 'f1',
      'scanJobId': 'j2',
      'targetName': 'Acme Corp Web',
      'title': 'SQL Injection via /api/users',
      'severity': 'critical',
      'summary':
          'Unsanitized query parameter allows arbitrary SQL execution in the /api/users endpoint. Attacker can dump entire user table.',
      'remediation':
          'Use parameterized queries or prepared statements. Validate and sanitize all user-supplied input before database operations.',
      'category': 'Injection',
      'cve': 'CVE-2023-1234',
    },
    {
      'id': 'f3',
      'scanJobId': 'j5',
      'targetName': 'Nexus API Gateway',
      'title': 'Insecure Direct Object Reference',
      'severity': 'critical',
      'summary':
          'User IDs exposed in API response without proper authorization check. Any authenticated user can access other users\' data.',
      'remediation':
          'Implement proper authorization checks. Use indirect references or UUIDs instead of sequential IDs.',
      'category': 'Access Control',
      'cve': null,
    },
    {
      'id': 'f4',
      'scanJobId': 'j5',
      'targetName': 'Nexus API Gateway',
      'title': 'Broken Authentication — Token Persistence',
      'severity': 'critical',
      'summary':
          'Session tokens are not invalidated server-side on logout. Captured tokens remain valid indefinitely.',
      'remediation':
          'Maintain a server-side token blocklist. Implement short token TTLs with refresh token rotation.',
      'category': 'Authentication',
      'cve': 'CVE-2024-5678',
    },
    {
      'id': 'f5',
      'scanJobId': 'j5',
      'targetName': 'Nexus API Gateway',
      'title': 'TLS 1.0/1.1 Enabled',
      'severity': 'high',
      'summary':
          'Server accepts TLS 1.0 and 1.1 connections which are vulnerable to BEAST and POODLE attacks.',
      'remediation':
          'Disable TLS 1.0 and 1.1 in server configuration. Enforce TLS 1.2 minimum, prefer TLS 1.3.',
      'category': 'Cryptography',
      'cve': null,
    },
    {
      'id': 'f6',
      'scanJobId': 'j1',
      'targetName': 'Acme Corp Web',
      'title': 'Open Redirect on Login Callback',
      'severity': 'high',
      'summary':
          'The redirect_uri parameter on the OAuth callback is not validated against an allowlist. Enables phishing via redirect.',
      'remediation':
          'Whitelist allowed redirect destinations. Reject or encode any redirect URL not matching the allowlist.',
      'category': 'Input Validation',
      'cve': null,
    },
    {
      'id': 'f8',
      'scanJobId': 'j5',
      'targetName': 'Nexus API Gateway',
      'title': 'Sensitive Data in JWT Payload',
      'severity': 'high',
      'summary':
          'JWT tokens contain PII (email, role, internal user ID) in the unencrypted payload. Base64 decode reveals sensitive data.',
      'remediation':
          'Move sensitive claims out of JWT payload. Use opaque tokens or encrypt the payload with JWE.',
      'category': 'Cryptography',
      'cve': null,
    },
    {
      'id': 'f2',
      'scanJobId': 'j2',
      'targetName': 'Acme Corp Web',
      'title': 'Missing Content-Security-Policy',
      'severity': 'medium',
      'summary':
          'No CSP header detected on any response. This leaves the application vulnerable to XSS and data injection attacks.',
      'remediation':
          'Add a strict Content-Security-Policy header. Start with default-src \'self\' and incrementally add required sources.',
      'category': 'Headers',
      'cve': null,
    },
    {
      'id': 'f9',
      'scanJobId': 'j1',
      'targetName': 'Acme Corp Web',
      'title': 'Missing X-Frame-Options',
      'severity': 'medium',
      'summary':
          'No X-Frame-Options or frame-ancestors CSP directive. Application can be embedded in iframes enabling clickjacking.',
      'remediation':
          'Add X-Frame-Options: DENY or use frame-ancestors \'none\' in CSP.',
      'category': 'Headers',
      'cve': null,
    },
    {
      'id': 'f10',
      'scanJobId': 'j4',
      'targetName': 'Vault Auth Service',
      'title': 'CORS Wildcard Origin',
      'severity': 'medium',
      'summary':
          'Access-Control-Allow-Origin: * is set on authenticated endpoints, allowing any origin to make credentialed requests.',
      'remediation':
          'Restrict CORS to specific trusted origins. Never combine wildcard origin with Allow-Credentials: true.',
      'category': 'Configuration',
      'cve': null,
    },
    {
      'id': 'f7',
      'scanJobId': 'j2',
      'targetName': 'Acme Corp Web',
      'title': 'Verbose Error Messages',
      'severity': 'low',
      'summary':
          'Stack traces and internal file paths are exposed in HTTP 500 responses, revealing implementation details.',
      'remediation':
          'Configure custom error pages. Log detailed errors server-side only. Return generic messages to clients.',
      'category': 'Information Disclosure',
      'cve': null,
    },
    {
      'id': 'f11',
      'scanJobId': 'j5',
      'targetName': 'Nexus API Gateway',
      'title': 'Missing Rate Limiting on Auth Endpoints',
      'severity': 'low',
      'summary':
          'No rate limiting detected on /auth/login. Allows brute-force password attacks without throttling.',
      'remediation':
          'Implement rate limiting (e.g. 5 attempts per minute per IP). Add CAPTCHA after repeated failures.',
      'category': 'Configuration',
      'cve': null,
    },
  ];

  List<Map<String, dynamic>> get _filteredFindings {
    if (_activeFilter == 'All') return _allFindings;
    return _allFindings
        .where(
          (f) =>
              (f['severity'] as String).toLowerCase() ==
              _activeFilter.toLowerCase(),
        )
        .toList();
  }

  Map<String, List<Map<String, dynamic>>> get _groupedFindings {
    final groups = <String, List<Map<String, dynamic>>>{};
    for (final severity in ['critical', 'high', 'medium', 'low']) {
      final items = _filteredFindings
          .where((f) => (f['severity'] as String).toLowerCase() == severity)
          .toList();
      if (items.isNotEmpty) {
        groups[severity] = items;
      }
    }
    return groups;
  }

  void _toggleSection(String severity) {
    setState(() {
      if (_collapsedSections.contains(severity)) {
        _collapsedSections.remove(severity);
      } else {
        _collapsedSections.add(severity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            FindingsAppBarWidget(totalCount: _allFindings.length),
            FindingsFilterWidget(
              filters: _filters,
              activeFilter: _activeFilter,
              onFilterChanged: (f) => setState(() => _activeFilter = f),
            ),
            Expanded(
              child: _isLoading
                  ? _buildSkeleton()
                  : _filteredFindings.isEmpty
                  ? EmptyStateWidget(
                      iconName: 'bug_report',
                      title: 'No Findings Found',
                      subtitle:
                          'No findings match the current filter. Run a scan to discover vulnerabilities.',
                      ctaLabel: 'View All Findings',
                      onCta: () => setState(() => _activeFilter = 'All'),
                    )
                  : _buildFindingsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFindingsList() {
    final groups = _groupedFindings;
    final sectionKeys = groups.keys.toList();

    return RefreshIndicator(
      onRefresh: _loadFindings,
      color: AppTheme.primary,
      backgroundColor: AppTheme.surfaceVariant,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: sectionKeys.fold<int>(0, (sum, key) {
          final isCollapsed = _collapsedSections.contains(key);
          return sum + 1 + (isCollapsed ? 0 : groups[key]!.length);
        }),
        itemBuilder: (context, index) {
          int offset = 0;
          for (final severity in sectionKeys) {
            final items = groups[severity]!;
            final isCollapsed = _collapsedSections.contains(severity);

            if (index == offset) {
              return FindingsSectionHeaderWidget(
                severity: severity,
                count: items.length,
                isCollapsed: isCollapsed,
                onToggle: () => _toggleSection(severity),
              );
            }
            offset++;

            if (!isCollapsed) {
              for (int i = 0; i < items.length; i++) {
                if (index == offset + i) {
                  return _buildAnimatedFindingCard(items[i], offset + i);
                }
              }
              offset += items.length;
            }
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAnimatedFindingCard(Map<String, dynamic> finding, int index) {
    final delay = (index * 40).clamp(0, 300);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: FindingCardWidget(finding: finding),
    );
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: List.generate(
          6,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: LoadingSkeletonWidget(
              width: double.infinity,
              height: 88,
              borderRadius: 12,
            ),
          ),
        ),
      ),
    );
  }
}
