import 'package:flutter/material.dart';
import 'package:water_intake_logger/pages/settings_page.dart';
import 'package:water_intake_logger/widgets/floating_appbar_widget.dart';

class PageTabController extends StatefulWidget {
  const PageTabController({super.key});

  @override
  State<PageTabController> createState() => _PageTabControllerState();
}

class _PageTabControllerState extends State<PageTabController> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Ini halaman home')),
    Center(child: Text('Ini halaman history')),
    Center(child: Text('Ini halaman progress')),
  ];

  final List<String> _title = const ['Home', 'History', 'Progress'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 96,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: _pages[_currentIndex],
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: FloatingAppbarWidget(
                title: _title[_currentIndex],
                profileImagePath: 'assets/images/wolf-pointing-left.png',
                onSettingTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}
