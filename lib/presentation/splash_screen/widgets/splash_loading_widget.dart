import 'package:flutter/material.dart';

class SplashLoadingWidget extends StatefulWidget {
  final bool isLoading;

  const SplashLoadingWidget({
    super.key,
    required this.isLoading,
  });

  @override
  State<SplashLoadingWidget> createState() => _SplashLoadingWidgetState();
}

class _SplashLoadingWidgetState extends State<SplashLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializePulseAnimation();
  }

  void _initializePulseAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isLoading) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SplashLoadingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLoading ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Custom loading indicator with food-themed animation
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer rotating ring
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _pulseController.value * 2 * 3.14159,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: CustomPaint(
                          painter: _LoadingRingPainter(
                            progress: _pulseController.value,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Center pulsing dot
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Loading dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final delay = index * 0.3;
                  final animationValue = (_pulseController.value + delay) % 1.0;
                  final opacity = (animationValue < 0.5)
                      ? animationValue * 2
                      : (1.0 - animationValue) * 2;

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withValues(alpha: opacity.clamp(0.3, 1.0)),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _LoadingRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _LoadingRingPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - paint.strokeWidth) / 2;

    // Draw arc based on progress
    final sweepAngle = 2 * 3.14159 * 0.75; // 75% of circle
    final startAngle = -3.14159 / 2; // Start from top

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_LoadingRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
