import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class FloatingAppbarWidget extends StatelessWidget {
  final String title;
  final String profileImagePath;
  final VoidCallback onSettingTap;

  const FloatingAppbarWidget({
    required this.title,
    required this.profileImagePath,
    required this.onSettingTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.neutral,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.outlineVariant,
            blurRadius: 6,
            offset: Offset(1, 4),
            blurStyle: BlurStyle.normal,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(profileImagePath),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextWidget(text: title, variant: TextWidgetStyle.subtitle),
          ),
          IconButton(
            onPressed: onSettingTap,
            icon: Icon(Icons.settings_rounded, color: AppColors.outline),
          ),
        ],
      ),
    );
  }
}
