import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_bloc.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_event.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_state.dart';
import 'package:water_intake_logger/features/hydration/models/hydration_entry_log.dart';
import 'package:water_intake_logger/language/app_strings.dart';
import 'package:water_intake_logger/language/language_scope.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class HistoryDetailPage extends StatelessWidget {
  final DateTime date;

  const HistoryDetailPage({required this.date, super.key});

  String _dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final mounth = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$mounth-$day';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
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

  String _formatAmount(HydrationEntryLog entry) {
    final prefix = entry.isCorrection ? '-' : '+';
    return '$prefix${entry.displayAmountMl} ml';
  }

  List<_PresetOption> _presets(BuildContext context) {
    final strings = LanguageScope.of(context).strings;

    return [
      _PresetOption(amountMl: 250, label: strings.button1, icon: Icons.coffee),
      _PresetOption(
        amountMl: 700,
        label: strings.button2,
        icon: Icons.water_drop_outlined,
      ),
      _PresetOption(
        amountMl: 500,
        label: strings.button3,
        icon: Icons.local_drink,
      ),
      _PresetOption(
        amountMl: 1000,
        label: strings.button4,
        icon: Icons.hourglass_bottom_outlined,
      ),
    ];
  }

  Future<void> _showEditPresetPicker(
    BuildContext context,
    HydrationEntryLog entry,
  ) async {
    final colors = context.colors;

    final selected = await showModalBottomSheet<_PresetOption>(
      context: context,
      backgroundColor: colors.surface,
      builder: (sheetContext) {
        final options = _presets(sheetContext);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Pilih jumlah',
                  variant: TextWidgetStyle.title,
                ),
                const SizedBox(height: 12),
                ...options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: colors.surfaceMuted,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => Navigator.pop(sheetContext, option),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Icon(option.icon, color: colors.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextWidget(
                                  text: option.label,
                                  variant: TextWidgetStyle.body,
                                ),
                              ),
                              TextWidget(
                                text: '${option.amountMl} ml',
                                variant: TextWidgetStyle.buttonLabel,
                                color: colors.onSurfaceMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

    if (!context.mounted || selected == null) return;

    context.read<HydrationBloc>().add(
      HydrationEntryAmountChanged(
        entryId: entry.id,
        amountMl: selected.amountMl,
        sourceLabel: selected.label,
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    HydrationEntryLog entry,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus entry?'),
          content: Text(
            '${_formatAmount(entry)} pada ${_formatTime(entry.consumeAt)} akan dihapus',
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
    final colors = context.colors;
    final selectedDateKey = _dateKey(date);

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

            final entries =
                state.entryLogs
                    .where((entry) => entry.localDate == selectedDateKey)
                    .toList()
                  ..sort((a, b) => a.consumeAt.compareTo(b.consumeAt));

            final summary = state.history
                .where((item) => _dateKey(item.date) == selectedDateKey)
                .firstOrNull;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        color: colors.onSurface,
                      ),
                    ),
                    Expanded(
                      child: TextWidget(
                        text: _formatDate(date),
                        variant: TextWidgetStyle.title,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow,
                        blurRadius: 5,
                        offset: const Offset(1, 5),
                      ),
                    ],
                  ),
                  child: TextWidget(
                    text: summary == null
                        ? 'Belum ada entry'
                        : '${summary.totalLiterText} L / ${summary.targetLiterText} L',
                    variant: TextWidgetStyle.subtitle,
                  ),
                ),
                const SizedBox(height: 24),
                TextWidget(text: 'Entry Minum', variant: TextWidgetStyle.title),
                const SizedBox(height: 12),
                if (entries.isEmpty)
                  TextWidget(
                    text: 'Tidak ada entry minum pada tanggal ini',
                    variant: TextWidgetStyle.body,
                    color: colors.onSurfaceMuted,
                  )
                else
                  ...entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              Icon(
                                entry.isCorrection
                                    ? Icons.remove_circle_outline
                                    : Icons.water_drop_rounded,
                                color: entry.isCorrection
                                    ? colors.error
                                    : colors.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: _formatAmount(entry),
                                      variant: TextWidgetStyle.body,
                                    ),
                                    TextWidget(
                                      text:
                                          '${_formatTime(entry.consumeAt)} - ${entry.sourceLabel}',
                                      variant: TextWidgetStyle.caption,
                                      color: colors.onSurfaceMuted,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _showEditPresetPicker(context, entry),
                                icon: Icon(Icons.edit, color: colors.primary),
                              ),
                              IconButton(
                                onPressed: () => _confirmDelete(context, entry),
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: colors.error,
                                ),
                              ),
                            ],
                          ),
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

class _PresetOption {
  final int amountMl;
  final String label;
  final IconData icon;

  const _PresetOption({
    required this.amountMl,
    required this.label,
    required this.icon,
  });
}
