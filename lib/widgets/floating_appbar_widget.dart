import 'package:flutter/material.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class FloatingAppbarWidget extends StatelessWidget {
  final String title;
  final String profileImagePath;

  const FloatingAppbarWidget({
    required this.title,
    required this.profileImagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colors.navBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: colors.shadow, blurRadius: 6, offset: Offset(1, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: colors.primary,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(profileImagePath),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextWidget(text: title, variant: TextWidgetStyle.subtitle),
          ),
        ],
      ),
    );
  }
}
