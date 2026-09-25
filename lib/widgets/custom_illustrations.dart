import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Screen 1: Welcome Screen Boy & Question Mark Artwork
class WelcomeArtworkWidget extends StatelessWidget {
  final double size;
  const WelcomeArtworkWidget({super.key, this.size = 240});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _WelcomePainter(),
      ),
    );
  }
}

class _WelcomePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 240.0;

    // 1. Draw large golden question mark in background
    final qmPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFB74D), Color(0xFFFFD54F), Color(0xFFFF9800)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 36 * scale
      ..strokeCap = StrokeCap.round;

    final qmPath = Path();
    qmPath.moveTo(center.dx - 15 * scale, center.dy - 70 * scale);
    qmPath.cubicTo(
      center.dx + 40 * scale,
      center.dy - 120 * scale,
      center.dx + 90 * scale,
      center.dy - 40 * scale,
      center.dx + 25 * scale,
      center.dy - 5 * scale,
    );
    qmPath.lineTo(center.dx + 10 * scale, center.dy + 20 * scale);
    canvas.drawPath(qmPath, qmPaint);

    // 2. Yellow floating circle
    final yellowBubblePaint = Paint()..color = const Color(0xFFFFB74D);
    canvas.drawCircle(
      Offset(center.dx - 65 * scale, center.dy + 35 * scale),
      18 * scale,
      yellowBubblePaint,
    );

    // 3. Pink dialogue circle (top left)
    final pinkBubblePaint = Paint()..color = const Color(0xFFFF6584);
    canvas.drawCircle(
      Offset(center.dx - 60 * scale, center.dy - 50 * scale),
      22 * scale,
      pinkBubblePaint,
    );
    final stripePaint = Paint()
      ..color = const Color(0xFF68D391)
      ..strokeWidth = 4 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - 70 * scale, center.dy - 55 * scale),
      Offset(center.dx - 50 * scale, center.dy - 58 * scale),
      stripePaint,
    );
    canvas.drawLine(
      Offset(center.dx - 68 * scale, center.dy - 45 * scale),
      Offset(center.dx - 48 * scale, center.dy - 48 * scale),
      stripePaint,
    );

    // 4. Red question mark (right)
    final redQmPaint = Paint()
      ..color = const Color(0xFFFF5252)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14 * scale
      ..strokeCap = StrokeCap.round;
    final redQmPath = Path();
    redQmPath.moveTo(center.dx + 65 * scale, center.dy - 40 * scale);
    redQmPath.cubicTo(
      center.dx + 90 * scale,
      center.dy - 50 * scale,
      center.dx + 95 * scale,
      center.dy - 15 * scale,
      center.dx + 75 * scale,
      center.dy - 5 * scale,
    );
    redQmPath.lineTo(center.dx + 72 * scale, center.dy + 5 * scale);
    canvas.drawPath(redQmPath, redQmPaint);

    final redDotPaint = Paint()..color = const Color(0xFFFF5252);
    canvas.drawCircle(
      Offset(center.dx + 72 * scale, center.dy + 20 * scale),
      6 * scale,
      redDotPaint,
    );

    // 5. Green curvy mark (lower right)
    final greenMarkPaint = Paint()
      ..color = const Color(0xFF48BB78)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10 * scale
      ..strokeCap = StrokeCap.round;
    final greenPath = Path();
    greenPath.moveTo(center.dx + 70 * scale, center.dy + 40 * scale);
    greenPath.quadraticBezierTo(
      center.dx + 85 * scale,
      center.dy + 55 * scale,
      center.dx + 75 * scale,
      center.dy + 70 * scale,
    );
    canvas.drawPath(greenPath, greenMarkPaint);

    // 6. Character Face & Purple Curly Hair
    final facePaint = Paint()..color = const Color(0xFFFFD1BD);
    final earsPaint = Paint()..color = const Color(0xFFFFBFA3);

    // Ears
    canvas.drawCircle(
      Offset(center.dx - 45 * scale, center.dy - 5 * scale),
      12 * scale,
      earsPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + 35 * scale, center.dy - 5 * scale),
      12 * scale,
      earsPaint,
    );

    // Face
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 5 * scale, center.dy - 5 * scale),
        width: 80 * scale,
        height: 75 * scale,
      ),
      facePaint,
    );

    // Purple Hair Puffs
    final hairPaint = Paint()..color = const Color(0xFF7E3AF2);
    final hairOffsets = [
      Offset(center.dx - 30 * scale, center.dy - 35 * scale),
      Offset(center.dx - 10 * scale, center.dy - 45 * scale),
      Offset(center.dx + 12 * scale, center.dy - 40 * scale),
      Offset(center.dx + 28 * scale, center.dy - 25 * scale),
      Offset(center.dx + 35 * scale, center.dy - 10 * scale),
      Offset(center.dx - 38 * scale, center.dy - 20 * scale),
    ];
    for (final off in hairOffsets) {
      canvas.drawCircle(off, 18 * scale, hairPaint);
    }

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF1A202C);
    canvas.drawCircle(
      Offset(center.dx - 18 * scale, center.dy - 15 * scale),
      4 * scale,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + 6 * scale, center.dy - 15 * scale),
      4 * scale,
      eyePaint,
    );

    // Rosy Cheeks
    final cheekPaint = Paint()..color = const Color(0xFFFF8A80).withValues(alpha: 0.55);
    canvas.drawCircle(
      Offset(center.dx - 26 * scale, center.dy - 5 * scale),
      7 * scale,
      cheekPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + 14 * scale, center.dy - 5 * scale),
      7 * scale,
      cheekPaint,
    );

    // Freckles
    final frecklePaint = Paint()..color = const Color(0xFF795548);
    canvas.drawCircle(Offset(center.dx - 6 * scale, center.dy - 8 * scale), 1.5 * scale, frecklePaint);
    canvas.drawCircle(Offset(center.dx - 8 * scale, center.dy - 3 * scale), 1.2 * scale, frecklePaint);
    canvas.drawCircle(Offset(center.dx + 1 * scale, center.dy - 3 * scale), 1.2 * scale, frecklePaint);

    // Smile
    final smilePaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx - 6 * scale, center.dy + 8 * scale),
        width: 14 * scale,
        height: 10 * scale,
      ),
      0.2,
      2.7,
      false,
      smilePaint,
    );

    // Accent strokes
    final purpleAccent = Paint()
      ..color = const Color(0xFF9061F9)
      ..strokeWidth = 3 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - 50 * scale, center.dy - 80 * scale),
      Offset(center.dx - 40 * scale, center.dy - 88 * scale),
      purpleAccent,
    );
    canvas.drawLine(
      Offset(center.dx - 46 * scale, center.dy - 72 * scale),
      Offset(center.dx - 36 * scale, center.dy - 80 * scale),
      purpleAccent,
    );

    final orangeAccent = Paint()
      ..color = const Color(0xFFFF9800)
      ..strokeWidth = 3 * scale
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - 10 * scale, center.dy + 45 * scale),
      Offset(center.dx + 6 * scale, center.dy + 40 * scale),
      orangeAccent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Screen 3: Configuration Screen Settings Artwork
