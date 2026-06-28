import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_bloc.dart';
import 'package:water_intake_logger/features/hydration/bloc/hydration_state.dart';
import 'package:water_intake_logger/language/app_strings.dart';
import 'package:water_intake_logger/language/language_scope.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';
import 'package:water_intake_logger/theme/theme_scope.dart';
import 'package:water_intake_logger/widgets/cards/dashboard_summary/sections.dart';
import 'package:water_intake_logger/widgets/inner_thumb_switch.dart';
import 'package:water_intake_logger/widgets/profile/animated_profile_avatar_widget.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _avatarAnimationToken = 0;

  void _replayAvatarAnimation() {
    setState(() {
      _avatarAnimationToken++;
    });
  }

  String _sinceLastDrinkText(DateTime? lastDrinkAt) {
    if (lastDrinkAt == null) return "-";

    final difference = DateTime.now().difference(lastDrinkAt);

    if (difference.inMinutes < 1) return '0 m';
    if (difference.inMinutes < 60) return '${difference.inHours} m';
    if (difference.inHours < 24) return '${difference.inHours} h';

    return '${difference.inDays} d';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final themeController = ThemeScope.of(context);
    final isDarkMode = themeController.isDarkMode;

    final languageController = LanguageScope.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: _replayAvatarAnimation,
      child: Scaffold(
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

              final profileSummary = state.profileSummary;
              final sinceLastDrinkText = _sinceLastDrinkText(
                profileSummary.lastDrinkAt,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Column(
                    children: [
                      AnimatedProfileAvatarWidget(
                        animationToken: _avatarAnimationToken,
                      ),
                      SizedBox(height: 10),
                      TextWidget(
                        text: "Aran",
                        variant: TextWidgetStyle.headline,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.water_drop_outlined,
                            size: 14,
                            color: colors.primary,
                          ),
                          SizedBox(width: 6),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "${languageController.strings.lifeTime} :  ",
                                ),
                                TextSpan(
                                  text:
                                      "${profileSummary.lifetimeLiterText} ${languageController.strings.liter}",
                                  style: TextStyle(color: colors.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                  DashboardSummarySections(
                    items: [
                      DashboardSummaryItems(
                        iconData: Icons.fireplace_outlined,
                        title:
                            "${profileSummary.currentStreakDays} ${languageController.strings.day}",
                        caption: languageController.strings.labelWinCard,
                      ),
                      DashboardSummaryItems(
                        iconData: Icons.timer,
                        title: sinceLastDrinkText,
                        caption: languageController.strings.labelSince,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  TextWidget(
                    text: languageController.strings.settingModeLabel,
                    variant: TextWidgetStyle.subtitle,
                  ),
                  SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: colors.surface,
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              isDarkMode
                                  ? Icons.dark_mode_rounded
                                  : Icons.wb_sunny_rounded,
                              size: 20,
                              color: colors.onSurface,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextWidget(
                                text: isDarkMode
                                    ? languageController.strings.darkMode
                                    : languageController.strings.lightMode,
                                variant: TextWidgetStyle.body,
                              ),
                            ),
                            InnerThumbSwitch(
                              value: isDarkMode,
                              onChanged: themeController.setDarkMode,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
