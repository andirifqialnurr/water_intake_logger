import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_bloc.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_event.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_state.dart';
import 'package:water_intake_logger/language/app_strings.dart';
import 'package:water_intake_logger/language/language_scope.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';
import 'package:water_intake_logger/widgets/cards/button_add_water/sections.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _showCustomAddWaterSheet(BuildContext context) async {
    final colors = context.colors;

    final result = await showModalBottomSheet<_CustomAddWaterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      builder: (_) => const _CustomAddWaterSheet(),
    );

    if (!context.mounted || result == null) return;

    context.read<HydrationBloc>().add(
      HydrationWaterAdded(
        amountMl: result.amountMl,
        sourceType: 'manual',
        sourceLabel: result.sourceLabel,
      ),
    );
  }

  Widget _buildCustomAddWaterCard(BuildContext context) {
    final colors = context.colors;
    final strings = LanguageScope.of(context).strings;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            offset: const Offset(4, 5),
            blurRadius: 6,
          ),
        ],
      ),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showCustomAddWaterSheet(context),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.primarySoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.add_rounded, color: colors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: strings.customAddWater,
                        variant: TextWidgetStyle.body,
                      ),
                      const SizedBox(height: 2),
                      TextWidget(
                        text: strings.customAddWaterHint,
                        variant: TextWidgetStyle.caption,
                        color: colors.onSurfaceMuted,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colors.onSurfaceMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final languageController = LanguageScope.of(context);

    return Scaffold(
      body: BlocBuilder<HydrationBloc, HydrationState>(
        builder: (context, state) {
          if (state is HydrationLoading || state is HydrationInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HydrationFailure) {
            return Center(child: Text(state.message));
          }
          final summary = state is HydrationSuccess ? state.summary : null;

          final percentage = summary?.percentage ?? 0;
          final totalMl = summary?.totalMl ?? 0;
          final targetMl = summary?.targetMl ?? 2000;

          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const SizedBox(height: 20),
              Center(
                child: TextWidget(
                  text: languageController.strings.greetings,
                  variant: TextWidgetStyle.body,
                  color: colors.onSurfaceMuted,
                ),
              ),
              Center(
                child: TextWidget(
                  text: languageController.strings.slogan,
                  variant: TextWidgetStyle.headline,
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: CircleAvatar(
                  radius: 150,
                  backgroundColor: colors.primarySoft,
                  child: CircleAvatar(
                    radius: 140,
                    backgroundColor: colors.surfaceMuted,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: "$percentage%",
                          variant: TextWidgetStyle.display,
                        ),
                        const SizedBox(height: 8),
                        TextWidget(
                          text: "${totalMl}ml / ${targetMl}ml",
                          variant: TextWidgetStyle.subtitle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ButtonAddWaterSections(
                items: [
                  ButtonAddWaterItems(
                    iconData: Icons.coffee,
                    title: languageController.strings.button1,
                    volume: 250,
                    unit: "ml",
                    backgroundColor: colors.surface,
                    onTap: () {
                      context.read<HydrationBloc>().add(
                        HydrationWaterAdded(
                          amountMl: 250,
                          sourceType: 'preset',
                          sourceLabel: languageController.strings.button1,
                        ),
                      );
                    },
                    onLongPress: () {
                      context.read<HydrationBloc>().add(
                        HydrationWaterRemoved(
                          amountMl: 250,
                          sourceType: 'preset_removed',
                          sourceLabel: languageController.strings.button1,
                        ),
                      );
                    },
                  ),
                  ButtonAddWaterItems(
                    iconData: Icons.water_drop_outlined,
                    title: languageController.strings.button2,
                    volume: 700,
                    unit: "ml",
                    backgroundColor: colors.surface,
                    onTap: () {
                      context.read<HydrationBloc>().add(
                        HydrationWaterAdded(
                          amountMl: 700,
                          sourceType: 'preset',
                          sourceLabel: languageController.strings.button2,
                        ),
                      );
                    },
                    onLongPress: () {
                      context.read<HydrationBloc>().add(
                        HydrationWaterRemoved(
                          amountMl: 700,
                          sourceType: 'preset_removed',
                          sourceLabel: languageController.strings.button2,
                        ),
                      );
                    },
                  ),
                  ButtonAddWaterItems(
                    iconData: Icons.local_drink,
                    title: languageController.strings.button3,
                    volume: 500,
                    unit: "ml",
                    backgroundColor: colors.surface,
                    onTap: () {
                      context.read<HydrationBloc>().add(
                        HydrationWaterAdded(
                          amountMl: 500,
                          sourceType: 'preset',
                          sourceLabel: languageController.strings.button3,
                        ),
                      );
                    },
                    onLongPress: () {
                      context.read<HydrationBloc>().add(
                        HydrationWaterRemoved(
                          amountMl: 500,
                          sourceType: 'preset_removed',
                          sourceLabel: languageController.strings.button3,
                        ),
                      );
                    },
                  ),
                  ButtonAddWaterItems(
                    iconData: Icons.hourglass_bottom_outlined,
                    title: languageController.strings.button4,
                    volume: 1,
                    unit: "liter",
                    backgroundColor: colors.surface,
                    onTap: () {
                      context.read<HydrationBloc>().add(
                        HydrationWaterAdded(
                          amountMl: 1000,
                          sourceType: 'preset',
                          sourceLabel: languageController.strings.button4,
                        ),
                      );
                    },
                    onLongPress: () {
                      context.read<HydrationBloc>().add(
                        HydrationWaterRemoved(
                          amountMl: 1000,
                          sourceType: 'preset_removed',
                          sourceLabel: languageController.strings.button4,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildCustomAddWaterCard(context),
            ],
          );
        },
      ),
    );
  }
}

class _CustomAddWaterResult {
  final int amountMl;
  final String sourceLabel;

  const _CustomAddWaterResult({
    required this.amountMl,
    required this.sourceLabel,
  });
}

class _CustomAddWaterSheet extends StatefulWidget {
  const _CustomAddWaterSheet();

  @override
  State<_CustomAddWaterSheet> createState() => _CustomAddWaterSheetState();
}

class _CustomAddWaterSheetState extends State<_CustomAddWaterSheet> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final strings = LanguageScope.of(context).strings;
    final amount = int.tryParse(_controller.text.trim());

    if (amount == null || amount <= 0) {
      setState(() {
        _errorText = strings.amountPositiveError;
      });
      return;
    }

    Navigator.of(context).pop(
      _CustomAddWaterResult(
        amountMl: amount,
        sourceLabel: strings.customAddWater,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final strings = LanguageScope.of(context).strings;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: strings.customAddWater,
              variant: TextWidgetStyle.title,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: strings.customAmountLabel,
                hintText: strings.customAmountHint,
                suffixText: 'ml',
                errorText: _errorText,
                filled: true,
                fillColor: colors.surfaceMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(strings.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _submit,
                    child: Text(strings.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
