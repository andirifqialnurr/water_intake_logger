import 'package:flutter/material.dart';
import 'package:water_intake_logger/widgets/cards/history_list_tile/card.dart';

class HistoryListTileItems {
  final bool isAchieved;
  final bool isExceeded;
  final String date;
  final String goal;
  final String achieved;
  final int percentage;

  const HistoryListTileItems({
    required this.isAchieved,
    required this.isExceeded,
    required this.date,
    required this.goal,
    required this.achieved,
    required this.percentage,
  });
}

class HistoryListTileSections extends StatelessWidget {
  final List<HistoryListTileItems> items;

  const HistoryListTileSections({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    const gap = 12.0;

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: gap,
        runSpacing: gap,
        children: items.map((item) {
          return SizedBox(
            child: HistoryCardWidget(
              date: item.date,
              goal: item.goal,
              achieved: item.achieved,
              isAchieved: item.isAchieved,
              isExceeded: item.isExceeded,
              percentage: item.percentage,
            ),
          );
        }).toList(),
      ),
    );
  }
}
