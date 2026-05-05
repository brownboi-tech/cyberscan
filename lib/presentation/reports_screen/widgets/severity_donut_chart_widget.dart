import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SeverityDonutChartWidget extends StatefulWidget {
  final Map<String, int> severityCounts;

  const SeverityDonutChartWidget({super.key, required this.severityCounts});

  @override
  State<SeverityDonutChartWidget> createState() =>
      _SeverityDonutChartWidgetState();
}

class _SeverityDonutChartWidgetState extends State<SeverityDonutChartWidget>
    with SingleTickerProviderStateMixin {
  int _touchedIndex = -1;
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  int get _total {
    return widget.severityCounts.values.fold(0, (a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    final counts = widget.severityCounts;
    final total = _total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2D3548), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Findings Overview',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$total Total',
                style: GoogleFonts.ibmPlexMono(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Donut chart
              SizedBox(
                width: 130,
                height: 130,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) {
                    return PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                _touchedIndex = -1;
                                return;
                              }
                              _touchedIndex = pieTouchResponse
                                  .touchedSection!
                                  .touchedSectionIndex;
                            });
                          },
                        ),
                        centerSpaceRadius: 38,
                        sectionsSpace: 2,
                        startDegreeOffset: -90,
                        sections: _buildSections(counts, total),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 20),
              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LegendRow(
                      label: 'Critical',
                      count: counts['critical'] ?? 0,
                      color: AppTheme.critical,
                      total: total,
                      isActive: _touchedIndex == 0,
                    ),
                    const SizedBox(height: 8),
                    _LegendRow(
                      label: 'High',
                      count: counts['high'] ?? 0,
                      color: AppTheme.high,
                      total: total,
                      isActive: _touchedIndex == 1,
                    ),
                    const SizedBox(height: 8),
                    _LegendRow(
                      label: 'Medium',
                      count: counts['medium'] ?? 0,
                      color: AppTheme.medium,
                      total: total,
                      isActive: _touchedIndex == 2,
                    ),
                    const SizedBox(height: 8),
                    _LegendRow(
                      label: 'Low',
                      count: counts['low'] ?? 0,
                      color: AppTheme.low,
                      total: total,
                      isActive: _touchedIndex == 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(Map<String, int> counts, int total) {
    if (total == 0) {
      return [
        PieChartSectionData(
          value: 1,
          color: AppTheme.surfaceVariant,
          radius: 28,
          showTitle: false,
        ),
      ];
    }

    final entries = [
      MapEntry('critical', counts['critical'] ?? 0),
      MapEntry('high', counts['high'] ?? 0),
      MapEntry('medium', counts['medium'] ?? 0),
      MapEntry('low', counts['low'] ?? 0),
    ];

    final colors = [
      AppTheme.critical,
      AppTheme.high,
      AppTheme.medium,
      AppTheme.low,
    ];

    return entries.asMap().entries.map((e) {
      final i = e.key;
      final entry = e.value;
      final isTouched = _touchedIndex == i;
      return PieChartSectionData(
        value: entry.value.toDouble(),
        color: colors[i],
        radius: isTouched ? 34 : 28,
        showTitle: false,
      );
    }).toList();
  }
}

class _LegendRow extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final int total;
  final bool isActive;

  const _LegendRow({
    required this.label,
    required this.count,
    required this.color,
    required this.total,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (count / total * 100).round() : 0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.symmetric(
        horizontal: isActive ? 8 : 0,
        vertical: isActive ? 3 : 0,
      ),
      decoration: BoxDecoration(
        color: isActive ? color.withAlpha(26) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.textPrimary : AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Text(
            '$count',
            style: GoogleFonts.ibmPlexMono(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '($pct%)',
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
