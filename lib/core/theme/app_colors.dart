import 'package:flutter/material.dart';

class AppColors {
  // Primary accent color - Subtle gold for elegance
  static const Color primary = Color(0xFFD4AF37);
  static const Color primaryDark = Color(0xFFB8941F);

  // Background colors
  static const Color darkBackground = Color(0xFF0A0E17);
  static const Color lightBackground = Color(0xFFF5F5F7);

  // Card colors
  static const Color darkCard = Color(0xFF161B26);
  static const Color lightCard = Color(0xFFFFFFFF);

  // Text colors
  static const Color lightText = Color(0xFFF5F5F7);
  static const Color darkText = Color(0xFF1C1C1E);
  static const Color darkTextSecondary = Color(0xFF8E8E93);
  static const Color lightTextSecondary = Color(0xFF6C6C70);

  // Icon colors
  static const Color darkIcon = Color(0xFFE5E5EA);
  static const Color lightIcon = Color(0xFF3A3A3C);

  // Rating color
  static const Color rating = Color(0xFFFFD700);

  // Accent colors
  static const Color accent = Color(0xFF007AFF);
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);

  // Gradient for hero sections
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF000000),
      Color(0x00000000),
    ],
    stops: [0.0, 1.0],
  );

  // Shimmer colors for loading
  static const Color shimmerBase = Color(0xFF1C1C1E);
  static const Color shimmerHighlight = Color(0xFF2C2C2E);
}