import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_bloc.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_event.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_state.dart';
import 'package:water_intake_logger/language/app_strings.dart';
import 'package:water_intake_logger/language/language_scope.dart';
import 'package:water_intake_logger/widgets/cards/button_add_water/sections.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

import 'package:water_intake_logger/theme/app_theme_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                TextWidget(
                  text: languageController.strings.greetings,
                  variant: TextWidgetStyle.body,
                  color: colors.onSurfaceMuted,
                ),
                TextWidget(
                  text: languageController.strings.slogan,
                  variant: TextWidgetStyle.headline,
                ),
                SizedBox(height: 40),
                CircleAvatar(
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
                        SizedBox(height: 8),
                        TextWidget(
                          text: "${totalMl}ml / ${targetMl}ml",
                          variant: TextWidgetStyle.subtitle,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
