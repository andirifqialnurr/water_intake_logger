import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/design/app_typography.dart';
import 'package:water_intake_logger/pages/home_page.dart';
import 'package:water_intake_logger/pages/profile_page.dart';

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
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.neutral,
        ),
        textTheme: AppTypography.textTheme(Colors.black),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
      },
      // home: const HomePage(),
    );
  }
}
