import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class FloatingAppbarWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onProfileTap;
  const FloatingAppbarWidget({
    required this.title,
    this.onProfileTap,
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
          const Icon(Icons.water_drop, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: TextWidget(text: title, variant: TextWidgetStyle.body),
          ),
          IconButton(
            onPressed: onProfileTap,
            icon: Icon(Icons.person, color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }
}
