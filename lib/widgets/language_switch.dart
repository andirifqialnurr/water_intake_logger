import 'package:flutter/material.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({
    required this.languageCode,
    required this.flag,
    required this.onTap,
    super.key,
  });

  final String languageCode;
  final String flag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        height: 32,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: colors.surfaceMuted,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: colors.outline.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  languageCode,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colors.onSurfaceMuted,
                  ),
                ),
              ),
            ),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surface,
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(flag, style: const TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
