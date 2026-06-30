import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_event.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_state.dart';
// import 'package:water_intake_logger/language/language_scope.dart';

import 'package:water_intake_logger/features/hydration/bloc/hydration_bloc.dart';
import 'package:water_intake_logger/features/hydration/models/hydration_entry_log.dart';
import 'package:water_intake_logger/widgets/cards/history_list_tile/sections.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String _formatAmount(HydrationEntryLog entry) {
    final prefix = entry.isCorrection ? '-' : '+';
    return '$prefix${entry.displayAmountMl} ml';
  }

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

  Future<void> _showEditDialog(
    BuildContext context,
    HydrationEntryLog entry,
  ) async {
    final controller = TextEditingController(
      text: entry.displayAmountMl.toString(),
    );

    final amountMl = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit jumlah minum'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Jumlah ml'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                final value = int.tryParse(controller.text.trim());

                if (value == null || value <= 0) return;

                Navigator.pop(dialogContext, value);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (!context.mounted || amountMl == null) return;

    context.read<HydrationBloc>().add(
      HydrationEntryAmountChanged(entryId: entry.id, amountMl: amountMl),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    HydrationEntryLog entry,
  ) async {
    final shouldDelete = await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus entry?'),
          content: Text(
            '${_formatAmount(entry)} pada ${_formatTime(entry.consumeAt)} akan di hapus.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (!context.mounted || shouldDelete != true) return;

    context.read<HydrationBloc>().add(HydrationEntryDeleted(entryId: entry.id));
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
              );
            }).toList();

            if (items.isEmpty && state.entryLogs.isEmpty) {
              return const Center(child: Text('Belum ada riwayat minum'));
            }

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                if (items.isNotEmpty) ...[
                  HistoryListTileSections(items: items),
                  const SizedBox(height: 24),
                ],

                const Text(
                  'Detail Entry',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),
                ...state.entryLogs.map((entry) {
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        entry.isCorrection
                            ? Icons.remove_circle_outline
                            : Icons.water_drop_rounded,
                      ),
                      title: Text(_formatAmount(entry)),
                      subtitle: Text(
                        '${_formatTime(entry.consumeAt)} - ${entry.sourceLabel}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _showEditDialog(context, entry),
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => _confirmDelete(context, entry),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
