import 'package:flutter/material.dart';
import 'package:water_intake_logger/widgets/floating_appbar_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 90),
              child: Center(child: Text("Ini halaman profile")),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: FloatingAppbarWidget(
                title: "Aran jenius",
                onProfileTap: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
