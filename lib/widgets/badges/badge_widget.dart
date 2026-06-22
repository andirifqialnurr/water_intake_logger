import 'package:flutter/material.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class BadgeWidget extends StatelessWidget {
  final String text;

  const BadgeWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.onPrimary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.whatshot_rounded, size: 16, color: colors.onPrimary),
          SizedBox(width: 6),
          TextWidget(
            text: text,
            variant: TextWidgetStyle.caption,
            color: colors.onPrimary,
          ),
        ],
      ),
    );
  }
}
