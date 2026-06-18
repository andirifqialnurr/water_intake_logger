import 'package:flutter/material.dart';
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
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RotationTransition(
            turns: _controller,
            child: CustomPaint(
              size: const Size(240, 240),
              painter: RotatingRingPainter(),
            ),
          ),
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
        ],
      ),
    );
  }
}
