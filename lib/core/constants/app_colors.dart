import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color kPrimary = Color(0xFF4ECDC4); // Teal accent
  static const Color kPrimaryDark = Color(0xFF3BA39C);
  static const Color kPrimaryLight = Color(0xFF6EDDD6);
  
  // Background Colors
  static const Color kBackground = Color(0xFF1A202C); // Dark background
  static const Color kSurface = Color(0xFF2D3748); // Surface color
  static const Color kCardBackground = Color(0xFF1A1A2E); // Card background
  
  // Text Colors
  static const Color kWhite = Colors.white;
  static const Color kTextPrimary = Colors.white;
  static const Color kTextSecondary = Color(0xFFB0B0B0);
  static const Color kTextMuted = Color(0xFF808080);
  
  // Status Colors
  static const Color kSuccess = Color(0xFF48BB78);
  static const Color kError = Color(0xFFF56565);
  static const Color kWarning = Color(0xFFED8936);
  static const Color kInfo = Color(0xFF4299E1);
  
  // Gradient Colors (from AbstractBackgroundWrapper)
  static const Color kGradientPurple = Color(0xFFB794F6);
  static const Color kGradientTeal = Color(0xFF4FD1C7);
  static const Color kGradientOrange = Color(0xFFFBD38D);
  static const Color kGradientDark = Color(0xFF2D3748);
  static const Color kGradientAccent = Color(0xFFED8936);
  
  // Border Colors
  static const Color kBorder = Color(0xFF4A5568);
  static const Color kBorderLight = Color(0xFF718096);
  
  // Overlay Colors
  static const Color kOverlay = Color(0x80000000);
  static const Color kOverlayLight = Color(0x40000000);
  
  // Legacy colors for backward compatibility
  static const Color primary = kPrimary;
  static const Color success = kSuccess;
  static const Color error = kError;
  static const Color warning = kWarning;
  static const Color primaryColor = kWhite;
}
