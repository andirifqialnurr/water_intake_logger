import 'package:flutter/material.dart';
import 'package:water_intake_logger/pages/tabs/history_page.dart';
import 'package:water_intake_logger/pages/tabs/home_page.dart';
import 'package:water_intake_logger/pages/tabs/profile_page.dart';
import 'package:water_intake_logger/pages/tabs/progress_page.dart';
import 'package:water_intake_logger/widgets/floating_appbar_widget.dart';
import 'package:water_intake_logger/widgets/floating_bottombar_widget.dart';

class PageTabController extends StatefulWidget {
  const PageTabController({super.key});

  @override
  State<PageTabController> createState() => _PageTabControllerState();
}

class _PageTabControllerState extends State<PageTabController> {
  int _currentIndex = 0;
  // int _profileAnimationToken = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ProgressPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  final List<String> _title = const ['Home', 'Progress', 'History', 'Profile'];

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
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FloatingBottombarWidget(
        currentIndex: _currentIndex,
        items: const [
          FloatingNavItem(icon: Icons.water_drop_outlined),
          FloatingNavItem(icon: Icons.bar_chart_rounded),
          FloatingNavItem(icon: Icons.history_rounded),
          FloatingNavItem(icon: Icons.person_2_outlined),
        ],
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        onDoubleTap: (value) {
          if (value != 3) return;

          setState(() {
            _currentIndex = value;
            // _profileAnimationToken++;
          });
        },
      ),
    );
  }
}
