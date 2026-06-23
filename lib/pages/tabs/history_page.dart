import 'package:flutter/material.dart';
import 'package:water_intake_logger/language/app_strings.dart';
import 'package:water_intake_logger/language/language_scope.dart';
import 'package:water_intake_logger/widgets/cards/history_list_tile/sectoins.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = LanguageScope.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            HistoryListTileSections(
              items: [
                HistoryListTileItems(
                  isAchieved: true,
                  date: "${languageController.strings.dateCard}, Jun 27",
                  goal: "1.5",
                  achieved: "2.1",
                ),
                HistoryListTileItems(
                  isAchieved: false,
                  date: "Jan 27,  2026",
                  goal: "2.0",
                  achieved: "1.8",
                ),
                HistoryListTileItems(
                  isAchieved: true,
                  date: "Feb 27, 2026",
                  goal: "1.0",
                  achieved: "2.8",
                ),
                HistoryListTileItems(
                  isAchieved: true,
                  date: "Mar 13, 2026",
                  goal: "2.5",
                  achieved: "2.1",
                ),
                HistoryListTileItems(
                  isAchieved: false,
                  date: "Apr 01, 2026",
                  goal: "1.5",
                  achieved: "1.0",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
