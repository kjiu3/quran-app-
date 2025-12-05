import 'package:flutter/material.dart';

class QuranColors {
  // الألوان الأساسية
  static const Color primaryGreen = Color(0xFF0A5D36);
  static const Color secondaryTeal = Color(0xFF128C7E);
  static const Color accentGold = Color(0xFFF9A825);

  // ألوان النص
  static const Color textDark = Color(0xFF2E2E2E);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);

  // الخلفيات
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2D2D2D);

  // الحالات
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);

  // التدرجات
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF0A5D36), Color(0xFF128C7E)],
  );
}