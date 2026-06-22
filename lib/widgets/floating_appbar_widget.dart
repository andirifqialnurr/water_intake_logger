import 'package:flutter/material.dart';
import 'package:water_intake_logger/language/language_scope.dart';
import 'package:water_intake_logger/theme/app_theme_colors.dart';
import 'package:water_intake_logger/widgets/language_switch.dart';
import 'package:water_intake_logger/widgets/text_widget.dart';
import 'package:water_intake_logger/language/language_controller.dart';

class FloatingAppbarWidget extends StatelessWidget {
  final String title;
  final String profileImagePath;

  const FloatingAppbarWidget({
    required this.title,
    required this.profileImagePath,
    super.key,
  });

  void _showLanguagePicker(
    BuildContext context,
    LanguageController languageController,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text(
                  '\u{1F1EE}\u{1F1E9}',
                  style: TextStyle(fontSize: 22),
                ),
                title: const Text('Indonesia'),
                trailing: const Text('IND'),
                onTap: () {
                  languageController.setLanguage(AppLanguage.ind);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Text(
                  '\u{1F1EC}\u{1F1E7}',
                  style: TextStyle(fontSize: 22),
                ),
                title: const Text('English'),
                trailing: const Text('ENG'),
                onTap: () {
                  languageController.setLanguage(AppLanguage.eng);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final languageController = LanguageScope.of(context);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colors.navBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: colors.shadow, blurRadius: 6, offset: Offset(1, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: colors.primary,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(profileImagePath),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextWidget(text: title, variant: TextWidgetStyle.subtitle),
          ),
          const SizedBox(width: 20),
          LanguageSwitch(
            languageCode: languageController.languageCode,
            flag: languageController.flag,
            onTap: () => _showLanguagePicker(context, languageController),
          ),
        ],
      ),
    );
  }
}
