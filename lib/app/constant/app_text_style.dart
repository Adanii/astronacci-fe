import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTextStyles {
  static const double hintTextSize = 14;
  static const double titleFontSize = 24;
  static const double titleMediumSize = 17;
  static const double bodyFontSize = 16;
  static const double captionFontSize = 12;

  static const TextStyle title = TextStyle(
    fontSize: titleFontSize,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: titleMediumSize,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle hintText = TextStyle(fontSize: hintTextSize);
  static const TextStyle body = TextStyle(fontSize: bodyFontSize);

  static const TextStyle caption = TextStyle(
    fontSize: captionFontSize,
    color: Colors.white,
  );

  static const TextStyle textButtonCustom = TextStyle(
    fontSize: hintTextSize,
    color: AppColor.info,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle textButtonCustomWhite = TextStyle(
    fontSize: hintTextSize,
    color: AppColor.textWhite,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle textNameWhite = TextStyle(
    color: AppColor.textWhite,
    fontSize: titleMediumSize,
    fontWeight: FontWeight.w600,
  );
}
