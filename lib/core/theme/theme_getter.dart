import 'package:automatic_demonstration/core/theme/background_gradients_extension.dart';
import 'package:automatic_demonstration/core/theme/selection_colors_extension.dart';
import 'package:automatic_demonstration/core/theme/surface_colors_extension.dart';
import 'package:flutter/material.dart';

extension ThemeGetter on BuildContext {
  SelectionColors get selectionColors => Theme.of(this).extension<SelectionColors>()!;
  AppSurfaceColors get surfaceColors => Theme.of(this).extension<AppSurfaceColors>()!;
  BackgroundGradients get backgroundGradients => Theme.of(this).extension<BackgroundGradients>()!;
}