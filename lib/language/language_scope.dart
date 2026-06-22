import 'package:flutter/material.dart';
import 'package:water_intake_logger/language/language_controller.dart';

class LanguageScope extends StatefulWidget {
  const LanguageScope({required this.child, super.key});

  final Widget child;

  static LanguageController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_LanguageInherited>();
    assert(scope != null, 'LanguageScope tidak ditemukan di widget tree');
    return scope!.notifier!;
  }

  @override
  State<LanguageScope> createState() => _LanguageScopeState();
}

class _LanguageScopeState extends State<LanguageScope> {
  late final LanguageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LanguageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _LanguageInherited(controller: _controller, child: widget.child);
  }
}

class _LanguageInherited extends InheritedNotifier<LanguageController> {
  const _LanguageInherited({
    required LanguageController controller,
    required super.child,
  }) : super(notifier: controller);
}
