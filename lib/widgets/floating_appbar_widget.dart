import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class FloatingAppbarWidget extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final List<Widget> actions;

  const FloatingAppbarWidget({
    required this.title,
    this.showBackButton = false,
    this.actions = const [],
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
          if (showBackButton)
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: AppColors.outline),
            ),
          if (showBackButton) const SizedBox(width: 8),

          Expanded(
            child: TextWidget(text: title, variant: TextWidgetStyle.subtitle),
          ),

          ...actions,
        ],
      ),
    );
  }
}
