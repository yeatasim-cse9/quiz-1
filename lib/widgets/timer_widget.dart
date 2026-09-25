import 'package:flutter/material.dart';

class QuizTimerWidget extends StatelessWidget {
  final int secondsRemaining;
  final int totalSeconds;

  const QuizTimerWidget({
    super.key,
    required this.secondsRemaining,
    this.totalSeconds = 25,
  });

  @override
  Widget build(BuildContext context) {
    Color timerColor;
    if (secondsRemaining > 10) {
      timerColor = const Color(0xFF00695C);
    } else if (secondsRemaining > 5) {
      timerColor = const Color(0xFFF57C00);
    } else {
      timerColor = const Color(0xFFD32F2F);
    }

    final double progress = totalSeconds > 0
        ? (secondsRemaining / totalSeconds).clamp(0.0, 1.0)
        : 0.0;

    return Semantics(
      label: '$secondsRemaining seconds remaining',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: timerColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: timerColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                backgroundColor: timerColor.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${secondsRemaining}s',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: timerColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
