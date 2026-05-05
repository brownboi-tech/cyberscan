import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class FindingsFilterWidget extends StatelessWidget {
  final List<String> filters;
  final String activeFilter;
  final Function(String) onFilterChanged;

  const FindingsFilterWidget({
    super.key,
    required this.filters,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  Color _chipColor(String filter) {
    switch (filter.toLowerCase()) {
      case 'critical':
        return AppTheme.critical;
      case 'high':
        return AppTheme.high;
      case 'medium':
        return AppTheme.medium;
      case 'low':
        return AppTheme.low;
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final filter = filters[i];
          final isActive = filter == activeFilter;
          final color = _chipColor(filter);

          return GestureDetector(
            onTap: () => onFilterChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? color.withAlpha(38) : AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? color.withAlpha(153)
                      : const Color(0xFF2D3548),
                  width: isActive ? 1 : 0.5,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isActive ? color : AppTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
