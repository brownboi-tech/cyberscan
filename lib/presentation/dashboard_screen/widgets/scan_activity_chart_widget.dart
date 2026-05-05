import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ScanActivityChartWidget extends StatefulWidget {
  final List<Map<String, dynamic>> scanJobs;

  const ScanActivityChartWidget({super.key, required this.scanJobs});

  @override
  State<ScanActivityChartWidget> createState() =>
      _ScanActivityChartWidgetState();
}

class _ScanActivityChartWidgetState extends State<ScanActivityChartWidget> {
  int? _touchedIndex;

  // Simulated 7-day scan activity data
  final List<_DayActivity> _weekData = [
    _DayActivity('Mon', 3, 1, 0),
    _DayActivity('Tue', 5, 2, 1),
    _DayActivity('Wed', 2, 0, 0),
    _DayActivity('Thu', 7, 3, 2),
    _DayActivity('Fri', 4, 1, 0),
    _DayActivity('Sat', 1, 0, 0),
    _DayActivity('Sun', 4, 2, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2D3548), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Scan Activity',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Last 7 days',
                    style: GoogleFonts.ibmPlexMono(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              // Legend
              Row(
                children: [
                  _LegendDot(color: AppTheme.primary, label: 'Jobs'),
                  const SizedBox(width: 10),
                  _LegendDot(color: AppTheme.critical, label: 'Critical'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chart
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    setState(() {
                      if (response?.spot != null &&
                          event is! FlPointerExitEvent) {
                        _touchedIndex = response!.spot!.touchedBarGroupIndex;
                      } else {
                        _touchedIndex = null;
                      }
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipBgColor: AppTheme.surfaceElevated,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final day = _weekData[groupIndex];
                      return BarTooltipItem(
                        '${day.label}\n${rod.toY.toInt()} ${rodIndex == 0 ? "jobs" : "critical"}',
                        GoogleFonts.ibmPlexMono(
                          color: AppTheme.textPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _weekData.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _weekData[idx].label,
                            style: GoogleFonts.ibmPlexMono(
                              color: AppTheme.textMuted,
                              fontSize: 9,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: Color(0xFF1E2433),
                    strokeWidth: 0.5,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(_weekData.length, (i) {
                  final day = _weekData[i];
                  final isTouched = _touchedIndex == i;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: day.totalJobs.toDouble(),
                        color: isTouched
                            ? AppTheme.primary
                            : AppTheme.primary.withAlpha(153),
                        width: 10,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: day.criticalFindings.toDouble(),
                        color: isTouched
                            ? AppTheme.critical
                            : AppTheme.critical.withAlpha(153),
                        width: 10,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayActivity {
  final String label;
  final int totalJobs;
  final int criticalFindings;
  final int failedJobs;

  const _DayActivity(
    this.label,
    this.totalJobs,
    this.criticalFindings,
    this.failedJobs,
  );
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}