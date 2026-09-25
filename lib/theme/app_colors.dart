import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const Color primaryTeal = Color(0xFF00695C);
  static const Color primaryTealDark = Color(0xFF004D40);
  static const Color primaryTealLight = Color(0xFF4DB6AC);
  static const Color accentBlue = Color(0xFF2196F3);

  // Background and Surfaces
  static const Color scaffoldBackground = Color(0xFFFBFBFD);
  static const Color surfaceWhite = Colors.white;
  static const Color surfaceBorder = Color(0xFFE2E8F0);

  // Typography
  static const Color textDark = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textMuted = Color(0xFFA0AEC0);

  // Answer & Feedback Colors
  static const Color correctGreenBg = Color(0xFFA8D5C8);
  static const Color correctGreenDark = Color(0xFF2E7D32);
  static const Color correctGreenLight = Color(0xFFE8F5E9);

  static const Color incorrectRedBg = Color(0xFFFFCDD2);
  static const Color incorrectRedDark = Color(0xFFD32F2F);
  static const Color incorrectRedLight = Color(0xFFFFEBEE);

  static const Color optionDefaultBg = Colors.white;
  static const Color optionDefaultBorder = Color(0xFFE2E8F0);

  // Result Badges
  static const Color resultPillSuccess = Color(0xFFA8E6CF);
  static const Color resultPillFail = Color(0xFFFF5252);

  // Category Pastel Backgrounds
  static const List<Color> pastelCategoryColors = [
    Color(0xFFD4E4FC), // Soft Blue
    Color(0xFFD3F9D8), // Soft Mint Green
    Color(0xFFFFF7C2), // Soft Yellow / Cream
    Color(0xFFF3D9FA), // Soft Lavender
    Color(0xFFFFD8D8), // Soft Coral / Pink
    Color(0xFFFFE8CC), // Soft Peach / Orange
    Color(0xFFD0F0FD), // Sky Blue
    Color(0xFFE8DAEF), // Lilac
    Color(0xFFFCF3CF), // Pale Honey
    Color(0xFFD5F5E3), // Pastel Sage
    Color(0xFFFADBD8), // Soft Rose
    Color(0xFFEAECEE), // Soft Mist
  ];

  static Color getPastelColor(int index) {
    return pastelCategoryColors[index % pastelCategoryColors.length];
  }
}
