import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/badges/verified_badge_widget.dart';
import 'package:water_intake_logger/widgets/profile/painter.dart';
import 'dart:math' as math;

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

  bool _showStaticRing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showStaticRing = true;
        });
      }
    });
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
          AnimatedOpacity(
            opacity: _showStaticRing ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: CustomPaint(
              size: const Size(180, 180),
              painter: StaticProfileRingPainter(),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              if (_showStaticRing) {
                return const SizedBox.shrink();
              }
              return CustomPaint(
                size: const Size(180, 180),
                painter: RotatingRingPainter(
                  progress: Curves.easeInOutCubic.transform(_controller.value),
                ),
              );
            },
          ),
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(
              'assets/images/pexels-pixabay-302769.jpg',
            ),
          ),
          Positioned(
            right: 20,
            bottom: 30,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final progress = Curves.easeInOutCubic.transform(
                  _controller.value,
                );
                final angle = -2 * math.pi * progress;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  child: child,
                );
              },
              child: VerifiedBadgeWidget(),
            ),
          ),
        ],
      ),
    );
  }
}

class StaticProfileRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const strokewidth = 8.0;

    final center = size.center(Offset.zero);
    final radius = (size.width / 2) - strokewidth;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokewidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.outline.withAlpha(30);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
