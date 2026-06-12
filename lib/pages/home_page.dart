import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/text.dart';

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
            Image.asset('assets/images/wolf-pointing-left.png'),
            SizedBox(height: 20),
            Container(
              color: AppColors.primary,
              width: double.infinity,
              child: TextApp(
                "aran ganteng",
                AppColors.neutral,
                variant: TextVariantApp.h1,
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(onPressed: () => {}, child: Text("Test Button")),
          ],
        ),
      ),
    );
  }
}