class ConfigArtworkWidget extends StatelessWidget {
  final double size;
  const ConfigArtworkWidget({super.key, this.size = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ConfigPainter(),
      ),
    );
  }
}

class _ConfigPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 180.0;
    final center = Offset(size.width / 2, size.height / 2);

    final cardRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 5 * scale, center.dy + 5 * scale),
        width: 120 * scale,
        height: 120 * scale,
      ),
      Radius.circular(24 * scale),
    );
    final cardPaint = Paint()..color = const Color(0xFFCBE7FA);
    final cardBorder = Paint()
      ..color = const Color(0xFF2D3748)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * scale;
    canvas.drawRRect(cardRect, cardPaint);
    canvas.drawRRect(cardRect, cardBorder);

    // Yellow Gear Box
    final gearBoxRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx - 30 * scale, center.dy - 35 * scale),
        width: 50 * scale,
        height: 50 * scale,
      ),
      Radius.circular(14 * scale),
    );
    final gearBoxPaint = Paint()..color = const Color(0xFFFFF275);
    canvas.drawRRect(gearBoxRect, gearBoxPaint);
    canvas.drawRRect(gearBoxRect, cardBorder);

    final gearPaint = Paint()
      ..color = const Color(0xFFD49A3D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * scale;
    canvas.drawCircle(
      Offset(center.dx - 30 * scale, center.dy - 35 * scale),
      12 * scale,
      gearPaint,
    );
    final gearInner = Paint()..color = const Color(0xFFFFF275);
    canvas.drawCircle(
      Offset(center.dx - 30 * scale, center.dy - 35 * scale),
      6 * scale,
      gearInner,
    );
    canvas.drawCircle(
      Offset(center.dx - 30 * scale, center.dy - 35 * scale),
      6 * scale,
      cardBorder..strokeWidth = 2 * scale,
    );

    // Toggles
    final toggle1 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 25 * scale, center.dy - 35 * scale),
        width: 60 * scale,
        height: 24 * scale,
      ),
      Radius.circular(12 * scale),
    );
    final redPaint = Paint()..color = const Color(0xFFFF5252);
    canvas.drawRRect(toggle1, redPaint);
    canvas.drawRRect(toggle1, cardBorder);

    final pinkKnob = Paint()..color = const Color(0xFFFFB2B2);
    canvas.drawCircle(
      Offset(center.dx + 10 * scale, center.dy - 35 * scale),
      10 * scale,
      pinkKnob,
    );
    canvas.drawCircle(
      Offset(center.dx + 10 * scale, center.dy - 35 * scale),
      10 * scale,
      cardBorder,
    );

    final toggle2 = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx + 25 * scale, center.dy - 5 * scale),
        width: 60 * scale,
        height: 24 * scale,
      ),
      Radius.circular(12 * scale),
    );
    canvas.drawRRect(toggle2, redPaint);
    canvas.drawRRect(toggle2, cardBorder);

    canvas.drawCircle(
      Offset(center.dx + 40 * scale, center.dy - 5 * scale),
      10 * scale,
      pinkKnob,
    );
    canvas.drawCircle(
      Offset(center.dx + 40 * scale, center.dy - 5 * scale),
      10 * scale,
      cardBorder,
    );

    // Hand & Arm
    final handPaint = Paint()..color = const Color(0xFF6B4226);
    final armPaint = Paint()..color = const Color(0xFF2979FF);

    final armPath = Path();
    armPath.moveTo(center.dx - 45 * scale, center.dy + 65 * scale);
    armPath.lineTo(center.dx - 10 * scale, center.dy + 20 * scale);
    armPath.lineTo(center.dx + 15 * scale, center.dy + 45 * scale);
    armPath.lineTo(center.dx - 15 * scale, center.dy + 75 * scale);
    armPath.close();
    canvas.drawPath(armPath, armPaint);
    canvas.drawPath(armPath, cardBorder);

    final handPath = Path();
    handPath.moveTo(center.dx - 10 * scale, center.dy + 20 * scale);
    handPath.lineTo(center.dx + 10 * scale, center.dy - 30 * scale);
    handPath.quadraticBezierTo(
      center.dx + 18 * scale,
      center.dy - 30 * scale,
      center.dx + 16 * scale,
      center.dy - 15 * scale,
    );
    handPath.lineTo(center.dx + 22 * scale, center.dy - 5 * scale);
    handPath.lineTo(center.dx + 22 * scale, center.dy + 20 * scale);
    handPath.lineTo(center.dx + 10 * scale, center.dy + 35 * scale);
    handPath.close();
    canvas.drawPath(handPath, handPaint);
    canvas.drawPath(handPath, cardBorder);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Screen 4: Celebration Party Popper Artwork
