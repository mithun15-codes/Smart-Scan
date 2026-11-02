import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Main title: h1 in website
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.headingDark,
    letterSpacing: 1.0,
  );

  static const TextStyle h1Black = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.headingBlack,
  );

  // Subheading: h2 in website
  static const TextStyle h2 = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Color(0xFF010102),
  );

  // Section title: h3 in website
  static const TextStyle h3 = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.headingDark,
    letterSpacing: 0.5,
  );

  // Section title: h4 in website
  static const TextStyle h4 = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.headingBlack,
  );

  // Body text: p in website
  static const TextStyle body = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 15,
    color: AppColors.textDark,
    height: 1.5,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 14,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // Form label
  static const TextStyle formLabel = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.labelColor,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // Nav Item text
  static const TextStyle navItem = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color(0xFFF8F9FA),
    letterSpacing: 0.5,
  );

  // Prediction text
  static const TextStyle prediction = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.headingDark,
  );

  // Footer text
  static const TextStyle footer = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 13,
    color: Colors.white70,
    height: 1.4,
  );
}

