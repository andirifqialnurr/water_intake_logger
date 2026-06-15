import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class ButtonAddWaterCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final int volume;
  final String unit;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const ButtonAddWaterCard({
    required this.iconData,
    required this.title,
    required this.volume,
    required this.unit,
    required this.backgroundColor,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.inversePrimary,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(iconData, color: AppColors.primary, size: 30),
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(text: title, variant: TextWidgetStyle.body),
                    SizedBox(height: 2),
                    TextWidget(
                      text: "$volume $unit",
                      variant: TextWidgetStyle.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
