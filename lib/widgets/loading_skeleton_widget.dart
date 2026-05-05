import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoadingSkeletonWidget extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const LoadingSkeletonWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _shimmerPosition = Tween<double>(begin: -0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerPosition,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: [
                AppTheme.surfaceVariant,
                AppTheme.surfaceElevated,
                AppTheme.surfaceVariant,
              ],
              stops: [
                (_shimmerPosition.value - 0.3).clamp(0.0, 1.0),
                _shimmerPosition.value.clamp(0.0, 1.0),
                (_shimmerPosition.value + 0.3).clamp(0.0, 1.0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        );
      },
    );
  }
}

class DashboardSkeletonWidget extends StatelessWidget {
  const DashboardSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI grid skeleton
          Row(
            children: [
              Expanded(
                child: LoadingSkeletonWidget(
                  width: double.infinity,
                  height: 88,
                  borderRadius: 12,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LoadingSkeletonWidget(
                  width: double.infinity,
                  height: 88,
                  borderRadius: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LoadingSkeletonWidget(
                  width: double.infinity,
                  height: 88,
                  borderRadius: 12,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LoadingSkeletonWidget(
                  width: double.infinity,
                  height: 88,
                  borderRadius: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LoadingSkeletonWidget(
            width: double.infinity,
            height: 120,
            borderRadius: 12,
          ),
          const SizedBox(height: 16),
          LoadingSkeletonWidget(
            width: double.infinity,
            height: 180,
            borderRadius: 12,
          ),
          const SizedBox(height: 16),
          ...List.generate(
            3,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: LoadingSkeletonWidget(
                width: double.infinity,
                height: 72,
                borderRadius: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
