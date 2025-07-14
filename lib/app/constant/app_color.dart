import 'package:flutter/material.dart';

class AppColor {
  // Core Palette
  static const Color darkBlueGrey = Color(0xFF283044);
  static const Color softBlue = Color(0xFF78A1BB);
  static const Color lightMint = Color(0xFFEBF5EE);
  static const Color warmBeige = Color(0xFFBFA89E);
  static const Color mutedBrown = Color(0xFF8B786D);
  static const Color lightGrey = Color(0xD3D3D3D3);
  static const Color white = Colors.white;

  // Primary Theme
  static const Color primary = softBlue;
  static const Color tileColor = Color.fromARGB(255, 192, 201, 238);
  static const Color primaryDark = darkBlueGrey;
  static const Color primaryLight = lightMint;

  // Backgrounds
  static const Color background = lightMint;
  static const Color surface = Colors.white;
  static const Color backdrop = Color.fromARGB(255, 96, 141, 240);

  //Icon
  static const Color iconWhite = Colors.white;

  // Text
  static const Color textDark = darkBlueGrey;
  static const Color textSecondary = mutedBrown;
  static const Color textWhite = Colors.white;

  // Buttons
  static const Color buttonPrimary = softBlue;
  static const Color buttonSecondary = warmBeige;
  static const Color buttonDisabled = Color(0xFFE0E0E0);

  // Borders
  static const Color border = mutedBrown;
  static const Color borderLight = Color(0xFFDDDDDD);

  // Feedback
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = primary;

  // Shadow
  static const Color shadow = Colors.black12;
}
