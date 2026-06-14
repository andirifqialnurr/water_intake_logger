import 'package:flutter/material.dart';
import 'package:water_intake_logger/widgets/floating_appbar_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 90),
              child: Center(child: Text("Ini halaman home")),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: FloatingAppbarWidget(
                title: "Aran jenius",
                onProfileTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
