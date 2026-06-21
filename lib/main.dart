import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/design/app_typography.dart';
import 'package:water_intake_logger/page_tab_controller.dart';

void main() {
  runApp(const WaterIntakeLoggerApp());
}

class WaterIntakeLoggerApp extends StatelessWidget {
  const WaterIntakeLoggerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.neutral,
        textTheme: AppTypography.textTheme(Colors.black),
      ),

      initialRoute: '/',
      routes: {'/': (context) => const PageTabController()},
      // home: const HomePage(),
    );
  }
}
