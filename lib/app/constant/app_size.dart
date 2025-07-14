import 'package:flutter/widgets.dart';

class AppSize {
  // Infinity values
  static const double infinity = double.infinity;

  // Common padding/margin sizes
  static const EdgeInsets paddingSmall = EdgeInsets.all(8);
  static const EdgeInsets paddingMedium = EdgeInsets.all(16);
  static const EdgeInsets paddingLarge = EdgeInsets.all(24);

  // Common font sizes
  static const double fontSmall = 12.0;
  static const double fontMedium = 16.0;
  static const double fontLarge = 20.0;

  // Common radius for borderRadius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;

  // Common heights or widths
  static const double heightButton = 48.0;
  static const double widthButton = 160.0;
}

class ScreenUtils {
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
