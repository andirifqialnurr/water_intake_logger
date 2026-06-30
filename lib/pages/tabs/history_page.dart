import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_state.dart';
// import 'package:water_intake_logger/language/language_scope.dart';

import 'package:water_intake_logger/features/hydration/bloc/hydration_bloc.dart';
import 'package:water_intake_logger/pages/history_detail_page.dart';
import 'package:water_intake_logger/widgets/cards/history_list_tile/sections.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    // final languageController = LanguageScope.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HydrationBloc, HydrationState>(
          builder: (context, state) {
            if (state is HydrationLoading || state is HydrationInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HydrationFailure) {
              return Center(child: Text(state.message));
            }

            if (state is! HydrationSuccess) {
              return const SizedBox.shrink();
            }

            final items = state.history.map((day) {
              return HistoryListTileItems(
                isAchieved: day.isAchieved,
                date: _formatDate(day.date),
                goal: day.targetLiterText,
                achieved: day.totalLiterText,
                isExceeded: day.isExceeded,
                percentage: day.percentage,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HistoryDetailPage(date: day.date),
                    ),
                  );
                },
              );
            }).toList();

            if (items.isEmpty && state.entryLogs.isEmpty) {
              return const Center(child: Text('Belum ada riwayat minum'));
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [HistoryListTileSections(items: items)],
            );
          },
        ),
      ),
    );
  }
}
