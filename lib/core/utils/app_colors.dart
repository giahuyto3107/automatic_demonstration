import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color textOnLight = Color(0xff000000);

  static const Color textOnDark = Color(0xffFFFFFF);

  static const Color primaryColor = Color(0xffF97015);

  static const Color sliderInactiveColor = Colors.white;

  static const Color sliderThumbColor = Colors.white;

  static const LinearGradient backgroundColor = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF485563),
      Color(0xFF29323C),
    ],
  );

  static const LinearGradient logoColor = LinearGradient(
    begin: Alignment.centerLeft,   // Matches the horizontal flow in your image
    end: Alignment.centerRight,
    colors: [
      Color(0xFFF7B31B),
      Color(0xFFF97A16),
    ],
  );

  static const LinearGradient foodStallUpperContainerBackgroundColor = LinearGradient(
    begin: Alignment.centerLeft,   // Matches the horizontal flow in your image
    end: Alignment.centerRight,
    colors: [
      Color(0xFFE4EFE9),
      Color(0xFF93A5CF),
    ],
  );

  static const Color foodStallLowerContainerBackgroundColor = Color(0xff1F2933);

  static const Color playButtonColor = Color(0xffF97015);

  static const Color skipButtonColor = Color(0xff2C3844);

  static const Color enable = Color(0xff209851);

  static const Color disable = Color(0xffFF0000);

  static const Color connecting = Color(0xffE7F214);
}