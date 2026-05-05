import 'dart:ui';

import '../../core/app_export.dart';
import '../../data/tools_data.dart';
import '../tool_detail_screen/tool_detail_screen.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SecurityTool> get _filteredTools {
    List<SecurityTool> tools = allTools;

    if (_selectedCategoryId != 'all') {
      tools = tools.where((t) => t.categoryId == _selectedCategoryId).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      tools = tools.where((t) {
        return t.name.toLowerCase().contains(q) ||
            t.description.toLowerCase().contains(q) ||
            t.tags.any((tag) => tag.toLowerCase().contains(q));
      }).toList();
    }

    return tools;
  }

  Color _categoryColor(String categoryId) {
    final cat = toolCategories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => toolCategories.first,
    );
    return _hexToColor(cat.color);
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  Color _severityColor(String severity) {
    switch (severity) {
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

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 3,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            _buildSearchBar(),
            _buildCategoryTabs(),
            _buildToolCount(),
            Expanded(child: _buildToolsGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryMuted,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.construction_rounded,
              color: AppTheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tools Library',
                style: GoogleFonts.ibmPlexSans(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${allTools.length} security tools',
                style: GoogleFonts.ibmPlexSans(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.primaryMuted,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.primary.withAlpha(80),
                width: 0.5,
              ),
            ),
            child: Text(
              'PARROT OS',
              style: GoogleFonts.ibmPlexMono(
                color: AppTheme.primary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
            style: GoogleFonts.ibmPlexSans(
              color: AppTheme.textPrimary,
              fontSize: 13,
            ),
            decoration: InputDecoration(
              hintText: 'Search tools, categories, tags...',
              hintStyle: GoogleFonts.ibmPlexSans(
                color: AppTheme.textMuted,
                fontSize: 13,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppTheme.textMuted,
                size: 18,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppTheme.textMuted,
                        size: 16,
                      ),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              filled: true,
              fillColor: AppTheme.surfaceCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF2D3548),
                  width: 0.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF2D3548),
                  width: 0.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primary, width: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: toolCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = toolCategories[index];
          final isSelected = _selectedCategoryId == cat.id;
          final catColor = _hexToColor(cat.color);
          return GestureDetector(
            onTap: () => setState(() => _selectedCategoryId = cat.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? catColor.withAlpha(40)
                    : AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? catColor.withAlpha(150)
                      : const Color(0xFF2D3548),
                  width: isSelected ? 1 : 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconData(cat.icon),
                    size: 13,
                    color: isSelected ? catColor : AppTheme.textMuted,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    cat.name,
                    style: GoogleFonts.ibmPlexSans(
                      color: isSelected ? catColor : AppTheme.textMuted,
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToolCount() {
    final count = _filteredTools.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Text(
        '$count tool${count != 1 ? 's' : ''} found',
        style: GoogleFonts.ibmPlexSans(
          color: AppTheme.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildToolsGrid() {
    final tools = _filteredTools;
    if (tools.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, color: AppTheme.textMuted, size: 40),
            const SizedBox(height: 12),
            Text(
              'No tools found',
              style: GoogleFonts.ibmPlexSans(
                color: AppTheme.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try a different search or category',
              style: GoogleFonts.ibmPlexSans(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.88,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) => _buildToolCard(tools[index]),
    );
  }

  Widget _buildToolCard(SecurityTool tool) {
    final catColor = _categoryColor(tool.categoryId);
    final sevColor = _severityColor(tool.severityLevel);
    final cat = toolCategories.firstWhere(
      (c) => c.id == tool.categoryId,
      orElse: () => toolCategories.first,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ToolDetailScreen(tool: tool)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2D3548), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and severity
            Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              decoration: BoxDecoration(
                color: catColor.withAlpha(15),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                border: Border(
                  bottom: BorderSide(color: catColor.withAlpha(40), width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: catColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(_iconData(cat.icon), color: catColor, size: 17),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: sevColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tool.severityLevel.toUpperCase(),
                      style: GoogleFonts.ibmPlexMono(
                        color: sevColor,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tool.name,
                      style: GoogleFonts.ibmPlexSans(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        tool.description,
                        style: GoogleFonts.ibmPlexSans(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Tags row
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: tool.tags.take(2).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.ibmPlexMono(
                              color: AppTheme.textMuted,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Row(
                children: [
                  Text(
                    'v${tool.version.split(' ').first}',
                    style: GoogleFonts.ibmPlexMono(
                      color: AppTheme.textMuted,
                      fontSize: 9,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryMuted,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Launch',
                      style: GoogleFonts.ibmPlexSans(
                        color: AppTheme.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconData(String name) {
    switch (name) {
      case 'apps':
        return Icons.apps_rounded;
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
