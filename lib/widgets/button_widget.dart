import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';

enum ButtonVariantApp { primary, secondary, teriatry, outline, inverted }

class ButtonWidget extends StatelessWidget {
  final String text;
  final ButtonVariantApp variant;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool fullWidth;
  final IconData? icon;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariantApp.primary,
    this.isLoading = false,
    this.fullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isOutline = variant == ButtonVariantApp.outline;
    final bg = _backgroundColor();
    final fg = _foregroundColor();
    final buttonStyle = isOutline ? _outlineStyle() : _filledStyle(bg, fg);

    final child = _ButtonContent(
      text: text,
      icon: icon,
      isLoading: isLoading,
      fullWidth: fullWidth,
      foregroundColor: fg,
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: isOutline
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: child,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: buttonStyle,
              child: child,
            ),
    );
  }

  ButtonStyle _filledStyle(Color bg, Color fg) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      foregroundColor: fg,
      disabledBackgroundColor: bg.withAlpha(140),
      disabledForegroundColor: fg.withAlpha(180),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: TextStyle(fontWeight: FontWeight.w700),
      padding: EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
    );
  }

  ButtonStyle _outlineStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: _foregroundColor(),
      disabledForegroundColor: AppColors.primary.withAlpha(140),
      side: BorderSide(color: AppColors.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: TextStyle(fontWeight: FontWeight.w700),
      padding: EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Color _backgroundColor() => switch (variant) {
    ButtonVariantApp.primary => AppColors.primary,
    ButtonVariantApp.secondary => AppColors.surfaceContainerHigh,
    ButtonVariantApp.teriatry => AppColors.tertiary,
    ButtonVariantApp.outline => AppColors.outline,
    ButtonVariantApp.inverted => AppColors.inverseSurface,
  };

  Color _foregroundColor() => switch (variant) {
    ButtonVariantApp.primary => AppColors.neutral,
    ButtonVariantApp.secondary => AppColors.onSurfaceVariant,
    ButtonVariantApp.teriatry => AppColors.neutral,
    ButtonVariantApp.outline => AppColors.onSurfaceVariant,
    ButtonVariantApp.inverted => AppColors.neutral,
  };
}

class _ButtonContent extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final Color foregroundColor;

  const _ButtonContent({
    required this.text,
    required this.icon,
    required this.isLoading,
    required this.fullWidth,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final leading = isLoading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(foregroundColor),
            ),
          )
        : (icon == null ? null : Icon(icon, size: 20));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (leading != null) ...[leading, const SizedBox(width: 8)],
        fullWidth
            ? Flexible(child: Text(text, overflow: TextOverflow.ellipsis))
            : Text(text),
      ],
    );
  }
}
