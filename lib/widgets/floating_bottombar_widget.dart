import 'package:flutter/material.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';

class FloatingNavItem {
  final IconData icon;
  const FloatingNavItem({required this.icon});
}

class FloatingBottombarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<FloatingNavItem> items;

  final ValueChanged<int>? onDoubleTap;

  const FloatingBottombarWidget({
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.onDoubleTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: colors.navBackground,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 6,
              offset: Offset(1, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final isSelected = index == currentIndex;

            return GestureDetector(
              onTap: () => onTap(index),
              onDoubleTap: () => onDoubleTap?.call(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.navSelectedBackground
                      : colors.navUnselectedBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AnimatedScale(
                    scale: isSelected ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    child: Icon(
                      items[index].icon,
                      color: isSelected
                          ? colors.navSelectedIcon
                          : colors.navUnselectedIcon,
                      size: 26,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
