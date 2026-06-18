import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';

class VerifiedBadgeWidget extends StatelessWidget {
  const VerifiedBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.neutral, width: 3),
      ),
      child: const Icon(Icons.verified, size: 22, color: AppColors.neutral),
    );
  }
}
