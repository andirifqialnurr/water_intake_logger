import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/charts/bar_chart/painter.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class WaterBarChartData {
  final String day;
  final double ml;

  const WaterBarChartData({required this.day, required this.ml});
}

class BarChartProgressWidget extends StatefulWidget {
  final List<WaterBarChartData> data;
  final double maxMl;
  final int? activeIndex;

  const BarChartProgressWidget({
    required this.data,
    required this.maxMl,
    this.activeIndex,
    super.key,
  });

  @override
  State<BarChartProgressWidget> createState() => _BarChartProgressWidgetState();
}

class _BarChartProgressWidgetState extends State<BarChartProgressWidget>
    with TickerProviderStateMixin {
  late final AnimationController _fillController;
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _fillController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: AppColors.onSurface);

    return Container(
      height: 260,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.outlineVariant.withAlpha(50),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(text: "Weekly Intake", variant: TextWidgetStyle.subtitle),
          SizedBox(height: 12),
          Expanded(
            child: AnimatedBuilder(
              animation: Listenable.merge([_fillController, _waveController]),
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: WaterIntakeBarChartPainter(
                    data: widget.data,
                    maxMl: widget.maxMl,
                    labelStyle: labelStyle!,
                    activeIndex: widget.activeIndex,
                    fillProgress: Curves.easeOutCubic.transform(
                      _fillController.value,
                    ),
                    waveProgress: _waveController.value,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
