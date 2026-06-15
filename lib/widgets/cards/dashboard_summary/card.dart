import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class DashboardSummaryCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String caption;

  const DashboardSummaryCard({
    required this.iconData,
    required this.title,
    required this.caption,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inversePrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData, color: AppColors.primary),
          SizedBox(height: 6),
          TextWidget(text: title, variant: TextWidgetStyle.title),
          SizedBox(height: 4),
          TextWidget(text: caption, variant: TextWidgetStyle.caption),
        ],
      ),
    );
  }
}
