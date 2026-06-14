import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: BackButton(onPressed: () => Navigator.pushNamed(context, '/')),
      ),
      body: const Center(child: Text('ini halaman settings')),
    );
  }
}
