import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_intake_logger/data/local/app_database.dart';
import 'package:water_intake_logger/data/repositories/hydration_repository.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_bloc.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_event.dart';
import 'package:water_intake_logger/language/language_scope.dart';
import 'package:water_intake_logger/page_tab_controller.dart';
import 'package:water_intake_logger/theme/app_theme.dart';
import 'package:water_intake_logger/theme/theme_scope.dart';

void main() {
  runApp(const ThemeScope(child: LanguageScope(child: WaterIntakeLoggerApp())));
}

class WaterIntakeLoggerApp extends StatefulWidget {
  const WaterIntakeLoggerApp({super.key});

  @override
  State<WaterIntakeLoggerApp> createState() => _WaterIntakeLoggerAppState();
}

class _WaterIntakeLoggerAppState extends State<WaterIntakeLoggerApp> {
  late final AppDatabase _database;
  late final HydrationRepository _hydrationRepository;

  @override
  void initState() {
    super.initState();

    _database = AppDatabase();
    _hydrationRepository = HydrationRepository(_database);
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeScope.of(context);

    return BlocProvider(
      create: (_) =>
          HydrationBloc(repository: _hydrationRepository)
            ..add(const HydrationStarted()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.themeMode,
        initialRoute: '/',
        routes: {'/': (context) => const PageTabController()},
        // home: const HomePage(),
      ),
    );
  }
}
