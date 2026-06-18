import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/cards/button_add_water/sections.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextWidget(
              text: "Good Morning, Aran",
              variant: TextWidgetStyle.body,
              color: AppColors.onSecondaryContainer,
            ),
            TextWidget(
              text: "Stay Hydrated",
              variant: TextWidgetStyle.headline,
            ),
            SizedBox(height: 40),
            CircleAvatar(
              radius: 150,
              child: CircleAvatar(
                radius: 140,
                backgroundColor: AppColors.outlineVariant,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(text: "75%", variant: TextWidgetStyle.display),
                    SizedBox(height: 8),
                    TextWidget(
                      text: "1500 / 2000ml",
                      variant: TextWidgetStyle.subtitle,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            ButtonAddWaterSections(
              items: [
                ButtonAddWaterItems(
                  iconData: Icons.coffee,
                  title: "Cup",
                  volume: 250,
                  unit: "ml",
                  backgroundColor: AppColors.onTertiaryContainer,
                  onTap: () {},
                  onLongPress: () {},
                ),
                ButtonAddWaterItems(
                  iconData: Icons.water_drop_outlined,
                  title: "Bottle",
                  volume: 700,
                  unit: "ml",
                  backgroundColor: AppColors.onPrimaryContainer,
                  onTap: () {},
                  onLongPress: () {},
                ),
                ButtonAddWaterItems(
                  iconData: Icons.local_drink,
                  title: "Glass",
                  volume: 500,
                  unit: "ml",
                  backgroundColor: AppColors.onTertiaryContainer,
                  onTap: () {},
                  onLongPress: () {},
                ),
                ButtonAddWaterItems(
                  iconData: Icons.hourglass_bottom_outlined,
                  title: "Thumbler",
                  volume: 1,
                  unit: "liter",
                  backgroundColor: AppColors.onPrimary,
                  onTap: () {},
                  onLongPress: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
