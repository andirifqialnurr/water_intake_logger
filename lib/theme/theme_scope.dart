import 'package:flutter/material.dart';
import 'package:water_intake_logger/theme/theme_controller.dart';

class ThemeScope extends StatefulWidget {
  const ThemeScope({required this.child, super.key});

  final Widget child;

  static ThemeController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ThemeInherited>();
    assert(scope != null, 'ThemeScope tidak ditemukan di widget tree');
    return scope!.notifier!;
  }

  @override
  State<ThemeScope> createState() => _ThemeScopeState();
}

class _ThemeScopeState extends State<ThemeScope> {
  late final ThemeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ThemeController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller = ThemeController();
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeInherited(controller: _controller, child: widget.child);
  }
}

class _ThemeInherited extends InheritedNotifier<ThemeController> {
  const _ThemeInherited({
    required ThemeController controller,
    required super.child,
  }) : super(notifier: controller);
}
