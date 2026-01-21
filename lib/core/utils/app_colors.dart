import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color textOnLight = Color(0xff000000);

  static const Color textOnDark = Color(0xffFFFFFF);


  static const Color backgroundColor = Color (0xff363F4E);

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
}