import 'package:flutter/material.dart';
import 'package:water_intake_logger/widgets/badges/verified_badge_widget.dart';
import 'package:water_intake_logger/widgets/profile/painter.dart';

class AnimatedProfileAvatarWidget extends StatefulWidget {
  const AnimatedProfileAvatarWidget({super.key});

  @override
  State<AnimatedProfileAvatarWidget> createState() =>
      _AnimatedProfileAvatarWidgetState();
}

class _AnimatedProfileAvatarWidgetState
    extends State<AnimatedProfileAvatarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _controller,
            child: CustomPaint(
              size: const Size(180, 180),
              painter: RotatingRingPainter(),
            ),
          ),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
          Positioned(right: 20, bottom: 30, child: VerifiedBadgeWidget()),
        ],
      ),
    );
  }
}
