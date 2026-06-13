import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/button_widget.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Water Intake Logger", style: TextStyle(fontSize: 20)),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ButtonWidget(
                text: "testing by aran",
                onPressed: () {},
                fullWidth: true,
                variant: ButtonVariantApp.primary,
                icon: Icons.abc,
                isLoading: false,
                key: key,
              ),
            ),
            SizedBox(height: 20),
            TextWidget(text: "aran ganteng", variant: TextWidgetStyle.headline),
          ],
        ),
      ),
    );
  }
}
