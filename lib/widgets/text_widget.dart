import 'package:flutter/material.dart';

enum TextWidgetStyle {
  display,
  headline,
  title,
  subtitle,
  body,
  caption,
  buttonLabel,
  micro,
}

class TextWidget extends StatelessWidget {
  final String text;
  final TextWidgetStyle variant;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? textOverflow;

  const TextWidget({
    required this.text,
    required this.variant,
    this.color,
    this.textAlign,
    this.maxLines,
    this.textOverflow,

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final style = switch (variant) {
      TextWidgetStyle.display => theme.displayLarge,
      TextWidgetStyle.headline => theme.headlineMedium,
      TextWidgetStyle.title => theme.titleLarge,
      TextWidgetStyle.subtitle => theme.titleMedium,
      TextWidgetStyle.body => theme.bodyLarge,
      TextWidgetStyle.caption => theme.bodySmall,
      TextWidgetStyle.buttonLabel => theme.labelLarge,
      TextWidgetStyle.micro => theme.labelSmall,
    };
    return Text(
      text,
      style: style?.copyWith(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverflow,
    );
  }
}
