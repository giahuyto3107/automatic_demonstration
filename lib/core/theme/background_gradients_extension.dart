import 'package:flutter/material.dart';

class BackgroundGradients extends ThemeExtension<BackgroundGradients>{
  final LinearGradient topContainerGradient;

  BackgroundGradients({
    required this.topContainerGradient,
  });

  @override
  BackgroundGradients copyWith({LinearGradient? topContainerGradient}) {
    return BackgroundGradients(
      topContainerGradient: topContainerGradient ?? this.topContainerGradient,
    );
  }

  @override
  BackgroundGradients lerp(ThemeExtension<BackgroundGradients>? other, double t) {
    if (other is! BackgroundGradients) return this;
    return BackgroundGradients(
      // LinearGradient.lerp handles the smooth color transition during the toggle
      topContainerGradient: LinearGradient.lerp(topContainerGradient, other.topContainerGradient, t)!
    );
  }
}