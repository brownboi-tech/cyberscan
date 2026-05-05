// Tools data model — 50 security/pentesting tools organized by category

class ToolCategory {
  final String id;
  final String name;
  final String icon;
  final String color;

  const ToolCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class ScanOption {
  final String id;
  final String label;
  final String description;

  const ScanOption({
    required this.id,
    required this.label,
    required this.description,
  });
}

class ToolInputField {
  final String id;
  final String label;
  final String hint;
  final String type; // text, dropdown, checkbox
  final List<String>? options;
  final bool required;

  const ToolInputField({
    required this.id,
    required this.label,
    required this.hint,
    this.type = 'text',
    this.options,
    this.required = false,
  });
}

class SecurityTool {
  final String id;
  final String name;
  final String categoryId;
  final String description;
  final String longDescription;
  final String version;
  final String platform;
  final List<String> tags;
  final List<ToolInputField> inputFields;
  final List<ScanOption> scanOptions;
  final String severityLevel; // info, low, medium, high, critical
  final String commandExample;

  const SecurityTool({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.longDescription,
    required this.version,
    required this.platform,
    required this.tags,
    required this.inputFields,
    required this.scanOptions,
    required this.severityLevel,
    required this.commandExample,
  });
}

// ── Categories ──────────────────────────────────────────────────────────────

const List<ToolCategory> toolCategories = [
  ToolCategory(id: 'all', name: 'All Tools', icon: 'apps', color: '#00FF88'),
  ToolCategory(
    id: 'network',
    name: 'Network Scanning',
    icon: 'wifi_tethering',
    color: '#3B82F6',
  ),
  ToolCategory(
    id: 'webapp',
    name: 'Web App Testing',
    icon: 'language',
    color: '#FF6B35',
  ),
  ToolCategory(
    id: 'exploitation',
    name: 'Exploitation',
    icon: 'bug_report',
    color: '#FF3B30',
  ),
  ToolCategory(
    id: 'password',
    name: 'Password & Creds',
    icon: 'lock_open',
    color: '#FFB800',
  ),
  ToolCategory(
    id: 'wireless',
    name: 'Wireless',
    icon: 'wifi',
    color: '#8B5CF6',
  ),
  ToolCategory(
    id: 'recon',
    name: 'Reconnaissance',
    icon: 'search',
    color: '#00FF88',
  ),
  ToolCategory(
    id: 'traffic',
    name: 'Traffic & MITM',
    icon: 'swap_horiz',
    color: '#06B6D4',
  ),
  ToolCategory(
    id: 'vuln',
    name: 'Vulnerability',
    icon: 'security',
    color: '#F59E0B',
  ),
  ToolCategory(
    id: 'forensics',
    name: 'Forensics & Misc',
    icon: 'fingerprint',
    color: '#EC4899',
  ),
];

// ── All 50 Tools ─────────────────────────────────────────────────────────────

const List<SecurityTool> allTools = [
  // ── NETWORK SCANNING (5) ──────────────────────────────────────────────────
  SecurityTool(
    id: 'nmap',
    name: 'Nmap',
    categoryId: 'network',
    description: 'Network exploration and security auditing tool',
    longDescription:
        'Nmap ("Network Mapper") is a free and open source utility for network discovery and security auditing. It uses raw IP packets to determine hosts, services, OS, firewalls, and more.',
    version: '7.94',
    platform: 'Linux/Windows/macOS',
    tags: ['port-scan', 'service-detection', 'os-fingerprint', 'network'],
    severityLevel: 'high',
    commandExample: 'nmap -sV -sC -p- 192.168.1.1',
    inputFields: [
      ToolInputField(
        id: 'target',
        label: 'Target IP / Range',
        hint: '192.168.1.0/24 or hostname',
        required: true,
      ),
      ToolInputField(
        id: 'ports',
        label: 'Port Range',
        hint: '1-65535 or 80,443,8080',
      ),
      ToolInputField(
        id: 'timing',
        label: 'Timing Template',
        hint: 'T1-T5',
        type: 'dropdown',
        options: [
          'T1 (Sneaky)',
          'T2 (Polite)',
          'T3 (Normal)',
          'T4 (Aggressive)',
          'T5 (Insane)',
        ],
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'syn',
        label: 'SYN Scan (-sS)',
        description: 'Stealthy half-open TCP scan',
      ),
      ScanOption(
        id: 'version',
        label: 'Version Detection (-sV)',
        description: 'Detect service versions',
      ),
      ScanOption(
        id: 'script',
        label: 'Default Scripts (-sC)',
        description: 'Run default NSE scripts',
      ),
      ScanOption(
        id: 'os',
        label: 'OS Detection (-O)',
        description: 'Identify operating system',
      ),
      ScanOption(
        id: 'udp',
        label: 'UDP Scan (-sU)',
        description: 'Scan UDP ports',
      ),
    ],
  ),
  SecurityTool(
    id: 'masscan',
    name: 'Masscan',
    categoryId: 'network',
    description: 'Internet-scale port scanner — fastest in the world',
    longDescription:
        'Masscan is an Internet-scale port scanner capable of scanning the entire Internet in under 6 minutes. It produces results similar to Nmap but is optimized for speed using asynchronous transmission.',
    version: '1.3.2',
    platform: 'Linux/Windows',
    tags: ['port-scan', 'fast-scan', 'network', 'internet-scale'],
    severityLevel: 'high',
    commandExample: 'masscan -p1-65535 10.0.0.0/8 --rate=10000',
    inputFields: [
      ToolInputField(
        id: 'target',
        label: 'Target IP / CIDR',
        hint: '10.0.0.0/8',
        required: true,
      ),
      ToolInputField(id: 'ports', label: 'Port Range', hint: '1-65535'),
      ToolInputField(
        id: 'rate',
        label: 'Packet Rate',
        hint: '10000 (packets/sec)',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'full',
        label: 'Full Port Scan',
        description: 'Scan all 65535 ports',
      ),
      ScanOption(
        id: 'top100',
        label: 'Top 100 Ports',
        description: 'Scan most common ports',
      ),
      ScanOption(
        id: 'banner',
        label: 'Banner Grab',
        description: 'Grab service banners',
      ),
    ],
  ),
  SecurityTool(
    id: 'zmap',
    name: 'ZMap',
    categoryId: 'network',
    description: 'Single-packet network scanner for Internet-wide surveys',
    longDescription:
        'ZMap is a fast single-packet network scanner designed for Internet-wide network surveys. It can scan the entire IPv4 address space in under 45 minutes on a gigabit network.',
    version: '3.0.0',
    platform: 'Linux',
    tags: ['port-scan', 'internet-survey', 'network'],
    severityLevel: 'medium',
    commandExample: 'zmap -p 443 -o results.csv 0.0.0.0/0',
    inputFields: [
      ToolInputField(
        id: 'target',
        label: 'Target Network',
        hint: '0.0.0.0/0 or subnet',
        required: true,
      ),
      ToolInputField(
        id: 'port',
        label: 'Target Port',
        hint: '443',
        required: true,
      ),
      ToolInputField(
        id: 'bandwidth',
        label: 'Bandwidth Limit',
        hint: '10M or 1G',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'tcp',
        label: 'TCP SYN Probe',
        description: 'Standard TCP SYN scan',
      ),
      ScanOption(id: 'icmp', label: 'ICMP Echo', description: 'Ping sweep'),
      ScanOption(id: 'udp', label: 'UDP Probe', description: 'UDP port scan'),
    ],
  ),
  SecurityTool(
    id: 'netdiscover',
    name: 'Netdiscover',
    categoryId: 'network',
    description: 'Active/passive ARP reconnaissance tool',
    longDescription:
        'Netdiscover is an active/passive ARP reconnaissance tool, initially developed to gain information about wireless networks without DHCP servers in wardriving scenarios.',
    version: '0.10',
    platform: 'Linux',
    tags: ['arp', 'host-discovery', 'network', 'wireless'],
    severityLevel: 'low',
    commandExample: 'netdiscover -r 192.168.1.0/24 -i eth0',
    inputFields: [
      ToolInputField(
        id: 'range',
        label: 'IP Range',
        hint: '192.168.1.0/24',
        required: true,
      ),
      ToolInputField(
        id: 'interface',
        label: 'Interface',
        hint: 'eth0 or wlan0',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'active',
        label: 'Active Mode',
        description: 'Send ARP requests',
      ),
      ScanOption(
        id: 'passive',
        label: 'Passive Mode',
        description: 'Listen for ARP traffic only',
      ),
    ],
  ),
  SecurityTool(
    id: 'angryip',
    name: 'Angry IP Scanner',
    categoryId: 'network',
    description: 'Fast and friendly network scanner',
    longDescription:
        'Angry IP Scanner is a fast and friendly network scanner. It pings each IP address to check if it\'s alive, then optionally resolves its hostname, determines the MAC address, scans ports, etc.',
    version: '3.9.1',
    platform: 'Linux/Windows/macOS',
    tags: ['ping-sweep', 'host-discovery', 'port-scan', 'network'],
    severityLevel: 'low',
    commandExample: 'ipscan 192.168.1.1-192.168.1.254 -p 22,80,443',
    inputFields: [
      ToolInputField(
        id: 'range',
        label: 'IP Range',
        hint: '192.168.1.1-192.168.1.254',
        required: true,
      ),
      ToolInputField(
        id: 'ports',
        label: 'Ports to Scan',
        hint: '22,80,443,8080',
      ),
      ToolInputField(id: 'threads', label: 'Thread Count', hint: '100'),
    ],
    scanOptions: [
      ScanOption(
        id: 'ping',
        label: 'Ping Sweep',
        description: 'Check host availability',
      ),
      ScanOption(
        id: 'ports',
        label: 'Port Scan',
        description: 'Scan specified ports',
      ),
      ScanOption(
        id: 'hostname',
        label: 'Hostname Resolution',
        description: 'Resolve hostnames',
      ),
    ],
  ),

  // ── WEB APP TESTING (10) ──────────────────────────────────────────────────
  SecurityTool(
    id: 'nikto',
    name: 'Nikto',
    categoryId: 'webapp',
    description: 'Web server scanner for dangerous files and misconfigurations',
    longDescription:
        'Nikto is an open source web server scanner which performs comprehensive tests against web servers for multiple items, including over 6700 potentially dangerous files/programs, checks for outdated versions, and server configuration issues.',
    version: '2.1.6',
    platform: 'Linux/Windows/macOS',
    tags: ['web-scan', 'vulnerability', 'misconfiguration', 'headers'],
    severityLevel: 'high',
    commandExample: 'nikto -h https://target.com -ssl -Tuning 1234',
    inputFields: [
      ToolInputField(
        id: 'host',
        label: 'Target Host/URL',
        hint: 'https://target.com',
        required: true,
      ),
      ToolInputField(id: 'port', label: 'Port', hint: '443'),
      ToolInputField(
        id: 'tuning',
        label: 'Tuning Options',
        hint: '1-9 (test categories)',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'ssl',
        label: 'SSL/TLS Scan',
        description: 'Test HTTPS endpoints',
      ),
      ScanOption(
        id: 'headers',
        label: 'Header Analysis',
        description: 'Check security headers',
      ),
      ScanOption(
        id: 'files',
        label: 'Dangerous Files',
        description: 'Check for sensitive files',
      ),
      ScanOption(
        id: 'cgi',
        label: 'CGI Directories',
        description: 'Test CGI scripts',
      ),
    ],
  ),
  SecurityTool(
    id: 'dirb',
    name: 'Dirb',
    categoryId: 'webapp',
    description: 'Web content scanner using dictionary-based attacks',
    longDescription:
        'DIRB is a Web Content Scanner. It looks for existing (and/or hidden) Web Objects. It basically works by launching a dictionary-based attack against a web server and analyzing the responses.',
    version: '2.22',
    platform: 'Linux',
    tags: ['directory-brute', 'web-scan', 'content-discovery'],
    severityLevel: 'medium',
    commandExample:
        'dirb https://target.com /usr/share/dirb/wordlists/common.txt',
    inputFields: [
      ToolInputField(
        id: 'url',
        label: 'Target URL',
        hint: 'https://target.com',
        required: true,
      ),
      ToolInputField(
        id: 'wordlist',
        label: 'Wordlist',
        hint: '/usr/share/dirb/wordlists/common.txt',
      ),
      ToolInputField(
        id: 'extensions',
        label: 'Extensions',
        hint: 'php,html,txt',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'recursive',
        label: 'Recursive Scan',
        description: 'Scan subdirectories recursively',
      ),
      ScanOption(
        id: 'silent',
        label: 'Silent Mode',
        description: 'Only show found paths',
      ),
      ScanOption(
        id: 'nowarning',
        label: 'No Warnings',
        description: 'Suppress warning messages',
      ),
    ],
  ),
  SecurityTool(
    id: 'gobuster',
    name: 'Gobuster',
    categoryId: 'webapp',
    description: 'Directory/file & DNS busting tool written in Go',
    longDescription:
        'Gobuster is a tool used to brute-force URIs (directories and files) in web sites, DNS subdomains, virtual host names on target web servers, Open Amazon S3 buckets, and more.',
    version: '3.6.0',
    platform: 'Linux/Windows/macOS',
    tags: ['directory-brute', 'dns-enum', 'vhost', 'web-scan'],
    severityLevel: 'medium',
    commandExample:
        'gobuster dir -u https://target.com -w /usr/share/wordlists/dirb/common.txt',
    inputFields: [
      ToolInputField(
        id: 'url',
        label: 'Target URL',
        hint: 'https://target.com',
        required: true,
      ),
      ToolInputField(
        id: 'wordlist',
        label: 'Wordlist Path',
        hint: '/usr/share/wordlists/dirb/common.txt',
        required: true,
      ),
      ToolInputField(id: 'threads', label: 'Threads', hint: '50'),
      ToolInputField(
        id: 'extensions',
        label: 'Extensions',
        hint: 'php,html,js',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'dir',
        label: 'Directory Mode',
        description: 'Brute-force directories/files',
      ),
      ScanOption(
        id: 'dns',
        label: 'DNS Mode',
        description: 'Enumerate DNS subdomains',
      ),
      ScanOption(
        id: 'vhost',
        label: 'VHost Mode',
        description: 'Enumerate virtual hosts',
      ),
      ScanOption(
        id: 's3',
        label: 'S3 Mode',
        description: 'Enumerate S3 buckets',
      ),
    ],
  ),
  SecurityTool(
    id: 'dirbuster',
    name: 'DirBuster',
    categoryId: 'webapp',
    description:
        'Multi-threaded Java application for brute-forcing web directories',
    longDescription:
        'DirBuster is a multi-threaded Java application designed to brute force directories and files names on web/application servers. It comes with a list of 9 different lists.',
    version: '1.0-RC1',
    platform: 'Linux/Windows/macOS (Java)',
    tags: ['directory-brute', 'web-scan', 'java'],
    severityLevel: 'medium',
    commandExample:
        'java -jar DirBuster.jar -u https://target.com -l wordlist.txt',
    inputFields: [
      ToolInputField(
        id: 'url',
        label: 'Target URL',
        hint: 'https://target.com',
        required: true,
      ),
      ToolInputField(
        id: 'wordlist',
        label: 'Wordlist',
        hint: 'directory-list-2.3-medium.txt',
      ),
      ToolInputField(id: 'threads', label: 'Threads', hint: '20'),
    ],
    scanOptions: [
      ScanOption(
        id: 'pure',
        label: 'Pure Brute Force',
        description: 'Generate all combinations',
      ),
      ScanOption(
        id: 'list',
        label: 'List-Based',
        description: 'Use wordlist file',
      ),
      ScanOption(
        id: 'recursive',
        label: 'Recursive',
        description: 'Scan found directories',
      ),
    ],
  ),
  SecurityTool(
    id: 'wpscan',
    name: 'WPScan',
    categoryId: 'webapp',
    description: 'WordPress vulnerability scanner',
    longDescription:
        'WPScan is a free, for non-commercial use, black box WordPress security scanner written for security professionals and blog maintainers to test the security of their WordPress websites.',
    version: '3.8.25',
    platform: 'Linux/macOS',
    tags: ['wordpress', 'cms-scan', 'plugin-vuln', 'web-scan'],
    severityLevel: 'high',
    commandExample: 'wpscan --url https://target.com --enumerate u,p,t',
    inputFields: [
      ToolInputField(
        id: 'url',
        label: 'WordPress URL',
        hint: 'https://target.com',
        required: true,
      ),
      ToolInputField(
        id: 'apitoken',
        label: 'WPScan API Token',
        hint: 'Optional — for vuln DB',
      ),
      ToolInputField(
        id: 'enumerate',
        label: 'Enumerate',
        hint: 'u (users), p (plugins), t (themes)',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'passive',
        label: 'Passive Detection',
        description: 'Non-intrusive scan',
      ),
      ScanOption(
        id: 'aggressive',
        label: 'Aggressive Detection',
        description: 'Full plugin/theme enumeration',
      ),
      ScanOption(
        id: 'users',
        label: 'User Enumeration',
        description: 'Enumerate WordPress users',
      ),
      ScanOption(
        id: 'passwords',
        label: 'Password Attack',
        description: 'Brute-force user passwords',
      ),
    ],
  ),
  SecurityTool(
    id: 'sqlmap',
    name: 'SQLmap',
    categoryId: 'webapp',
    description: 'Automatic SQL injection and database takeover tool',
    longDescription:
        'SQLmap is an open source penetration testing tool that automates the process of detecting and exploiting SQL injection flaws and taking over database servers.',
    version: '1.8.3',
    platform: 'Linux/Windows/macOS',
    tags: ['sql-injection', 'database', 'exploitation', 'web-scan'],
    severityLevel: 'critical',
    commandExample: 'sqlmap -u "https://target.com/page?id=1" --dbs --batch',
    inputFields: [
      ToolInputField(
        id: 'url',
        label: 'Target URL',
        hint: 'https://target.com/page?id=1',
        required: true,
      ),
      ToolInputField(
        id: 'data',
        label: 'POST Data',
        hint: 'username=test&password=test',
      ),
      ToolInputField(id: 'cookie', label: 'Cookie', hint: 'PHPSESSID=abc123'),
      ToolInputField(
        id: 'level',
        label: 'Test Level',
        hint: '1-5',
        type: 'dropdown',
        options: ['1 (Default)', '2', '3', '4', '5 (Max)'],
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'dbs',
        label: 'Enumerate Databases',
        description: 'List all databases',
      ),
      ScanOption(
        id: 'tables',
        label: 'Enumerate Tables',
        description: 'List tables in database',
      ),
      ScanOption(
        id: 'dump',
        label: 'Dump Data',
        description: 'Extract table contents',
      ),
      ScanOption(
        id: 'os-shell',
        label: 'OS Shell',
        description: 'Attempt OS command execution',
      ),
    ],
  ),
  SecurityTool(
    id: 'xsstrike',
    name: 'XSStrike',
    categoryId: 'webapp',
    description: 'Advanced XSS detection suite with fuzzing and crawling',
    longDescription:
        'XSStrike is a Cross Site Scripting detection suite equipped with four hand written parsers, an intelligent payload generator, a powerful fuzzing engine and an incredibly fast crawler.',
    version: '3.1.5',
    platform: 'Linux/macOS',
    tags: ['xss', 'cross-site-scripting', 'fuzzing', 'web-scan'],
    severityLevel: 'high',
    commandExample: 'python3 xsstrike.py -u "https://target.com/search?q=test"',
    inputFields: [
      ToolInputField(
        id: 'url',
        label: 'Target URL',
        hint: 'https://target.com/search?q=test',
        required: true,
      ),
      ToolInputField(id: 'data', label: 'POST Data', hint: 'param=value'),
      ToolInputField(id: 'threads', label: 'Threads', hint: '10'),
    ],
    scanOptions: [
      ScanOption(
        id: 'crawl',
        label: 'Crawl Mode',
        description: 'Crawl and test all links',
      ),
      ScanOption(
        id: 'blind',
        label: 'Blind XSS',
        description: 'Test for blind XSS',
      ),
      ScanOption(
        id: 'fuzzer',
        label: 'Fuzzer Mode',
        description: 'Fuzz parameters',
      ),
    ],
  ),
  SecurityTool(
    id: 'wfuzz',
    name: 'Wfuzz',
    categoryId: 'webapp',
    description: 'Web application fuzzer for brute-forcing parameters',
    longDescription:
        'Wfuzz is a tool designed for brute-forcing Web Applications. It can be used for finding resources not linked (directories, servlets, scripts, etc.), brute-force GET and POST parameters for checking different kinds of injections.',
    version: '3.1.0',
    platform: 'Linux/macOS',
    tags: ['fuzzing', 'brute-force', 'web-scan', 'parameter-testing'],
    severityLevel: 'medium',
    commandExample:
        'wfuzz -c -z file,wordlist.txt --hc 404 https://target.com/FUZZ',
    inputFields: [
      ToolInputField(
        id: 'url',
        label: 'Target URL (use FUZZ)',
        hint: 'https://target.com/FUZZ',
        required: true,
      ),
      ToolInputField(
        id: 'wordlist',
        label: 'Wordlist',
        hint: '/usr/share/wordlists/dirb/common.txt',
      ),
      ToolInputField(id: 'hc', label: 'Hide Status Codes', hint: '404,403'),
    ],
    scanOptions: [
      ScanOption(
        id: 'dir',
        label: 'Directory Fuzzing',
        description: 'Fuzz directory paths',
      ),
      ScanOption(
        id: 'param',
        label: 'Parameter Fuzzing',
        description: 'Fuzz GET/POST params',
      ),
      ScanOption(
        id: 'header',
        label: 'Header Fuzzing',
        description: 'Fuzz HTTP headers',
      ),
    ],
  ),
  SecurityTool(
    id: 'ffuf',
    name: 'Ffuf',
    categoryId: 'webapp',
    description: 'Fast web fuzzer written in Go',
    longDescription:
        'Ffuf (Fuzz Faster U Fool) is a fast web fuzzer written in Go. It is used for web application fuzzing, directory discovery, parameter fuzzing, and virtual host discovery.',
    version: '2.1.0',
    platform: 'Linux/Windows/macOS',
    tags: ['fuzzing', 'directory-brute', 'web-scan', 'fast'],
    severityLevel: 'medium',
    commandExample:
        'ffuf -w wordlist.txt -u https://target.com/FUZZ -mc 200,301',
    inputFields: [
      ToolInputField(
        id: 'url',
        label: 'Target URL (use FUZZ)',
        hint: 'https://target.com/FUZZ',
        required: true,
      ),
      ToolInputField(
        id: 'wordlist',
        label: 'Wordlist',
        hint: '/usr/share/wordlists/dirb/common.txt',
        required: true,
      ),
      ToolInputField(
        id: 'mc',
        label: 'Match Status Codes',
        hint: '200,301,302',
      ),
      ToolInputField(id: 'threads', label: 'Threads', hint: '40'),
    ],
    scanOptions: [
      ScanOption(
        id: 'dir',
        label: 'Directory Mode',
        description: 'Discover directories',
      ),
      ScanOption(
        id: 'vhost',
        label: 'VHost Mode',
        description: 'Discover virtual hosts',
      ),
      ScanOption(
        id: 'param',
        label: 'Parameter Mode',
        description: 'Fuzz parameters',
      ),
    ],
  ),
  SecurityTool(
    id: 'arjun',
    name: 'Arjun',
    categoryId: 'webapp',
    description: 'HTTP parameter discovery suite',
    longDescription:
        'Arjun can find query parameters for URL endpoints. It uses a large wordlist of 25,890 parameter names and uses heuristics to detect changes in the response to identify valid parameters.',
    version: '2.2.1',
    platform: 'Linux/macOS',
    tags: ['parameter-discovery', 'web-scan', 'api-testing'],
    severityLevel: 'medium',
    commandExample: 'arjun -u https://target.com/api/endpoint --get',
    inputFields: [
      ToolInputField(
        id: 'url',
        label: 'Target URL',
        hint: 'https://target.com/api/endpoint',
        required: true,
      ),
      ToolInputField(
        id: 'wordlist',
        label: 'Custom Wordlist',
        hint: 'Optional custom params list',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'get',
        label: 'GET Parameters',
        description: 'Discover GET params',
      ),
      ScanOption(
        id: 'post',
        label: 'POST Parameters',
        description: 'Discover POST params',
      ),
      ScanOption(
        id: 'json',
        label: 'JSON Parameters',
        description: 'Discover JSON body params',
      ),
      ScanOption(
        id: 'xml',
        label: 'XML Parameters',
        description: 'Discover XML params',
      ),
    ],
  ),

  // ── EXPLOITATION (4) ─────────────────────────────────────────────────────
  SecurityTool(
    id: 'metasploit',
    name: 'Metasploit MSF',
    categoryId: 'exploitation',
    description: 'World\'s most used penetration testing framework',
    longDescription:
        'The Metasploit Framework is the world\'s most used penetration testing software. It helps security teams do more than just verify vulnerabilities, manage security assessments, and improve security awareness.',
    version: '6.3.44',
    platform: 'Linux/Windows/macOS',
    tags: ['exploitation', 'payloads', 'post-exploitation', 'framework'],
    severityLevel: 'critical',
    commandExample:
        'msfconsole -x "use exploit/multi/handler; set PAYLOAD windows/meterpreter/reverse_tcp"',
    inputFields: [
      ToolInputField(
        id: 'module',
        label: 'Module Path',
        hint: 'exploit/multi/handler',
        required: true,
      ),
      ToolInputField(
        id: 'rhost',
        label: 'RHOST (Target)',
        hint: '192.168.1.100',
      ),
      ToolInputField(id: 'lhost', label: 'LHOST (Local)', hint: '192.168.1.50'),
      ToolInputField(id: 'lport', label: 'LPORT', hint: '4444'),
    ],
    scanOptions: [
      ScanOption(
        id: 'exploit',
        label: 'Exploit Module',
        description: 'Run exploit against target',
      ),
      ScanOption(
        id: 'auxiliary',
        label: 'Auxiliary Module',
        description: 'Run auxiliary/scanner',
      ),
      ScanOption(
        id: 'post',
        label: 'Post Module',
        description: 'Post-exploitation module',
      ),
      ScanOption(
        id: 'payload',
        label: 'Payload Generator',
        description: 'Generate shellcode payload',
      ),
    ],
  ),
  SecurityTool(
    id: 'searchsploit',
    name: 'SearchSploit',
    categoryId: 'exploitation',
    description: 'Command-line search tool for Exploit-DB',
    longDescription:
        'SearchSploit is a command line search tool for Exploit-DB that also allows you to take a copy of Exploit Database with you, everywhere you go. It is part of the exploitdb package.',
    version: '4.4.3',
    platform: 'Linux',
    tags: ['exploit-db', 'cve-search', 'vulnerability-research'],
    severityLevel: 'high',
    commandExample: 'searchsploit apache 2.4 --www',
    inputFields: [
      ToolInputField(
        id: 'query',
        label: 'Search Query',
        hint: 'apache 2.4 or CVE-2021-41773',
        required: true,
      ),
      ToolInputField(
        id: 'type',
        label: 'Type Filter',
        hint: 'webapps, remote, local',
        type: 'dropdown',
        options: ['All', 'webapps', 'remote', 'local', 'dos'],
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'exact',
        label: 'Exact Match',
        description: 'Search for exact term',
      ),
      ScanOption(
        id: 'cve',
        label: 'CVE Search',
        description: 'Search by CVE ID',
      ),
      ScanOption(
        id: 'www',
        label: 'Web Output',
        description: 'Open in browser',
      ),
    ],
  ),
  SecurityTool(
    id: 'beef',
    name: 'BeEF',
    categoryId: 'exploitation',
    description: 'Browser Exploitation Framework for client-side attacks',
    longDescription:
        'BeEF (Browser Exploitation Framework) is a penetration testing tool that focuses on the web browser. It allows the penetration tester to assess the actual security posture of a target environment using client-side attack vectors.',
    version: '0.5.4.0',
    platform: 'Linux/macOS',
    tags: ['browser-exploit', 'xss', 'client-side', 'hook'],
    severityLevel: 'critical',
    commandExample: 'beef-xss --config /etc/beef-xss/config.yaml',
    inputFields: [
      ToolInputField(
        id: 'hookurl',
        label: 'Hook URL',
        hint: 'http://attacker.com:3000/hook.js',
      ),
      ToolInputField(
        id: 'target',
        label: 'Target Browser',
        hint: 'Hooked browser IP',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'network',
        label: 'Network Discovery',
        description: 'Discover internal network',
      ),
      ScanOption(
        id: 'social',
        label: 'Social Engineering',
        description: 'Phishing modules',
      ),
      ScanOption(
        id: 'browser',
        label: 'Browser Fingerprint',
        description: 'Fingerprint browser/OS',
      ),
    ],
  ),
  SecurityTool(
    id: 'commix',
    name: 'Commix',
    categoryId: 'exploitation',
    description: 'Automated command injection and exploitation tool',
    longDescription:
        'Commix (Command Injection Exploiter) is an automated tool written in Python that can be used from web developers, penetration testers or even security researchers to test web-based applications with the view to find bugs, errors or vulnerabilities related to command injection attacks.',
    version: '3.9',
    platform: 'Linux/macOS',
    tags: ['command-injection', 'exploitation', 'web-scan'],
    severityLevel: 'critical',
    commandExample:
        'python3 commix.py --url="https://target.com/page?param=INJECT_HERE"',
    inputFields: [
      ToolInputField(
        id: 'url',
        label: 'Target URL',
        hint: 'https://target.com/page?param=INJECT_HERE',
        required: true,
      ),
      ToolInputField(id: 'data', label: 'POST Data', hint: 'param=INJECT_HERE'),
      ToolInputField(id: 'cookie', label: 'Cookie', hint: 'session=abc123'),
    ],
    scanOptions: [
      ScanOption(
        id: 'classic',
        label: 'Classic Injection',
        description: 'Classic command injection',
      ),
      ScanOption(
        id: 'blind',
        label: 'Blind Injection',
        description: 'Time-based blind injection',
      ),
      ScanOption(
        id: 'file',
        label: 'File-Based',
        description: 'File-based injection',
      ),
    ],
  ),

  // ── PASSWORD & CREDENTIALS (6) ────────────────────────────────────────────
  SecurityTool(
    id: 'hydra',
    name: 'Hydra',
    categoryId: 'password',
    description: 'Fast and flexible online password cracking tool',
    longDescription:
        'Hydra is a parallelized login cracker which supports numerous protocols including FTP, HTTP, HTTPS, SMB, several databases, LDAP, and more. It is very fast and flexible, and new modules are easy to add.',
    version: '9.5',
    platform: 'Linux/Windows/macOS',
    tags: ['brute-force', 'password-crack', 'online-attack', 'multi-protocol'],
    severityLevel: 'critical',
    commandExample:
        'hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://192.168.1.1',
    inputFields: [
      ToolInputField(
        id: 'target',
        label: 'Target Host',
        hint: '192.168.1.1',
        required: true,
      ),
      ToolInputField(
        id: 'service',
        label: 'Service/Protocol',
        hint: 'ssh, ftp, http-post-form',
        type: 'dropdown',
        options: [
          'ssh',
          'ftp',
          'http-post-form',
          'https-post-form',
          'smb',
          'rdp',
          'mysql',
          'mssql',
          'telnet',
        ],
      ),
      ToolInputField(
        id: 'username',
        label: 'Username / List',
        hint: 'admin or /path/to/users.txt',
      ),
      ToolInputField(
        id: 'password',
        label: 'Password List',
        hint: '/usr/share/wordlists/rockyou.txt',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'single',
        label: 'Single Username',
        description: 'Attack with one username',
      ),
      ScanOption(
        id: 'userlist',
        label: 'Username List',
        description: 'Attack with username list',
      ),
      ScanOption(
        id: 'verbose',
        label: 'Verbose Mode',
        description: 'Show all attempts',
      ),
    ],
  ),
  SecurityTool(
    id: 'medusa',
    name: 'Medusa',
    categoryId: 'password',
    description: 'Speedy, massively parallel, modular login brute-forcer',
    longDescription:
        'Medusa is intended to be a speedy, massively parallel, modular, login brute-forcer. The goal is to support as many services which allow remote authentication as possible.',
    version: '2.2',
    platform: 'Linux',
    tags: ['brute-force', 'password-crack', 'parallel', 'multi-protocol'],
    severityLevel: 'critical',
    commandExample: 'medusa -h 192.168.1.1 -u admin -P rockyou.txt -M ssh',
    inputFields: [
      ToolInputField(
        id: 'host',
        label: 'Target Host',
        hint: '192.168.1.1',
        required: true,
      ),
      ToolInputField(
        id: 'module',
        label: 'Module',
        hint: 'ssh, ftp, http',
        type: 'dropdown',
        options: [
          'ssh',
          'ftp',
          'http',
          'https',
          'smb',
          'mysql',
          'mssql',
          'rdp',
          'telnet',
          'vnc',
        ],
      ),
      ToolInputField(id: 'username', label: 'Username', hint: 'admin'),
      ToolInputField(
        id: 'passlist',
        label: 'Password List',
        hint: '/usr/share/wordlists/rockyou.txt',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'parallel',
        label: 'Parallel Attack',
        description: 'Multiple simultaneous connections',
      ),
      ScanOption(
        id: 'resume',
        label: 'Resume Attack',
        description: 'Resume previous session',
      ),
    ],
  ),
  SecurityTool(
    id: 'john',
    name: 'John the Ripper',
    categoryId: 'password',
    description: 'Fast password cracker for offline hash cracking',
    longDescription:
        'John the Ripper is a fast password cracker, currently available for many flavors of Unix, Windows, DOS, and OpenVMS. Its primary purpose is to detect weak Unix passwords.',
    version: '1.9.0-jumbo-1',
    platform: 'Linux/Windows/macOS',
    tags: ['hash-crack', 'offline-attack', 'password-crack', 'wordlist'],
    severityLevel: 'high',
    commandExample:
        'john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt',
    inputFields: [
      ToolInputField(
        id: 'hashfile',
        label: 'Hash File',
        hint: '/path/to/hashes.txt',
        required: true,
      ),
      ToolInputField(
        id: 'wordlist',
        label: 'Wordlist',
        hint: '/usr/share/wordlists/rockyou.txt',
      ),
      ToolInputField(
        id: 'format',
        label: 'Hash Format',
        hint: 'md5, sha256, bcrypt',
        type: 'dropdown',
        options: [
          'auto-detect',
          'md5',
          'sha1',
          'sha256',
          'sha512',
          'bcrypt',
          'ntlm',
          'lm',
          'md5crypt',
        ],
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'wordlist',
        label: 'Wordlist Mode',
        description: 'Dictionary attack',
      ),
      ScanOption(
        id: 'incremental',
        label: 'Incremental Mode',
        description: 'Brute-force all combinations',
      ),
      ScanOption(
        id: 'rules',
        label: 'Rules Mode',
        description: 'Apply mangling rules',
      ),
      ScanOption(
        id: 'show',
        label: 'Show Cracked',
        description: 'Display cracked passwords',
      ),
    ],
  ),
  SecurityTool(
    id: 'hashcat',
    name: 'Hashcat',
    categoryId: 'password',
    description: 'World\'s fastest GPU-based password recovery tool',
    longDescription:
        'Hashcat is the world\'s fastest and most advanced password recovery utility, supporting five unique modes of attack for over 300 highly-optimized hashing algorithms.',
    version: '6.2.6',
    platform: 'Linux/Windows/macOS',
    tags: ['hash-crack', 'gpu-crack', 'password-recovery', 'offline-attack'],
    severityLevel: 'high',
    commandExample:
        'hashcat -m 0 -a 0 hashes.txt /usr/share/wordlists/rockyou.txt',
    inputFields: [
      ToolInputField(
        id: 'hashfile',
        label: 'Hash File',
        hint: '/path/to/hashes.txt',
        required: true,
      ),
      ToolInputField(
        id: 'hashtype',
        label: 'Hash Type (-m)',
        hint: '0=MD5, 1000=NTLM, 1800=sha512crypt',
        type: 'dropdown',
        options: [
          '0 (MD5)',
          '100 (SHA1)',
          '1000 (NTLM)',
          '1400 (SHA256)',
          '1800 (sha512crypt)',
          '3200 (bcrypt)',
          '5500 (NetNTLMv1)',
          '5600 (NetNTLMv2)',
        ],
      ),
      ToolInputField(
        id: 'wordlist',
        label: 'Wordlist / Mask',
        hint: '/usr/share/wordlists/rockyou.txt',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'dict',
        label: 'Dictionary Attack',
        description: 'Wordlist-based attack',
      ),
      ScanOption(
        id: 'combinator',
        label: 'Combinator Attack',
        description: 'Combine two wordlists',
      ),
      ScanOption(
        id: 'brute',
        label: 'Brute-Force',
        description: 'Try all combinations',
      ),
      ScanOption(
        id: 'hybrid',
        label: 'Hybrid Attack',
        description: 'Wordlist + mask',
      ),
    ],
  ),
  SecurityTool(
    id: 'cewl',
    name: 'CeWL',
    categoryId: 'password',
    description: 'Custom wordlist generator by spidering target websites',
    longDescription:
        'CeWL is a ruby app which spiders a given URL to a specified depth, optionally following external links, and returns a list of words which can then be used for password crackers.',
    version: '6.1',
    platform: 'Linux/macOS',
    tags: ['wordlist-gen', 'osint', 'password-crack', 'spider'],
    severityLevel: 'low',
    commandExample: 'cewl https://target.com -d 3 -m 8 -w wordlist.txt',
    inputFields: [
      ToolInputField(
        id: 'url',
        label: 'Target URL',
        hint: 'https://target.com',
        required: true,
      ),
      ToolInputField(id: 'depth', label: 'Spider Depth', hint: '3'),
      ToolInputField(id: 'minlength', label: 'Min Word Length', hint: '8'),
      ToolInputField(id: 'output', label: 'Output File', hint: 'wordlist.txt'),
    ],
    scanOptions: [
      ScanOption(
        id: 'email',
        label: 'Extract Emails',
        description: 'Collect email addresses',
      ),
      ScanOption(
        id: 'meta',
        label: 'Extract Metadata',
        description: 'Parse document metadata',
      ),
      ScanOption(
        id: 'lowercase',
        label: 'Lowercase',
        description: 'Convert words to lowercase',
      ),
    ],
  ),
  SecurityTool(
    id: 'crunch',
    name: 'Crunch',
    categoryId: 'password',
    description: 'Wordlist generator based on character sets and patterns',
    longDescription:
        'Crunch is a wordlist generator where you can specify a standard character set or a character set you specify. Crunch can generate all possible combinations and permutations.',
    version: '3.6',
    platform: 'Linux',
    tags: ['wordlist-gen', 'brute-force', 'password-crack'],
    severityLevel: 'low',
    commandExample:
        'crunch 8 12 abcdefghijklmnopqrstuvwxyz0123456789 -o wordlist.txt',
    inputFields: [
      ToolInputField(
        id: 'minlen',
        label: 'Min Length',
        hint: '8',
        required: true,
      ),
      ToolInputField(
        id: 'maxlen',
        label: 'Max Length',
        hint: '12',
        required: true,
      ),
      ToolInputField(
        id: 'charset',
        label: 'Character Set',
        hint: 'abcdefghijklmnopqrstuvwxyz0123456789',
      ),
      ToolInputField(
        id: 'pattern',
        label: 'Pattern',
        hint: '@@@-%%%% (@ = lower, % = digit)',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'standard',
        label: 'Standard Generation',
        description: 'All combinations of charset',
      ),
      ScanOption(
        id: 'pattern',
        label: 'Pattern Mode',
        description: 'Generate from pattern',
      ),
      ScanOption(
        id: 'permutation',
        label: 'Permutation',
        description: 'All permutations of charset',
      ),
    ],
  ),

  // ── WIRELESS (4) ─────────────────────────────────────────────────────────
  SecurityTool(
    id: 'aircrack',
    name: 'Aircrack-ng',
    categoryId: 'wireless',
    description: 'Complete suite for 802.11 WEP/WPA/WPA2 cracking',
    longDescription:
        'Aircrack-ng is a complete suite of tools to assess WiFi network security. It focuses on different areas of WiFi security: monitoring, attacking, testing, and cracking.',
    version: '1.7',
    platform: 'Linux/Windows/macOS',
    tags: ['wifi', 'wpa-crack', 'wep-crack', 'wireless', 'handshake'],
    severityLevel: 'critical',
    commandExample:
        'aircrack-ng -w /usr/share/wordlists/rockyou.txt capture.cap',
    inputFields: [
      ToolInputField(
        id: 'capfile',
        label: 'Capture File (.cap)',
        hint: '/path/to/capture.cap',
        required: true,
      ),
      ToolInputField(
        id: 'wordlist',
        label: 'Wordlist',
        hint: '/usr/share/wordlists/rockyou.txt',
      ),
      ToolInputField(
        id: 'bssid',
        label: 'BSSID (AP MAC)',
        hint: 'AA:BB:CC:DD:EE:FF',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'wpa',
        label: 'WPA/WPA2 Crack',
        description: 'Crack WPA handshake',
      ),
      ScanOption(
        id: 'wep',
        label: 'WEP Crack',
        description: 'Crack WEP encryption',
      ),
      ScanOption(
        id: 'pmkid',
        label: 'PMKID Attack',
        description: 'Clientless WPA attack',
      ),
    ],
  ),
  SecurityTool(
    id: 'reaver',
    name: 'Reaver',
    categoryId: 'wireless',
    description: 'WPS PIN brute-force attack tool',
    longDescription:
        'Reaver implements a brute force attack against WiFi Protected Setup (WPS) registrar PINs in order to recover WPA/WPA2 passphrases.',
    version: '1.6.5',
    platform: 'Linux',
    tags: ['wps', 'wifi', 'brute-force', 'wireless'],
    severityLevel: 'critical',
    commandExample: 'reaver -i wlan0mon -b AA:BB:CC:DD:EE:FF -vv',
    inputFields: [
      ToolInputField(
        id: 'interface',
        label: 'Monitor Interface',
        hint: 'wlan0mon',
        required: true,
      ),
      ToolInputField(
        id: 'bssid',
        label: 'Target BSSID',
        hint: 'AA:BB:CC:DD:EE:FF',
        required: true,
      ),
      ToolInputField(id: 'channel', label: 'Channel', hint: '6'),
    ],
    scanOptions: [
      ScanOption(
        id: 'standard',
        label: 'Standard Attack',
        description: 'Full WPS PIN brute-force',
      ),
      ScanOption(
        id: 'pixie',
        label: 'Pixie Dust Attack',
        description: 'Offline WPS attack',
      ),
      ScanOption(
        id: 'delay',
        label: 'Delayed Attack',
        description: 'Add delay between attempts',
      ),
    ],
  ),
  SecurityTool(
    id: 'kismet',
    name: 'Kismet',
    categoryId: 'wireless',
    description: 'Wireless network detector, sniffer, and IDS',
    longDescription:
        'Kismet is a wireless network and device detector, sniffer, wardriving tool, and WIDS (wireless intrusion detection) framework. It works with Wi-Fi interfaces, Bluetooth interfaces, and more.',
    version: '2023-07-R1',
    platform: 'Linux/macOS',
    tags: ['wifi', 'bluetooth', 'sniffer', 'ids', 'wardriving'],
    severityLevel: 'medium',
    commandExample: 'kismet -c wlan0 --no-ncurses',
    inputFields: [
      ToolInputField(
        id: 'interface',
        label: 'Capture Interface',
        hint: 'wlan0',
        required: true,
      ),
      ToolInputField(id: 'logprefix', label: 'Log Prefix', hint: 'kismet_scan'),
    ],
    scanOptions: [
      ScanOption(
        id: 'passive',
        label: 'Passive Monitoring',
        description: 'Listen without transmitting',
      ),
      ScanOption(
        id: 'gps',
        label: 'GPS Logging',
        description: 'Log GPS coordinates',
      ),
      ScanOption(
        id: 'bluetooth',
        label: 'Bluetooth Scan',
        description: 'Detect Bluetooth devices',
      ),
    ],
  ),
  SecurityTool(
    id: 'wifite',
    name: 'Wifite',
    categoryId: 'wireless',
    description: 'Automated wireless auditing tool',
    longDescription:
        'Wifite is an automated wireless attack tool. It is designed to be used with Kali Linux and is used to attack multiple WEP, WPA, and WPS encrypted networks in a row.',
    version: '2.7.0',
    platform: 'Linux',
    tags: ['wifi', 'automated', 'wpa-crack', 'wep-crack', 'wireless'],
    severityLevel: 'critical',
    commandExample: 'wifite --wpa --dict /usr/share/wordlists/rockyou.txt',
    inputFields: [
      ToolInputField(
        id: 'interface',
        label: 'Wireless Interface',
        hint: 'wlan0',
      ),
      ToolInputField(
        id: 'wordlist',
        label: 'Wordlist',
        hint: '/usr/share/wordlists/rockyou.txt',
      ),
      ToolInputField(
        id: 'bssid',
        label: 'Target BSSID',
        hint: 'AA:BB:CC:DD:EE:FF (optional)',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'wpa',
        label: 'WPA/WPA2 Only',
        description: 'Target WPA networks',
      ),
      ScanOption(
        id: 'wep',
        label: 'WEP Only',
        description: 'Target WEP networks',
      ),
      ScanOption(
        id: 'wps',
        label: 'WPS Only',
        description: 'Target WPS-enabled APs',
      ),
      ScanOption(
        id: 'all',
        label: 'All Networks',
        description: 'Attack all found networks',
      ),
    ],
  ),

  // ── RECONNAISSANCE (8) ───────────────────────────────────────────────────
  SecurityTool(
    id: 'maltego',
    name: 'Maltego',
    categoryId: 'recon',
    description: 'Visual link analysis and OSINT investigation platform',
    longDescription:
        'Maltego is an open source intelligence (OSINT) and graphical link analysis tool for gathering and connecting information for investigative tasks. It provides a visual representation of relationships between entities.',
    version: '4.7.0',
    platform: 'Linux/Windows/macOS',
    tags: ['osint', 'link-analysis', 'visualization', 'recon'],
    severityLevel: 'medium',
    commandExample: 'maltego (GUI application)',
    inputFields: [
      ToolInputField(
        id: 'entity',
        label: 'Starting Entity',
        hint: 'domain.com or email@domain.com',
        required: true,
      ),
      ToolInputField(
        id: 'transform',
        label: 'Transform Set',
        hint: 'DNS, Whois, Social Media',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'domain',
        label: 'Domain Investigation',
        description: 'Investigate domain entities',
      ),
      ScanOption(
        id: 'person',
        label: 'Person Investigation',
        description: 'Investigate person entities',
      ),
      ScanOption(
        id: 'ip',
        label: 'IP Investigation',
        description: 'Investigate IP addresses',
      ),
    ],
  ),
  SecurityTool(
    id: 'theharvester',
    name: 'theHarvester',
    categoryId: 'recon',
    description: 'Email, subdomain, and name harvester from public sources',
    longDescription:
        'theHarvester is a simple to use, yet powerful and effective tool designed to be used in the early stages of a penetration test. Use it for open source intelligence (OSINT) gathering to help determine a company\'s external threat landscape.',
    version: '4.4.3',
    platform: 'Linux/macOS',
    tags: ['osint', 'email-harvest', 'subdomain-enum', 'recon'],
    severityLevel: 'low',
    commandExample: 'theHarvester -d target.com -b google,bing,linkedin -l 500',
    inputFields: [
      ToolInputField(
        id: 'domain',
        label: 'Target Domain',
        hint: 'target.com',
        required: true,
      ),
      ToolInputField(
        id: 'sources',
        label: 'Data Sources',
        hint: 'google,bing,linkedin,shodan',
      ),
      ToolInputField(id: 'limit', label: 'Result Limit', hint: '500'),
    ],
    scanOptions: [
      ScanOption(
        id: 'emails',
        label: 'Email Harvest',
        description: 'Collect email addresses',
      ),
      ScanOption(
        id: 'subdomains',
        label: 'Subdomain Enum',
        description: 'Find subdomains',
      ),
      ScanOption(
        id: 'hosts',
        label: 'Host Discovery',
        description: 'Discover related hosts',
      ),
      ScanOption(
        id: 'virtual',
        label: 'Virtual Hosts',
        description: 'Find virtual hosts',
      ),
    ],
  ),
  SecurityTool(
    id: 'reconng',
    name: 'Recon-ng',
    categoryId: 'recon',
    description: 'Full-featured web reconnaissance framework',
    longDescription:
        'Recon-ng is a full-featured reconnaissance framework designed with the goal of providing a powerful environment to conduct open source web-based reconnaissance quickly and thoroughly.',
    version: '5.1.2',
    platform: 'Linux/macOS',
    tags: ['osint', 'recon', 'framework', 'web-recon'],
    severityLevel: 'medium',
    commandExample: 'recon-ng -w workspace -m recon/domains-hosts/hackertarget',
    inputFields: [
      ToolInputField(
        id: 'workspace',
        label: 'Workspace Name',
        hint: 'my_recon',
        required: true,
      ),
      ToolInputField(
        id: 'module',
        label: 'Module',
        hint: 'recon/domains-hosts/hackertarget',
      ),
      ToolInputField(id: 'source', label: 'Source Domain', hint: 'target.com'),
    ],
    scanOptions: [
      ScanOption(
        id: 'domains',
        label: 'Domain Recon',
        description: 'Enumerate domain info',
      ),
      ScanOption(
        id: 'contacts',
        label: 'Contact Recon',
        description: 'Find contacts/emails',
      ),
      ScanOption(
        id: 'hosts',
        label: 'Host Recon',
        description: 'Discover hosts',
      ),
    ],
  ),
  SecurityTool(
    id: 'shodan',
    name: 'Shodan',
    categoryId: 'recon',
    description: 'Search engine for Internet-connected devices',
    longDescription:
        'Shodan is a search engine for Internet-connected devices. It lets you find specific types of computers (routers, servers, IoT devices) using a variety of filters and provides detailed information about them.',
    version: 'API v1',
    platform: 'Web/CLI',
    tags: ['osint', 'iot', 'internet-scan', 'recon', 'search-engine'],
    severityLevel: 'medium',
    commandExample: 'shodan search "apache 2.4" --fields ip_str,port,org',
    inputFields: [
      ToolInputField(
        id: 'query',
        label: 'Search Query',
        hint: 'apache 2.4 country:US',
        required: true,
      ),
      ToolInputField(
        id: 'apikey',
        label: 'Shodan API Key',
        hint: 'Your Shodan API key',
      ),
      ToolInputField(id: 'limit', label: 'Result Limit', hint: '100'),
    ],
    scanOptions: [
      ScanOption(
        id: 'search',
        label: 'Search Query',
        description: 'Search Shodan database',
      ),
      ScanOption(
        id: 'host',
        label: 'Host Lookup',
        description: 'Get info on specific IP',
      ),
      ScanOption(
        id: 'scan',
        label: 'On-Demand Scan',
        description: 'Trigger Shodan scan',
      ),
    ],
  ),
  SecurityTool(
    id: 'dnsrecon',
    name: 'DNSrecon',
    categoryId: 'recon',
    description: 'DNS enumeration and reconnaissance script',
    longDescription:
        'DNSrecon is a Python script that provides the ability to perform DNS enumeration including standard record enumeration, zone transfer attempts, reverse lookups, and more.',
    version: '1.1.4',
    platform: 'Linux/macOS',
    tags: ['dns', 'subdomain-enum', 'zone-transfer', 'recon'],
    severityLevel: 'low',
    commandExample: 'dnsrecon -d target.com -t axfr,std,brt',
    inputFields: [
      ToolInputField(
        id: 'domain',
        label: 'Target Domain',
        hint: 'target.com',
        required: true,
      ),
      ToolInputField(
        id: 'nameserver',
        label: 'Nameserver',
        hint: '8.8.8.8 (optional)',
      ),
      ToolInputField(
        id: 'wordlist',
        label: 'Brute-Force Wordlist',
        hint: '/usr/share/dnsrecon/namelist.txt',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'std',
        label: 'Standard Enum',
        description: 'Standard DNS record enumeration',
      ),
      ScanOption(
        id: 'axfr',
        label: 'Zone Transfer',
        description: 'Attempt DNS zone transfer',
      ),
      ScanOption(
        id: 'brt',
        label: 'Brute Force',
        description: 'Brute-force subdomains',
      ),
      ScanOption(
        id: 'reverse',
        label: 'Reverse Lookup',
        description: 'Reverse DNS lookups',
      ),
    ],
  ),
  SecurityTool(
    id: 'subfinder',
    name: 'Subfinder',
    categoryId: 'recon',
    description: 'Fast passive subdomain enumeration tool',
    longDescription:
        'Subfinder is a subdomain discovery tool that discovers valid subdomains for websites by using passive online sources. It has a simple modular architecture and is optimized for speed.',
    version: '2.6.3',
    platform: 'Linux/Windows/macOS',
    tags: ['subdomain-enum', 'passive-recon', 'osint', 'recon'],
    severityLevel: 'low',
    commandExample: 'subfinder -d target.com -all -recursive -o subdomains.txt',
    inputFields: [
      ToolInputField(
        id: 'domain',
        label: 'Target Domain',
        hint: 'target.com',
        required: true,
      ),
      ToolInputField(
        id: 'output',
        label: 'Output File',
        hint: 'subdomains.txt',
      ),
      ToolInputField(
        id: 'sources',
        label: 'Sources',
        hint: 'all or specific sources',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'passive',
        label: 'Passive Only',
        description: 'Use only passive sources',
      ),
      ScanOption(
        id: 'recursive',
        label: 'Recursive',
        description: 'Recursively find subdomains',
      ),
      ScanOption(
        id: 'resolve',
        label: 'Resolve IPs',
        description: 'Resolve found subdomains',
      ),
    ],
  ),
  SecurityTool(
    id: 'amass',
    name: 'Amass',
    categoryId: 'recon',
    description: 'In-depth attack surface mapping and asset discovery',
    longDescription:
        'The OWASP Amass Project performs network mapping of attack surfaces and external asset discovery using open source information gathering and active reconnaissance techniques.',
    version: '4.2.0',
    platform: 'Linux/Windows/macOS',
    tags: ['attack-surface', 'subdomain-enum', 'osint', 'recon'],
    severityLevel: 'medium',
    commandExample: 'amass enum -passive -d target.com -o output.txt',
    inputFields: [
      ToolInputField(
        id: 'domain',
        label: 'Target Domain',
        hint: 'target.com',
        required: true,
      ),
      ToolInputField(
        id: 'output',
        label: 'Output File',
        hint: 'amass_output.txt',
      ),
      ToolInputField(
        id: 'config',
        label: 'Config File',
        hint: '/path/to/config.ini',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'passive',
        label: 'Passive Enum',
        description: 'Passive information gathering',
      ),
      ScanOption(
        id: 'active',
        label: 'Active Enum',
        description: 'Active DNS enumeration',
      ),
      ScanOption(
        id: 'intel',
        label: 'Intel Mode',
        description: 'Collect intelligence on target',
      ),
    ],
  ),
  SecurityTool(
    id: 'osint',
    name: 'OSINT Framework',
    categoryId: 'recon',
    description: 'Organized collection of OSINT tools and resources',
    longDescription:
        'OSINT Framework is focused on gathering information from free tools or resources. The intention is to help people find free OSINT resources. It provides a categorized collection of OSINT tools.',
    version: 'Web-based',
    platform: 'Web',
    tags: ['osint', 'recon', 'framework', 'intelligence'],
    severityLevel: 'low',
    commandExample: 'https://osintframework.com (web-based)',
    inputFields: [
      ToolInputField(
        id: 'target',
        label: 'Target / Query',
        hint: 'person name, email, domain, IP',
        required: true,
      ),
      ToolInputField(
        id: 'category',
        label: 'Category',
        hint: 'Username, Email, Domain, IP, etc.',
        type: 'dropdown',
        options: [
          'Username',
          'Email Address',
          'Domain Name',
          'IP Address',
          'Phone Number',
          'Social Networks',
          'Dark Web',
        ],
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'username',
        label: 'Username Search',
        description: 'Find username across platforms',
      ),
      ScanOption(
        id: 'email',
        label: 'Email Investigation',
        description: 'Investigate email address',
      ),
      ScanOption(
        id: 'domain',
        label: 'Domain Research',
        description: 'Research domain information',
      ),
    ],
  ),

  // ── TRAFFIC & MITM (5) ───────────────────────────────────────────────────
  SecurityTool(
    id: 'wireshark',
    name: 'Wireshark',
    categoryId: 'traffic',
    description: 'World\'s foremost network protocol analyzer',
    longDescription:
        'Wireshark is the world\'s foremost and widely-used network protocol analyzer. It lets you see what\'s happening on your network at a microscopic level and is the de facto standard across many commercial and non-profit enterprises.',
    version: '4.2.4',
    platform: 'Linux/Windows/macOS',
    tags: ['packet-capture', 'protocol-analysis', 'network', 'traffic'],
    severityLevel: 'medium',
    commandExample: 'wireshark -i eth0 -k -f "tcp port 80"',
    inputFields: [
      ToolInputField(
        id: 'interface',
        label: 'Capture Interface',
        hint: 'eth0 or wlan0',
        required: true,
      ),
      ToolInputField(
        id: 'filter',
        label: 'Capture Filter (BPF)',
        hint: 'tcp port 80 or host 192.168.1.1',
      ),
      ToolInputField(
        id: 'output',
        label: 'Output File (.pcap)',
        hint: 'capture.pcap',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'live',
        label: 'Live Capture',
        description: 'Capture live network traffic',
      ),
      ScanOption(
        id: 'file',
        label: 'Open PCAP File',
        description: 'Analyze existing capture file',
      ),
      ScanOption(
        id: 'follow',
        label: 'Follow Stream',
        description: 'Follow TCP/UDP stream',
      ),
    ],
  ),
  SecurityTool(
    id: 'bettercap',
    name: 'Bettercap',
    categoryId: 'traffic',
    description: 'Swiss army knife for network attacks and monitoring',
    longDescription:
        'Bettercap is a powerful, easily extensible and portable framework written in Go which aims to offer to security researchers, red teamers and reverse engineers an easy to use, all-in-one solution with all the features they might possibly need for performing reconnaissance and attacking WiFi networks, Bluetooth Low Energy devices, wireless HID devices and Ethernet networks.',
    version: '2.32.0',
    platform: 'Linux/macOS',
    tags: ['mitm', 'arp-spoof', 'wifi', 'bluetooth', 'network'],
    severityLevel: 'critical',
    commandExample: 'bettercap -iface eth0 -eval "net.probe on; arp.spoof on"',
    inputFields: [
      ToolInputField(
        id: 'interface',
        label: 'Network Interface',
        hint: 'eth0',
        required: true,
      ),
      ToolInputField(
        id: 'target',
        label: 'Target IP',
        hint: '192.168.1.100 (blank = all)',
      ),
      ToolInputField(id: 'gateway', label: 'Gateway IP', hint: '192.168.1.1'),
    ],
    scanOptions: [
      ScanOption(
        id: 'arp',
        label: 'ARP Spoofing',
        description: 'Man-in-the-middle via ARP',
      ),
      ScanOption(
        id: 'dns',
        label: 'DNS Spoofing',
        description: 'Redirect DNS queries',
      ),
      ScanOption(
        id: 'https',
        label: 'HTTPS Downgrade',
        description: 'Strip HTTPS to HTTP',
      ),
      ScanOption(
        id: 'sniff',
        label: 'Packet Sniffing',
        description: 'Capture network packets',
      ),
    ],
  ),
  SecurityTool(
    id: 'ettercap',
    name: 'Ettercap',
    categoryId: 'traffic',
    description: 'Comprehensive suite for MITM attacks on LAN',
    longDescription:
        'Ettercap is a comprehensive suite for man in the middle attacks. It features sniffing of live connections, content filtering on the fly and many other interesting tricks. It supports active and passive dissection of many protocols.',
    version: '0.8.3.1',
    platform: 'Linux/macOS',
    tags: ['mitm', 'arp-spoof', 'sniffing', 'network'],
    severityLevel: 'critical',
    commandExample: 'ettercap -T -M arp:remote /192.168.1.1// /192.168.1.100//',
    inputFields: [
      ToolInputField(
        id: 'interface',
        label: 'Interface',
        hint: 'eth0',
        required: true,
      ),
      ToolInputField(
        id: 'target1',
        label: 'Target 1 (Gateway)',
        hint: '192.168.1.1',
      ),
      ToolInputField(
        id: 'target2',
        label: 'Target 2 (Victim)',
        hint: '192.168.1.100',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'arp',
        label: 'ARP Poisoning',
        description: 'Classic ARP MITM',
      ),
      ScanOption(
        id: 'icmp',
        label: 'ICMP Redirect',
        description: 'ICMP-based MITM',
      ),
      ScanOption(
        id: 'filter',
        label: 'Content Filter',
        description: 'Filter/modify traffic',
      ),
    ],
  ),
  SecurityTool(
    id: 'mitmproxy',
    name: 'MITMproxy',
    categoryId: 'traffic',
    description:
        'Interactive HTTPS proxy for traffic inspection and modification',
    longDescription:
        'mitmproxy is a free and open source interactive HTTPS proxy. It can be used to intercept, inspect, modify and replay web traffic such as HTTP/1, HTTP/2, WebSockets, or any other SSL/TLS-protected protocols.',
    version: '10.3.1',
    platform: 'Linux/Windows/macOS',
    tags: ['proxy', 'https-intercept', 'traffic-analysis', 'web-testing'],
    severityLevel: 'high',
    commandExample: 'mitmproxy --listen-port 8080 --ssl-insecure',
    inputFields: [
      ToolInputField(
        id: 'port',
        label: 'Listen Port',
        hint: '8080',
        required: true,
      ),
      ToolInputField(
        id: 'upstream',
        label: 'Upstream Proxy',
        hint: 'http://proxy:8080 (optional)',
      ),
      ToolInputField(
        id: 'filter',
        label: 'Traffic Filter',
        hint: '~d target.com',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'intercept',
        label: 'Intercept Mode',
        description: 'Pause and modify requests',
      ),
      ScanOption(
        id: 'replay',
        label: 'Replay Mode',
        description: 'Replay captured requests',
      ),
      ScanOption(
        id: 'script',
        label: 'Script Mode',
        description: 'Run Python scripts on traffic',
      ),
    ],
  ),
  SecurityTool(
    id: 'tcpdump',
    name: 'Tcpdump',
    categoryId: 'traffic',
    description: 'Powerful command-line packet analyzer',
    longDescription:
        'Tcpdump is a powerful command-line packet analyzer; and libpcap, a portable C/C++ library for network traffic capture. It allows the user to display TCP/IP and other packets being transmitted or received over a network.',
    version: '4.99.4',
    platform: 'Linux/macOS',
    tags: ['packet-capture', 'network', 'traffic', 'cli'],
    severityLevel: 'medium',
    commandExample: 'tcpdump -i eth0 -w capture.pcap "tcp port 80"',
    inputFields: [
      ToolInputField(
        id: 'interface',
        label: 'Interface',
        hint: 'eth0',
        required: true,
      ),
      ToolInputField(
        id: 'filter',
        label: 'BPF Filter',
        hint: 'tcp port 80 or host 192.168.1.1',
      ),
      ToolInputField(id: 'output', label: 'Output File', hint: 'capture.pcap'),
      ToolInputField(id: 'count', label: 'Packet Count', hint: '1000'),
    ],
    scanOptions: [
      ScanOption(
        id: 'capture',
        label: 'Live Capture',
        description: 'Capture live packets',
      ),
      ScanOption(
        id: 'read',
        label: 'Read PCAP',
        description: 'Read existing pcap file',
      ),
      ScanOption(
        id: 'verbose',
        label: 'Verbose Output',
        description: 'Show full packet details',
      ),
    ],
  ),

  // ── VULNERABILITY (4) ────────────────────────────────────────────────────
  SecurityTool(
    id: 'openvas',
    name: 'OpenVAS',
    categoryId: 'vuln',
    description: 'Full-featured vulnerability scanner and manager',
    longDescription:
        'OpenVAS (Open Vulnerability Assessment System) is a full-featured vulnerability scanner. Its capabilities include unauthenticated and authenticated testing, various high-level and low-level internet and industrial protocols, performance tuning for large-scale scans.',
    version: '22.4.1',
    platform: 'Linux',
    tags: ['vulnerability-scan', 'cve', 'network-scan', 'compliance'],
    severityLevel: 'critical',
    commandExample:
        'gvm-cli socket --gmp-username admin --gmp-password admin --xml "<get_tasks/>"',
    inputFields: [
      ToolInputField(
        id: 'target',
        label: 'Target IP / Range',
        hint: '192.168.1.0/24',
        required: true,
      ),
      ToolInputField(
        id: 'scanconfig',
        label: 'Scan Config',
        hint: 'Full and Fast',
        type: 'dropdown',
        options: [
          'Full and Fast',
          'Full and Fast Ultimate',
          'Full and Very Deep',
          'System Discovery',
        ],
      ),
      ToolInputField(
        id: 'credentials',
        label: 'Auth Credentials',
        hint: 'Optional SSH/SMB creds',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'full',
        label: 'Full Scan',
        description: 'Comprehensive vulnerability scan',
      ),
      ScanOption(
        id: 'discovery',
        label: 'Discovery Scan',
        description: 'Host and service discovery',
      ),
      ScanOption(
        id: 'authenticated',
        label: 'Authenticated Scan',
        description: 'Scan with credentials',
      ),
    ],
  ),
  SecurityTool(
    id: 'nuclei',
    name: 'Nuclei',
    categoryId: 'vuln',
    description:
        'Fast and customizable vulnerability scanner based on templates',
    longDescription:
        'Nuclei is a fast, template-based vulnerability scanner that sends requests across targets based on a template, leading to zero false positives and providing fast scanning on a large number of hosts.',
    version: '3.2.4',
    platform: 'Linux/Windows/macOS',
    tags: ['vulnerability-scan', 'templates', 'cve', 'web-scan'],
    severityLevel: 'critical',
    commandExample:
        'nuclei -u https://target.com -t cves/ -severity critical,high',
    inputFields: [
      ToolInputField(
        id: 'target',
        label: 'Target URL / IP',
        hint: 'https://target.com',
        required: true,
      ),
      ToolInputField(
        id: 'templates',
        label: 'Template Path',
        hint: 'cves/ or technologies/',
      ),
      ToolInputField(
        id: 'severity',
        label: 'Severity Filter',
        hint: 'critical,high,medium',
        type: 'dropdown',
        options: [
          'critical',
          'high',
          'medium',
          'low',
          'info',
          'critical,high',
          'critical,high,medium',
        ],
      ),
      ToolInputField(id: 'rate', label: 'Rate Limit', hint: '150 (req/sec)'),
    ],
    scanOptions: [
      ScanOption(
        id: 'cves',
        label: 'CVE Templates',
        description: 'Scan for known CVEs',
      ),
      ScanOption(
        id: 'tech',
        label: 'Technology Detection',
        description: 'Identify technologies',
      ),
      ScanOption(
        id: 'misconfig',
        label: 'Misconfiguration',
        description: 'Find misconfigurations',
      ),
      ScanOption(
        id: 'exposed',
        label: 'Exposed Panels',
        description: 'Find exposed admin panels',
      ),
    ],
  ),
  SecurityTool(
    id: 'lynis',
    name: 'Lynis',
    categoryId: 'vuln',
    description: 'Security auditing tool for Unix/Linux systems',
    longDescription:
        'Lynis is a security auditing tool for systems based on UNIX like Linux, macOS, BSD, and others. It performs an in-depth security scan and runs on the system itself. The primary goal is to test security defenses and provide tips for further system hardening.',
    version: '3.0.9',
    platform: 'Linux/macOS/BSD',
    tags: ['system-audit', 'hardening', 'compliance', 'linux'],
    severityLevel: 'medium',
    commandExample: 'lynis audit system --quick',
    inputFields: [
      ToolInputField(
        id: 'mode',
        label: 'Audit Mode',
        hint: 'system, dockerfile, or custom',
        type: 'dropdown',
        options: ['system', 'dockerfile', 'custom'],
      ),
      ToolInputField(
        id: 'profile',
        label: 'Profile',
        hint: '/etc/lynis/default.prf',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'quick',
        label: 'Quick Scan',
        description: 'Fast system audit',
      ),
      ScanOption(
        id: 'full',
        label: 'Full Audit',
        description: 'Comprehensive system audit',
      ),
      ScanOption(
        id: 'pentest',
        label: 'Pentest Mode',
        description: 'Pentest-focused scan',
      ),
    ],
  ),
  SecurityTool(
    id: 'retirejs',
    name: 'Retire.js',
    categoryId: 'vuln',
    description: 'Scanner for JavaScript libraries with known vulnerabilities',
    longDescription:
        'Retire.js is a tool to detect the use of JavaScript libraries with known vulnerabilities. It can be used as a command line tool, a browser extension, or integrated into build pipelines.',
    version: '5.3.3',
    platform: 'Linux/Windows/macOS (Node.js)',
    tags: ['javascript', 'dependency-scan', 'cve', 'web-scan'],
    severityLevel: 'medium',
    commandExample: 'retire --path /path/to/webapp --outputformat json',
    inputFields: [
      ToolInputField(
        id: 'path',
        label: 'Web App Path / URL',
        hint: '/path/to/webapp or https://target.com',
        required: true,
      ),
      ToolInputField(
        id: 'format',
        label: 'Output Format',
        hint: 'json, text, or jsonsimple',
        type: 'dropdown',
        options: ['text', 'json', 'jsonsimple', 'depcheck'],
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'local',
        label: 'Local Scan',
        description: 'Scan local project files',
      ),
      ScanOption(
        id: 'remote',
        label: 'Remote Scan',
        description: 'Scan remote URL',
      ),
      ScanOption(
        id: 'node',
        label: 'Node Modules',
        description: 'Scan node_modules directory',
      ),
    ],
  ),

  // ── FORENSICS & MISC (5) ─────────────────────────────────────────────────
  SecurityTool(
    id: 'binwalk',
    name: 'Binwalk',
    categoryId: 'forensics',
    description: 'Firmware analysis and extraction tool',
    longDescription:
        'Binwalk is a fast, easy to use tool for analyzing, reverse engineering, and extracting firmware images. It uses the libmagic library to search for signatures of embedded files and executable code.',
    version: '2.3.4',
    platform: 'Linux/macOS',
    tags: ['firmware', 'reverse-engineering', 'extraction', 'forensics'],
    severityLevel: 'medium',
    commandExample: 'binwalk -e firmware.bin --dd=".*"',
    inputFields: [
      ToolInputField(
        id: 'file',
        label: 'Target File',
        hint: '/path/to/firmware.bin',
        required: true,
      ),
      ToolInputField(
        id: 'output',
        label: 'Output Directory',
        hint: '/tmp/extracted/',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'scan',
        label: 'Signature Scan',
        description: 'Scan for file signatures',
      ),
      ScanOption(
        id: 'extract',
        label: 'Extract Files',
        description: 'Extract embedded files',
      ),
      ScanOption(
        id: 'entropy',
        label: 'Entropy Analysis',
        description: 'Analyze data entropy',
      ),
    ],
  ),
  SecurityTool(
    id: 'strings',
    name: 'Strings',
    categoryId: 'forensics',
    description: 'Extract printable strings from binary files',
    longDescription:
        'The strings program looks for printable strings in a binary file. A string is any sequence of 4 or more printable characters that ends with a newline or a null character. It is useful for identifying text in binaries.',
    version: '2.41',
    platform: 'Linux/macOS',
    tags: ['binary-analysis', 'forensics', 'reverse-engineering'],
    severityLevel: 'low',
    commandExample:
        'strings -n 8 malware.exe | grep -i "http\\|password\\|key"',
    inputFields: [
      ToolInputField(
        id: 'file',
        label: 'Target Binary',
        hint: '/path/to/binary.exe',
        required: true,
      ),
      ToolInputField(id: 'minlen', label: 'Min String Length', hint: '4'),
      ToolInputField(
        id: 'grep',
        label: 'Filter Pattern',
        hint: 'http|password|key',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'ascii',
        label: 'ASCII Strings',
        description: 'Extract ASCII strings',
      ),
      ScanOption(
        id: 'unicode',
        label: 'Unicode Strings',
        description: 'Extract Unicode strings',
      ),
      ScanOption(
        id: 'all',
        label: 'All Encodings',
        description: 'Extract all string types',
      ),
    ],
  ),
  SecurityTool(
    id: 'volatility',
    name: 'Volatility',
    categoryId: 'forensics',
    description: 'Advanced memory forensics framework',
    longDescription:
        'Volatility is the world\'s most widely used framework for extracting digital artifacts from volatile memory (RAM) samples. It supports analysis of memory dumps from Windows, Linux, macOS, and Android systems.',
    version: '3.7.0',
    platform: 'Linux/Windows/macOS',
    tags: ['memory-forensics', 'ram-analysis', 'malware-analysis', 'forensics'],
    severityLevel: 'high',
    commandExample: 'vol.py -f memory.dmp windows.pslist.PsList',
    inputFields: [
      ToolInputField(
        id: 'memfile',
        label: 'Memory Dump File',
        hint: '/path/to/memory.dmp',
        required: true,
      ),
      ToolInputField(
        id: 'plugin',
        label: 'Plugin',
        hint: 'windows.pslist, windows.netscan',
        type: 'dropdown',
        options: [
          'windows.pslist',
          'windows.netscan',
          'windows.dlllist',
          'windows.cmdline',
          'windows.malfind',
          'linux.pslist',
          'linux.netstat',
        ],
      ),
      ToolInputField(
        id: 'profile',
        label: 'OS Profile',
        hint: 'Win10x64_19041 (auto-detect)',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'processes',
        label: 'Process List',
        description: 'List running processes',
      ),
      ScanOption(
        id: 'network',
        label: 'Network Connections',
        description: 'Show network connections',
      ),
      ScanOption(
        id: 'malfind',
        label: 'Malware Detection',
        description: 'Find injected code',
      ),
      ScanOption(
        id: 'dump',
        label: 'Dump Process',
        description: 'Dump process memory',
      ),
    ],
  ),
  SecurityTool(
    id: 'autopsy',
    name: 'Autopsy',
    categoryId: 'forensics',
    description:
        'Digital forensics platform and graphical interface for The Sleuth Kit',
    longDescription:
        'Autopsy is a digital forensics platform and graphical interface to The Sleuth Kit and other digital forensics tools. It is used by law enforcement, military, and corporate examiners to investigate what happened on a computer.',
    version: '4.21.0',
    platform: 'Linux/Windows',
    tags: ['disk-forensics', 'file-recovery', 'timeline', 'forensics'],
    severityLevel: 'medium',
    commandExample: 'autopsy (GUI application)',
    inputFields: [
      ToolInputField(
        id: 'image',
        label: 'Disk Image File',
        hint: '/path/to/disk.img or .E01',
        required: true,
      ),
      ToolInputField(
        id: 'casename',
        label: 'Case Name',
        hint: 'Investigation_2026',
      ),
      ToolInputField(
        id: 'examiner',
        label: 'Examiner Name',
        hint: 'Analyst Name',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'hash',
        label: 'Hash Analysis',
        description: 'Hash-based file identification',
      ),
      ScanOption(
        id: 'keyword',
        label: 'Keyword Search',
        description: 'Search for keywords',
      ),
      ScanOption(
        id: 'timeline',
        label: 'Timeline Analysis',
        description: 'Build activity timeline',
      ),
      ScanOption(
        id: 'recover',
        label: 'File Recovery',
        description: 'Recover deleted files',
      ),
    ],
  ),
  SecurityTool(
    id: 'steghide',
    name: 'Steghide',
    categoryId: 'forensics',
    description: 'Steganography tool for hiding data in image/audio files',
    longDescription:
        'Steghide is a steganography program that is able to hide data in various kinds of image and audio files. The color and sample frequencies are not changed, making the embedding resistant to first-order statistical tests.',
    version: '0.5.1',
    platform: 'Linux/Windows',
    tags: ['steganography', 'data-hiding', 'forensics', 'ctf'],
    severityLevel: 'low',
    commandExample: 'steghide extract -sf image.jpg -p password',
    inputFields: [
      ToolInputField(
        id: 'file',
        label: 'Cover File (image/audio)',
        hint: '/path/to/image.jpg',
        required: true,
      ),
      ToolInputField(
        id: 'password',
        label: 'Passphrase',
        hint: 'Encryption passphrase',
      ),
      ToolInputField(
        id: 'embedfile',
        label: 'File to Embed',
        hint: '/path/to/secret.txt (for embed)',
      ),
    ],
    scanOptions: [
      ScanOption(
        id: 'embed',
        label: 'Embed Data',
        description: 'Hide data in cover file',
      ),
      ScanOption(
        id: 'extract',
        label: 'Extract Data',
        description: 'Extract hidden data',
      ),
      ScanOption(
        id: 'info',
        label: 'File Info',
        description: 'Show steganography info',
      ),
    ],
  ),
];
