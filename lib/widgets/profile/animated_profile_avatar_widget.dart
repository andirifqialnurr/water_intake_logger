import 'package:flutter/material.dart';
import 'package:water_intake_logger/const/app_color.dart';
import 'package:water_intake_logger/widgets/badges/verified_baged/badge_burst_painter.dart';
import 'package:water_intake_logger/widgets/badges/verified_baged/widget.dart';
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
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _burstController;

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

        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          _burstController.forward(from: 0);
        });
      }
    });

    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _burstController.dispose();
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
            animation: Listenable.merge([_controller, _burstController]),
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

          // Badge
          Positioned(
            right: 8,
            bottom: 27,
            child: SizedBox(
              width: 50,
              height: 50,
              child: AnimatedBuilder(
                animation: Listenable.merge([_controller, _burstController]),
                builder: (context, child) {
                  final t = _controller.value;

                  final zoomIn = const Interval(
                    0.0,
                    0.18,
                    curve: Curves.easeOutBack,
                  ).transform(t);

                  final rotate = const Interval(
                    0.18,
                    0.78,
                    curve: Curves.easeInOutCubic,
                  ).transform(t);

                  final zoomOut = const Interval(
                    0.78,
                    1.0,
                    curve: Curves.easeInCubic,
                  ).transform(t);

                  final burst = Curves.easeOutCubic.transform(
                    _burstController.value,
                  );
                  // final burst = const Interval(
                  //   0.72,
                  //   1.0,
                  //   curve: Curves.easeOutCubic,
                  // ).transform(t);

                  final scale = 1.0 + (0.18 * zoomIn) - (0.18 * zoomOut);
                  final angle = -2 * math.pi * rotate;

                  final normalizedAngle = angle.abs() % (2 * math.pi);
                  final isBackVisible =
                      normalizedAngle > math.pi / 2 &&
                      normalizedAngle < 3 * math.pi / 2;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(68, 68),
                        painter: BadgeBurstPainter(progress: burst),
                      ),
                      Transform.scale(
                        scale: scale,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateY(angle),
                          child: isBackVisible
                              ? Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..rotateY(math.pi),
                                  child: const VerifiedBadgeBackWidget(),
                                )
                              : const VerifiedBadgeWidget(),
                        ),
                      ),
                    ],
                  );
                },
                child: VerifiedBadgeWidget(),
              ),
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
