import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? action;
  final Widget? leading;

  const AppbarWidget({
    required this.title,
    this.action,
    this.leading,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.neutral,
      elevation: 0,
      leading: leading,
      actions: action,
    );
  }
}
