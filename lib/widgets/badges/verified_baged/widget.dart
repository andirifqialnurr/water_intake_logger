import 'package:flutter/material.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';

class VerifiedBadgeWidget extends StatelessWidget {
  const VerifiedBadgeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: colors.surface, width: 3),
      ),
      child: Icon(Icons.verified, size: 22, color: colors.onPrimary),
    );
  }
}

class VerifiedBadgeBackWidget extends StatelessWidget {
  const VerifiedBadgeBackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: colors.onSurface, width: 3),
      ),
    );
  }
}
