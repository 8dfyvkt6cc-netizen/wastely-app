import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF00D4A5);
  static const Color primaryLight = Color(0xFF00E5C0);
  static const Color primaryDark = Color(0xFF00A882);

  // Background (dark-first)
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF111118);
  static const Color surfaceElevated = Color(0xFF1A1A24);
  static const Color surfaceGlass = Color(0x1AFFFFFF);
  static const Color surfaceGlassBorder = Color(0x26FFFFFF);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C8);
  static const Color textMuted = Color(0xFF6B6B80);

  // Semantic
  static const Color success = Color(0xFF00D4A5);
  static const Color warning = Color(0xFFFFB800);
  static const Color error = Color(0xFFFF4D6D);
  static const Color info = Color(0xFF4D9FFF);

  // Expense categories
  static const Color categoryFood = Color(0xFFFF6B6B);
  static const Color categoryTransport = Color(0xFF4D9FFF);
  static const Color categorySub = Color(0xFFB84DFF);
  static const Color categoryEntertainment = Color(0xFFFFB800);
  static const Color categoryHealth = Color(0xFF00D4A5);
  static const Color categoryOther = Color(0xFF6B6B80);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0A0F), Color(0xFF0D0D1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glowGradient = LinearGradient(
    colors: [Color(0x4000D4A5), Color(0x0000D4A5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
