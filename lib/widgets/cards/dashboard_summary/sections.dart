import 'package:flutter/material.dart';
import 'package:water_intake_logger/widgets/cards/dashboard_summary/card.dart';

class DashboardSummaryItems {
  final IconData iconData;
  final String title;
  final String caption;

  const DashboardSummaryItems({
    required this.iconData,
    required this.title,
    required this.caption,
  });
}

class DashboardSummarySections extends StatelessWidget {
  final List<DashboardSummaryItems> items;

  const DashboardSummarySections({required this.items, super.key})
    : assert(items.length >= 2, 'Minimal 2 card');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == items.length - 1 ? 0 : 12,
              ),
              child: DashboardSummaryCard(
                iconData: item.iconData,
                title: item.title,
                caption: item.caption,
              ),
            ),
          );
        }),
      ),
    );
  }
}
