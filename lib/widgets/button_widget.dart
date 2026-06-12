import 'package:flutter/widgets.dart';

enum ButtonVariantApp { primary, secondary, teriatry, outline }

class ButtonWidget extends StatelessWidget {
  final String text;
  final ButtonVariantApp? variant;
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
    return SizedBox();
  }
}
