import 'dart:math' as math;
import 'package:flutter/material.dart';

enum ConfettiShape { rectangle, circle, star, curvedRibbon, triangle }

class ConfettiParticle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  Color color;
  double rotationX;
  double rotationY;
  double rotationZ;
  double rotationSpeedX;
  double rotationSpeedY;
  double rotationSpeedZ;
  ConfettiShape shape;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.rotationX,
    required this.rotationY,
    required this.rotationZ,
    required this.rotationSpeedX,
    required this.rotationSpeedY,
    required this.rotationSpeedZ,
    required this.shape,
  });
}

class CelebrationConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool isEnabled;

  const CelebrationConfettiOverlay({
    super.key,
    required this.child,
    this.isEnabled = true,
  });

  @override
  State<CelebrationConfettiOverlay> createState() =>
      _CelebrationConfettiOverlayState();
}

class _CelebrationConfettiOverlayState extends State<CelebrationConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final math.Random _random = math.Random();

  final List<Color> _palette = const [
    Color(0xFF2979FF), // Vibrant Blue
    Color(0xFFFFD600), // Vibrant Yellow
    Color(0xFF00E676), // Bright Green
    Color(0xFFFF9100), // Bright Orange
    Color(0xFFFF4081), // Vivid Pink
    Color(0xFF7C4DFF), // Purple
    Color(0xFF00E5FF), // Cyan
    Color(0xFFFF5252), // Bright Red
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    if (widget.isEnabled) {
      _initParticles();
      _controller.repeat();
    }
  }

  void _initParticles() {
    _particles.clear();
    // Start with 120 particles for a rich effect
    for (int i = 0; i < 120; i++) {
      _particles.add(_createParticle(randomizeY: true));
    }
  }

  ConfettiParticle _createParticle({bool randomizeY = false}) {
    // Determine shape with some probability
    final randVal = _random.nextDouble();
    ConfettiShape shape;
    if (randVal < 0.4) {
      shape = ConfettiShape.rectangle;
    } else if (randVal < 0.6) {
      shape = ConfettiShape.circle;
    } else if (randVal < 0.75) {
      shape = ConfettiShape.curvedRibbon;
    } else if (randVal < 0.9) {
      shape = ConfettiShape.triangle;
    } else {
      shape = ConfettiShape.star;
    }

    return ConfettiParticle(
      x: _random.nextDouble(),
      // Spread them vertically initially so they aren't clumped
      y: randomizeY ? -0.1 - _random.nextDouble() * 1.2 : -0.1,
      // Slight horizontal drift
      vx: (_random.nextDouble() - 0.5) * 0.004,
      // Varying fall speeds
      vy: 0.002 + _random.nextDouble() * 0.006,
      size: 6 + _random.nextDouble() * 10,
      color: _palette[_random.nextInt(_palette.length)],
      rotationX: _random.nextDouble() * math.pi * 2,
      rotationY: _random.nextDouble() * math.pi * 2,
      rotationZ: _random.nextDouble() * math.pi * 2,
      // Rotation speeds
      rotationSpeedX: (_random.nextDouble() - 0.5) * 0.15,
      rotationSpeedY: (_random.nextDouble() - 0.5) * 0.15,
      rotationSpeedZ: (_random.nextDouble() - 0.5) * 0.15,
      shape: shape,
    );
  }

  @override
  void didUpdateWidget(CelebrationConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnabled && !oldWidget.isEnabled) {
      _initParticles();
      _controller.repeat();
    } else if (!widget.isEnabled && oldWidget.isEnabled) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) return widget.child;

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                _updateParticles();
                return CustomPaint(
                  painter: _ConfettiPainter(particles: _particles),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _updateParticles() {
    for (int i = 0; i < _particles.length; i++) {
      final p = _particles[i];
      p.y += p.vy;
      // Add a swaying motion using sine wave based on its Y position
      p.x += p.vx + math.sin(p.y * 10 + p.rotationZ) * 0.001;

      // Update rotations for 3D flip effect
      p.rotationX += p.rotationSpeedX;
      p.rotationY += p.rotationSpeedY;
      p.rotationZ += p.rotationSpeedZ;

      // Reset particle at top if it falls completely off the bottom
      if (p.y > 1.1) {
        _particles[i] = _createParticle();
      }
    }
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  _ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final px = p.x * size.width;
      final py = p.y * size.height;

      // Cull particles that are outside the vertical view
      if (py < -50 || py > size.height + 50) continue;

      canvas.save();
      canvas.translate(px, py);

      // Apply pseudo-3D rotation
      // 1. Rotate in 2D (Z-axis)
      canvas.rotate(p.rotationZ);
      // 2. Scale X and Y to simulate rotating around Y and X axes
      final scaleX = math.cos(p.rotationY);
      final scaleY = math.cos(p.rotationX);
      canvas.scale(scaleX.abs(), scaleY.abs());

      final paint = Paint()
        ..color = p.color
        ..style = PaintingStyle.fill;

      switch (p.shape) {
        case ConfettiShape.circle:
          canvas.drawCircle(Offset.zero, p.size / 2, paint);
          break;
        case ConfettiShape.rectangle:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                  center: Offset.zero, width: p.size, height: p.size * 1.5),
              const Radius.circular(2),
            ),
            paint,
          );
          break;
        case ConfettiShape.triangle:
          final path = Path();
          path.moveTo(0, -p.size / 1.5);
          path.lineTo(p.size / 1.5, p.size / 1.5);
          path.lineTo(-p.size / 1.5, p.size / 1.5);
          path.close();
          canvas.drawPath(path, paint);
          break;
        case ConfettiShape.star:
          _drawStar(canvas, p.size, paint);
          break;
        case ConfettiShape.curvedRibbon:
          _drawRibbon(canvas, p.size, paint);
          break;
      }

      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, double size, Paint paint) {
    final double r = size / 1.5;
    final double innerR = r / 2;
    final path = Path();
    const double angleOffset = -math.pi / 2;
    for (int i = 0; i < 10; i++) {
      final double radius = (i % 2 == 0) ? r : innerR;
      final double angle = angleOffset + (i * math.pi / 5);
      final double x = radius * math.cos(angle);
      final double y = radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawRibbon(Canvas canvas, double size, Paint paint) {
    final ribbonPath = Path();
    ribbonPath.moveTo(-size, -size * 0.4);
    ribbonPath.quadraticBezierTo(0, size * 0.6, size, -size * 0.3);
    ribbonPath.lineTo(size, size * 0.3);
    ribbonPath.quadraticBezierTo(0, size * 1.1, -size, size * 0.3);
    ribbonPath.close();
    canvas.drawPath(ribbonPath, paint);
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