class PartyPopperArtworkWidget extends StatelessWidget {
  final double size;
  const PartyPopperArtworkWidget({super.key, this.size = 220});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PartyPopperPainter(),
      ),
    );
  }
}

class _PartyPopperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 220.0;
    final center = Offset(size.width / 2, size.height / 2 + 15 * scale);

    final confettiColors = [
      const Color(0xFF2979FF), // Sky Blue
      const Color(0xFFFFD600), // Sunshine Yellow
      const Color(0xFF00E676), // Vivid Emerald
      const Color(0xFFFF9100), // Vibrant Orange
      const Color(0xFFFF4081), // Neon Pink
    ];

    // 1. Ribbons exploding from popper
    void drawCurvedRibbon(
      Offset start,
      Offset ctrl1,
      Offset ctrl2,
      Offset end,
      Color color,
      double strokeWidth,
    ) {
      final p = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * scale
        ..strokeCap = StrokeCap.round;
      final path = Path();
      path.moveTo(start.dx, start.dy);
      path.cubicTo(ctrl1.dx, ctrl1.dy, ctrl2.dx, ctrl2.dy, end.dx, end.dy);
      canvas.drawPath(path, p);
    }

    drawCurvedRibbon(
      Offset(center.dx - 25 * scale, center.dy - 30 * scale),
      Offset(center.dx - 65 * scale, center.dy - 60 * scale),
      Offset(center.dx - 85 * scale, center.dy - 100 * scale),
      Offset(center.dx - 55 * scale, center.dy - 120 * scale),
      confettiColors[0],
      5.5,
    );

    drawCurvedRibbon(
      Offset(center.dx + 5 * scale, center.dy - 40 * scale),
      Offset(center.dx + 45 * scale, center.dy - 80 * scale),
      Offset(center.dx + 80 * scale, center.dy - 95 * scale),
      Offset(center.dx + 70 * scale, center.dy - 125 * scale),
      confettiColors[1],
      6.0,
    );

    drawCurvedRibbon(
      Offset(center.dx - 10 * scale, center.dy - 35 * scale),
      Offset(center.dx - 20 * scale, center.dy - 80 * scale),
      Offset(center.dx - 5 * scale, center.dy - 120 * scale),
      Offset(center.dx + 15 * scale, center.dy - 135 * scale),
      confettiColors[2],
      5.0,
    );

    drawCurvedRibbon(
      Offset(center.dx - 50 * scale, center.dy - 20 * scale),
      Offset(center.dx - 90 * scale, center.dy - 35 * scale),
      Offset(center.dx - 100 * scale, center.dy - 65 * scale),
      Offset(center.dx - 80 * scale, center.dy - 85 * scale),
      confettiColors[3],
      5.0,
    );

    // Confetti rectangles
    void drawConfettiRect(Offset pos, double angle, Color color, double w, double h) {
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(angle);
      final p = Paint()..color = color;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: w * scale, height: h * scale),
          Radius.circular(2.5 * scale),
        ),
        p,
      );
      canvas.restore();
    }

    drawConfettiRect(Offset(center.dx - 65 * scale, center.dy - 70 * scale), 0.5, confettiColors[1], 9, 16);
    drawConfettiRect(Offset(center.dx - 80 * scale, center.dy - 45 * scale), -0.6, confettiColors[4], 8, 14);
    drawConfettiRect(Offset(center.dx - 35 * scale, center.dy - 65 * scale), 0.3, confettiColors[0], 9, 15);
    drawConfettiRect(Offset(center.dx + 55 * scale, center.dy - 55 * scale), -0.4, confettiColors[2], 8, 15);
    drawConfettiRect(Offset(center.dx + 75 * scale, center.dy - 80 * scale), 0.7, confettiColors[3], 9, 16);
    drawConfettiRect(Offset(center.dx + 35 * scale, center.dy - 100 * scale), -0.3, confettiColors[0], 8, 14);
    drawConfettiRect(Offset(center.dx - 5 * scale, center.dy - 85 * scale), 0.4, confettiColors[4], 9, 15);

    // 2. Party Popper Cone (tilted with 3D gradient)
    final tip = Offset(center.dx + 65 * scale, center.dy + 65 * scale);
    final rimTop = Offset(center.dx - 30 * scale, center.dy - 35 * scale);
    final rimBottom = Offset(center.dx + 42 * scale, center.dy + 25 * scale);

    final conePath = Path()
      ..moveTo(rimTop.dx, rimTop.dy)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(rimBottom.dx, rimBottom.dy)
      ..close();

    // Gradient shading on cone
    final coneGradient = LinearGradient(
      colors: const [
        Color(0xFFFF80AB), // Soft bright pink
        Color(0xFFF48FB1), // Mid pastel pink
        Color(0xFFEC407A), // Deeper pink for shadow
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromPoints(rimTop, tip));

    final conePaint = Paint()..shader = coneGradient;
    canvas.drawPath(conePath, conePaint);

    // Diagonal White Stripes
    final stripePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;

    // Stripe 1
    final stripe1 = Path()
      ..moveTo(rimTop.dx + 25 * scale, rimTop.dy + 26 * scale)
      ..lineTo(rimTop.dx + 42 * scale, rimTop.dy + 43 * scale)
      ..lineTo(rimBottom.dx + 8 * scale, rimBottom.dy + 12 * scale)
      ..lineTo(rimBottom.dx - 8 * scale, rimBottom.dy - 4 * scale)
      ..close();
    canvas.drawPath(stripe1, stripePaint);

    // Stripe 2
    final stripe2 = Path()
      ..moveTo(rimTop.dx + 52 * scale, rimTop.dy + 54 * scale)
      ..lineTo(rimTop.dx + 66 * scale, rimTop.dy + 68 * scale)
      ..lineTo(rimBottom.dx + 18 * scale, rimBottom.dy + 24 * scale)
      ..lineTo(rimBottom.dx + 6 * scale, rimBottom.dy + 12 * scale)
      ..close();
    canvas.drawPath(stripe2, stripePaint);

    // 3. Rim of the Cone (3D depth ellipse)
    final rimCenter = Offset(center.dx + 4 * scale, center.dy - 8 * scale);

    canvas.save();
    canvas.translate(rimCenter.dx, rimCenter.dy);
    canvas.rotate(-math.pi / 4.2);

    // Outer Rim Border
    final rimBorderPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF4081), Color(0xFFF50057), Color(0xFFC51162)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCenter(center: Offset.zero, width: 95 * scale, height: 50 * scale));
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 92 * scale, height: 48 * scale),
      rimBorderPaint,
    );

    // Inner Hollow Cavity (Lighter / saturated pink glow with shadow)
    final cavityPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFFF80AB),
          Color(0xFFFF4081),
          Color(0xFFD81B60),
        ],
        radius: 0.85,
      ).createShader(Rect.fromCenter(center: Offset.zero, width: 80 * scale, height: 38 * scale));
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 80 * scale, height: 38 * scale),
      cavityPaint,
    );

    // Confetti inside cavity bursting out
    final innerConfetti = Paint()..color = const Color(0xFFFFEB3B);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(-10 * scale, -2 * scale), width: 14 * scale, height: 8 * scale),
        Radius.circular(2 * scale),
      ),
      innerConfetti,
    );

    final innerConfetti2 = Paint()..color = const Color(0xFF00E676);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(12 * scale, 4 * scale), width: 12 * scale, height: 7 * scale),
        Radius.circular(2 * scale),
      ),
      innerConfetti2,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
