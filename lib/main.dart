import 'package:flutter/material.dart';
import 'package:water_intake_logger/page_tab_controller.dart';
import 'package:water_intake_logger/theme/app_theme.dart';
import 'package:water_intake_logger/theme/theme_controller.dart';
import 'package:water_intake_logger/theme/theme_scope.dart';

void main() {
  runApp(const ThemeScope(child: WaterIntakeLoggerApp()));
}

class WaterIntakeLoggerApp extends StatelessWidget {
  const WaterIntakeLoggerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeController().themeMode,
      initialRoute: '/',
      routes: {'/': (context) => const PageTabController()},
      // home: const HomePage(),
    );
  }
}
