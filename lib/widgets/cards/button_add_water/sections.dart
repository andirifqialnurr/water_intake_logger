import 'package:flutter/material.dart';
import 'package:water_intake_logger/widgets/cards/button_add_water/card.dart';

class ButtonAddWaterItems {
  final IconData iconData;
  final String title;
  final int volume;
  final String unit;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ButtonAddWaterItems({
    required this.iconData,
    required this.title,
    required this.volume,
    required this.unit,
    required this.backgroundColor,
    this.onTap,
    this.onLongPress,
  });
}

class ButtonAddWaterSections extends StatelessWidget {
  final List<ButtonAddWaterItems> items;

  const ButtonAddWaterSections({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    const gap = 12.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - gap) / 2;

        return SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: items.map((item) {
              return SizedBox(
                width: cardWidth,
                child: ButtonAddWaterCard(
                  iconData: item.iconData,
                  title: item.title,
                  volume: item.volume,
                  unit: item.unit,
                  backgroundColor: item.backgroundColor,
                  onTap: item.onTap,
                  onLongPress: item.onLongPress,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
