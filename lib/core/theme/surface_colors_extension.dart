import 'package:flutter/material.dart';

class AppSurfaceColors extends ThemeExtension<AppSurfaceColors> {
  final Color headingSurface;
  final Color primarySurface;
  final Color secondarySurface;
  final Color lighterPrimarySurface;
  final Color skipButtonSurface;

  const AppSurfaceColors({
    required this.headingSurface,
    required this.primarySurface,
    required this.secondarySurface,
    required this.lighterPrimarySurface,
    required this.skipButtonSurface
  });

  @override
  AppSurfaceColors copyWith({
    Color? primarySurface,
    Color? headingSurface,
    Color? secondarySurface,
    Color? lighterPrimarySurface,
    Color? skipButtonSurface,
  }) {
    return AppSurfaceColors(
      primarySurface: primarySurface ?? this.primarySurface,
      headingSurface: headingSurface ?? this.headingSurface,
      secondarySurface: secondarySurface ?? this.secondarySurface,
      lighterPrimarySurface: lighterPrimarySurface ?? this.lighterPrimarySurface,
      skipButtonSurface: skipButtonSurface ?? this.skipButtonSurface,
    );
  }

  @override
  AppSurfaceColors lerp(ThemeExtension<AppSurfaceColors>? other, double t) {
    if (other is! AppSurfaceColors) return this;
    return AppSurfaceColors(
      primarySurface: Color.lerp(primarySurface, other.primarySurface, t)!,
      headingSurface: Color.lerp(headingSurface, other.headingSurface, t)!,
      secondarySurface: Color.lerp(secondarySurface, other.secondarySurface, t)!,
      lighterPrimarySurface: Color.lerp(lighterPrimarySurface, other.lighterPrimarySurface, t)!,
      skipButtonSurface: Color.lerp(skipButtonSurface, other.skipButtonSurface, t)!,
    );
  }
}