import 'package:flutter/material.dart';

enum TextVariantApp { h1, h2, h3, title, body, desc }

class TextApp extends StatelessWidget {
  final String text;
  final TextVariantApp variant;
  final Color? color;
  final TextAlign? textAlign;

  const TextApp(
    this.text,
    this.color, {
    super.key,
    this.variant = TextVariantApp.body,
    required this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = switch (variant) {
      TextVariantApp.h1 => textTheme.headlineLarge,
      TextVariantApp.h2 => textTheme.headlineMedium,
      TextVariantApp.h3 => textTheme.headlineSmall,
      TextVariantApp.title => textTheme.titleLarge,
      TextVariantApp.body => textTheme.bodyMedium,
      TextVariantApp.desc => textTheme.labelMedium,
    };

    return Text(
      text,
      textAlign: textAlign,
      style: style?.copyWith(color: color),
    );
  }
}
