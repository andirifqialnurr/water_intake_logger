import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class BadgeWidget extends StatelessWidget {
  final String text;

  const BadgeWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.water_drop_rounded, size: 16, color: AppColors.neutral),
          SizedBox(width: 6),
          TextWidget(
            text: text,
            variant: TextWidgetStyle.caption,
            color: AppColors.neutral,
          ),
        ],
      ),
    );
  }
}
