import 'package:flutter/material.dart';
import 'package:water_intake_logger/widgets/cards/history_list_tile/card.dart';
import 'package:water_intake_logger/widgets/cards/history_list_tile/sectoins.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: HistoryListTileSections(
            items: [
              HistoryListTileItems(
                isAchieved: true,
                date: "Today, Jun 27",
                goal: "1.5 L",
                achieved: "2.1 L",
              ),
              HistoryListTileItems(
                isAchieved: false,
                date: "Jan 27,  2026",
                goal: "2.0 L",
                achieved: "1.8 L",
              ),
              HistoryListTileItems(
                isAchieved: true,
                date: "Feb 27, 2026",
                goal: "1.0 L",
                achieved: "2.8 L",
              ),
              HistoryListTileItems(
                isAchieved: true,
                date: "Mar 13, 2026",
                goal: "2.5 L",
                achieved: "2.1 L",
              ),
              HistoryListTileItems(
                isAchieved: false,
                date: "Apr 01, 2026",
                goal: "1.5 L",
                achieved: "1.0 L",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
