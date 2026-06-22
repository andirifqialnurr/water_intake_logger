import 'package:flutter/material.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class ButtonAddWaterCard extends StatefulWidget {
  final IconData iconData;
  final String title;
  final int volume;
  final String unit;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ButtonAddWaterCard({
    required this.iconData,
    required this.title,
    required this.volume,
    required this.unit,
    required this.backgroundColor,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  @override
  State<ButtonAddWaterCard> createState() => _ButtonAddWaterCardState();
}

class _ButtonAddWaterCardState extends State<ButtonAddWaterCard> {
  String? floatingText;
  bool isFloating = false;

  void showFloatingText(String text) {
    setState(() {
      floatingText = text;
      isFloating = false;
    });

    Future.delayed(const Duration(milliseconds: 20), () {
      if (!mounted) return;

      setState(() {
        isFloating = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;

      setState(() {
        floatingText = null;
        isFloating = false;
      });
    });
  }

  void handleTap() {
    showFloatingText("+1");
    widget.onTap?.call();
  }

  void handleLogPress() {
    showFloatingText("-1");
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                offset: Offset(4, 5),
                blurRadius: 6,
              ),
            ],
          ),
          child: Material(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: handleTap,
              onLongPress: handleLogPress,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(widget.iconData, color: colors.primary, size: 30),
                    SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: widget.title,
                            variant: TextWidgetStyle.body,
                          ),
                          SizedBox(height: 2),
                          TextWidget(
                            text: "${widget.volume} ${widget.unit}",
                            variant: TextWidgetStyle.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (floatingText != null)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            top: isFloating ? -24 : 4,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: isFloating ? 0 : 1,
              child: Text(
                floatingText!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
