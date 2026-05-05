import 'dart:math';

import '../../core/app_export.dart';
import '../../data/tools_data.dart';

class ToolDetailScreen extends StatefulWidget {
  final SecurityTool tool;

  const ToolDetailScreen({super.key, required this.tool});

  @override
  State<ToolDetailScreen> createState() => _ToolDetailScreenState();
}

class _ToolDetailScreenState extends State<ToolDetailScreen>
    with TickerProviderStateMixin {
  String _selectedScanOption = '';
  final Map<String, TextEditingController> _controllers = {};
  bool _isRunning = false;
  bool _hasResults = false;
  late AnimationController _pulseController;
  late AnimationController _resultController;
  late Animation<double> _resultAnimation;
  final List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    _selectedScanOption = widget.tool.scanOptions.isNotEmpty
        ? widget.tool.scanOptions.first.id
        : '';
    for (final field in widget.tool.inputFields) {
      _controllers[field.id] = TextEditingController();
    }
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _resultController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _resultAnimation = CurvedAnimation(
      parent: _resultController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _resultController.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Color get _catColor {
    final cat = toolCategories.firstWhere(
      (c) => c.id == widget.tool.categoryId,
      orElse: () => toolCategories.first,
    );
    final h = cat.color.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  Color get _sevColor {
    switch (widget.tool.severityLevel) {
      case 'critical':
        return AppTheme.critical;
      case 'high':
        return AppTheme.high;
      case 'medium':
        return AppTheme.medium;
      case 'low':
        return AppTheme.low;
      default:
        return AppTheme.textMuted;
    }
  }

  Future<void> _runScan() async {
    final target = _controllers.values.isNotEmpty
        ? _controllers.values.first.text.trim()
        : '';
    if (target.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a target to scan',
            style: GoogleFonts.ibmPlexSans(
              color: AppTheme.textPrimary,
              fontSize: 13,
            ),
          ),
          backgroundColor: AppTheme.surfaceVariant,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isRunning = true;
      _hasResults = false;
      _results.clear();
    });

    // Simulate scan with mock results
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    final mockResults = _generateMockResults(target);
    setState(() {
      _isRunning = false;
      _hasResults = true;
      _results.addAll(mockResults);
    });
    _resultController.forward(from: 0);
  }

  List<Map<String, dynamic>> _generateMockResults(String target) {
    final rng = Random();
    final tool = widget.tool;
    final results = <Map<String, dynamic>>[];

    // Generate tool-specific mock output
    switch (tool.id) {
      case 'nmap':
        results.addAll([
          {'type': 'info', 'line': 'Starting Nmap 7.94 scan on $target'},
          {'type': 'info', 'line': 'Host is up (0.0023s latency)'},
          {'type': 'open', 'line': '22/tcp   open  ssh     OpenSSH 8.9p1'},
          {
            'type': 'open',
            'line': '80/tcp   open  http    Apache httpd 2.4.54',
          },
          {'type': 'open', 'line': '443/tcp  open  https   nginx 1.22.1'},
          {'type': 'open', 'line': '3306/tcp open  mysql   MySQL 8.0.32'},
          {
            'type': 'warn',
            'line': '8080/tcp open  http    Tomcat 9.0.71 (outdated)',
          },
          {'type': 'info', 'line': 'OS: Linux 5.15 (Ubuntu 22.04)'},
          {'type': 'done', 'line': 'Nmap done: 1 IP address scanned in 12.34s'},
        ]);
        break;
      case 'nikto':
        results.addAll([
          {'type': 'info', 'line': '- Nikto v2.1.6 — Target: $target'},
          {'type': 'warn', 'line': '+ Server: Apache/2.4.54 (Debian)'},
          {
            'type': 'vuln',
            'line': '+ OSVDB-3268: /admin/: Directory indexing found',
          },
          {
            'type': 'vuln',
            'line': '+ OSVDB-3092: /.htaccess: .htaccess file found',
          },
          {'type': 'warn', 'line': '+ X-Frame-Options header not present'},
          {'type': 'warn', 'line': '+ X-Content-Type-Options header not set'},
          {
            'type': 'vuln',
            'line': '+ CVE-2021-41773: Path traversal in Apache 2.4.49',
          },
          {'type': 'info', 'line': '+ 7 items reported on remote host'},
        ]);
        break;
      case 'sqlmap':
        results.addAll([
          {'type': 'info', 'line': 'sqlmap v1.8.3 — testing $target'},
          {'type': 'info', 'line': '[*] testing connection to target URL'},
          {
            'type': 'warn',
            'line': '[!] heuristic (basic) test shows possible SQLi',
          },
          {
            'type': 'vuln',
            'line': '[CRITICAL] GET parameter \'id\' is vulnerable',
          },
          {'type': 'vuln', 'line': 'Type: boolean-based blind'},
          {'type': 'vuln', 'line': 'Type: time-based blind'},
          {'type': 'vuln', 'line': 'Type: UNION query (3 columns)'},
          {'type': 'info', 'line': 'Database: MySQL >= 5.0.12'},
          {
            'type': 'done',
            'line': 'Available databases: [information_schema, app_db, users]',
          },
        ]);
        break;
      case 'gobuster':
        results.addAll([
          {'type': 'info', 'line': 'Gobuster v3.6 — Target: $target'},
          {
            'type': 'open',
            'line': '/admin                (Status: 301) [Size: 312]',
          },
          {
            'type': 'open',
            'line': '/api                  (Status: 200) [Size: 1024]',
          },
          {
            'type': 'open',
            'line': '/backup               (Status: 403) [Size: 287]',
          },
          {
            'type': 'warn',
            'line': '/config.php           (Status: 200) [Size: 4521]',
          },
          {
            'type': 'open',
            'line': '/login                (Status: 200) [Size: 2341]',
          },
          {
            'type': 'warn',
            'line': '/.git                 (Status: 200) [Size: 1234]',
          },
          {'type': 'done', 'line': 'Finished — 6 paths found'},
        ]);
        break;
      case 'nuclei':
        results.addAll([
          {'type': 'info', 'line': 'Nuclei v3.2.4 — scanning $target'},
          {
            'type': 'vuln',
            'line': '[critical] CVE-2021-44228 — Log4Shell RCE detected',
          },
          {'type': 'vuln', 'line': '[high] CVE-2022-22965 — Spring4Shell RCE'},
          {
            'type': 'warn',
            'line': '[medium] exposed-panels:jenkins — Jenkins panel found',
          },
          {
            'type': 'warn',
            'line': '[medium] misconfig:cors — CORS misconfiguration',
          },
          {'type': 'info', 'line': '[info] tech:nginx — nginx/1.22.1 detected'},
          {'type': 'info', 'line': '[info] tech:php — PHP/8.1.12 detected'},
          {
            'type': 'done',
            'line': 'Scan complete — 6 findings (2 critical, 2 high, 2 info)',
          },
        ]);
        break;
      default:
        final count = 4 + rng.nextInt(5);
        results.add({
          'type': 'info',
          'line': 'Starting ${tool.name} against $target...',
        });
        for (int i = 0; i < count; i++) {
          final types = ['info', 'open', 'warn', 'vuln'];
          final t = types[rng.nextInt(types.length)];
          results.add({'type': t, 'line': _mockLine(tool, t, i)});
        }
        results.add({
          'type': 'done',
          'line': '${tool.name} scan completed — $count findings',
        });
    }
    return results;
  }

  String _mockLine(SecurityTool tool, String type, int i) {
    switch (type) {
      case 'open':
        return '[+] Found: ${['service', 'endpoint', 'host', 'port'][i % 4]} — ${tool.tags.isNotEmpty ? tool.tags[i % tool.tags.length] : 'result'} detected';
      case 'warn':
        return '[!] Warning: Potential ${tool.tags.isNotEmpty ? tool.tags[i % tool.tags.length] : 'issue'} found';
      case 'vuln':
        return '[VULN] ${tool.severityLevel.toUpperCase()}: Security issue detected in target';
      default:
        return '[*] Processing ${tool.name} module $i...';
    }
  }

  Color _lineColor(String type) {
    switch (type) {
      case 'vuln':
        return AppTheme.critical;
      case 'warn':
        return AppTheme.medium;
      case 'open':
        return AppTheme.primary;
      case 'done':
        return AppTheme.accentBlue;
      default:
        return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildToolInfo(),
                    const SizedBox(height: 16),
                    _buildInputSection(),
                    const SizedBox(height: 16),
                    _buildScanOptions(),
                    const SizedBox(height: 16),
                    _buildCommandPreview(),
                    const SizedBox(height: 16),
                    _buildRunButton(),
                    if (_isRunning) ...[
                      const SizedBox(height: 16),
                      _buildRunningIndicator(),
                    ],
                    if (_hasResults) ...[
                      const SizedBox(height: 16),
                      _buildResults(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2D3548), width: 0.5),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppTheme.textSecondary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tool.name,
                  style: GoogleFonts.ibmPlexSans(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  widget.tool.platform,
                  style: GoogleFonts.ibmPlexSans(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _sevColor.withAlpha(30),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _sevColor.withAlpha(80), width: 0.5),
            ),
            child: Text(
              widget.tool.severityLevel.toUpperCase(),
              style: GoogleFonts.ibmPlexMono(
                color: _sevColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _catColor.withAlpha(60), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _catColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_catIconData(), color: _catColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tool.name,
                      style: GoogleFonts.ibmPlexSans(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'v${widget.tool.version}',
                      style: GoogleFonts.ibmPlexMono(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.tool.longDescription,
            style: GoogleFonts.ibmPlexSans(
              color: AppTheme.textSecondary,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.tool.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color(0xFF2D3548),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.ibmPlexMono(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    if (widget.tool.inputFields.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Configuration', Icons.tune_rounded),
        const SizedBox(height: 10),
        ...widget.tool.inputFields.map(
          (field) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: field.type == 'dropdown'
                ? _buildDropdownField(field)
                : _buildTextField(field),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(ToolInputField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              field.label,
              style: GoogleFonts.ibmPlexSans(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (field.required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: GoogleFonts.ibmPlexSans(
                  color: AppTheme.critical,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 5),
        TextField(
          controller: _controllers[field.id],
          style: GoogleFonts.ibmPlexMono(
            color: AppTheme.textPrimary,
            fontSize: 12,
          ),
          decoration: InputDecoration(
            hintText: field.hint,
            hintStyle: GoogleFonts.ibmPlexMono(
              color: AppTheme.textMuted,
              fontSize: 12,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(ToolInputField field) {
    final options = field.options ?? [];
    String? currentValue = _controllers[field.id]?.text.isEmpty == true
        ? null
        : _controllers[field.id]?.text;
    if (currentValue != null && !options.contains(currentValue)) {
      currentValue = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: GoogleFonts.ibmPlexSans(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2D3548), width: 0.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              hint: Text(
                field.hint,
                style: GoogleFonts.ibmPlexMono(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              ),
              isExpanded: true,
              dropdownColor: AppTheme.surfaceElevated,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              style: GoogleFonts.ibmPlexMono(
                color: AppTheme.textPrimary,
                fontSize: 12,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppTheme.textMuted,
                size: 18,
              ),
              items: options
                  .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _controllers[field.id]?.text = val);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanOptions() {
    if (widget.tool.scanOptions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Scan Type', Icons.radar_rounded),
        const SizedBox(height: 10),
        ...widget.tool.scanOptions.map((opt) {
          final isSelected = _selectedScanOption == opt.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedScanOption = opt.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? _catColor.withAlpha(20)
                    : AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? _catColor.withAlpha(120)
                      : const Color(0xFF2D3548),
                  width: isSelected ? 1 : 0.5,
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? _catColor : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? _catColor : AppTheme.textMuted,
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.black,
                            size: 10,
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opt.label,
                          style: GoogleFonts.ibmPlexSans(
                            color: isSelected
                                ? AppTheme.textPrimary
                                : AppTheme.textSecondary,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        Text(
                          opt.description,
                          style: GoogleFonts.ibmPlexSans(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCommandPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Command Preview', Icons.terminal_rounded),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0E17),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF1E2433), width: 0.5),
          ),
          child: Text(
            widget.tool.commandExample,
            style: GoogleFonts.ibmPlexMono(
              color: AppTheme.primary,
              fontSize: 11,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRunButton() {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: _isRunning ? null : _runScan,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale = _isRunning
                ? 1.0 + (_pulseController.value * 0.02)
                : 1.0;
            return Transform.scale(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isRunning
                        ? [
                            AppTheme.medium.withAlpha(200),
                            AppTheme.medium.withAlpha(150),
                          ]
                        : [AppTheme.primary, const Color(0xFF00CC6A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (_isRunning ? AppTheme.medium : AppTheme.primary)
                          .withAlpha(60),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isRunning) ...[
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black.withAlpha(180),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Scanning...',
                        style: GoogleFonts.ibmPlexSans(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Run ${widget.tool.name}',
                        style: GoogleFonts.ibmPlexSans(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRunningIndicator() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.medium.withAlpha(80), width: 0.5),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) => Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.medium.withAlpha(
                  (100 + (_pulseController.value * 155)).toInt(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Running ${widget.tool.name} scan... Please wait',
              style: GoogleFonts.ibmPlexSans(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final vulnCount = _results.where((r) => r['type'] == 'vuln').length;
    final warnCount = _results.where((r) => r['type'] == 'warn').length;
    final openCount = _results.where((r) => r['type'] == 'open').length;

    return FadeTransition(
      opacity: _resultAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Scan Results', Icons.assessment_rounded),
          const SizedBox(height: 10),
          // Summary row
          Row(
            children: [
              _resultBadge('$vulnCount Vulns', AppTheme.critical),
              const SizedBox(width: 8),
              _resultBadge('$warnCount Warnings', AppTheme.medium),
              const SizedBox(width: 8),
              _resultBadge('$openCount Found', AppTheme.primary),
            ],
          ),
          const SizedBox(height: 10),
          // Terminal output
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF060910),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E2433), width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Terminal title bar
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.critical,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.medium,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${widget.tool.name.toLowerCase()} — output',
                      style: GoogleFonts.ibmPlexMono(
                        color: AppTheme.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: Color(0xFF1E2433), height: 1),
                const SizedBox(height: 10),
                ..._results.map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      r['line'] as String,
                      style: GoogleFonts.ibmPlexMono(
                        color: _lineColor(r['type'] as String),
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Export button
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Results exported to findings',
                          style: GoogleFonts.ibmPlexSans(
                            color: AppTheme.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                        backgroundColor: AppTheme.surfaceVariant,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF2D3548),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.save_alt_rounded,
                          color: AppTheme.textSecondary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Export to Findings',
                          style: GoogleFonts.ibmPlexSans(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _hasResults = false;
                    _results.clear();
                  });
                  _runScan();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryMuted,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.primary.withAlpha(80),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.refresh_rounded,
                        color: AppTheme.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Re-scan',
                        style: GoogleFonts.ibmPlexSans(
                          color: AppTheme.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resultBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withAlpha(80), width: 0.5),
      ),
      child: Text(
        label,
        style: GoogleFonts.ibmPlexSans(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _catColor, size: 14),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  IconData _catIconData() {
    final cat = toolCategories.firstWhere(
      (c) => c.id == widget.tool.categoryId,
      orElse: () => toolCategories.first,
    );
    switch (cat.icon) {
      case 'wifi_tethering':
        return Icons.wifi_tethering_rounded;
      case 'language':
        return Icons.language_rounded;
      case 'bug_report':
        return Icons.bug_report_rounded;
      case 'lock_open':
        return Icons.lock_open_rounded;
      case 'wifi':
        return Icons.wifi_rounded;
      case 'search':
        return Icons.search_rounded;
      case 'swap_horiz':
        return Icons.swap_horiz_rounded;
      case 'security':
        return Icons.security_rounded;
      case 'fingerprint':
        return Icons.fingerprint_rounded;
      default:
        return Icons.terminal_rounded;
    }
  }
}
