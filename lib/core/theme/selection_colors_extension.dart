import 'package:flutter/material.dart';

class SelectionColors extends ThemeExtension<SelectionColors> {
  final Color selectedBg;
  final Color selectedText;
  final Color unselectedBg;
  final Color unselectedText;

  SelectionColors({
    required this.selectedBg,
    required this.selectedText,
    required this.unselectedBg,
    required this.unselectedText,
  });

  @override
  SelectionColors copyWith({
    Color? selectedBg,
    Color? selectedText,
    Color? unselectedBg,
    Color? unselectedText,
  }) {
    return SelectionColors(
      selectedBg: selectedBg ?? this.selectedBg,
      selectedText: selectedText ?? this.selectedText,
      unselectedBg: unselectedBg ?? this.unselectedBg,
      unselectedText: unselectedText ?? this.unselectedText,
    );
  }

  @override
  SelectionColors lerp(ThemeExtension<SelectionColors>? other, double t) {
    if (other is! SelectionColors) return this;
    return SelectionColors(
      selectedBg: Color.lerp(selectedBg, other.selectedBg, t)!,
      selectedText: Color.lerp(selectedText, other.selectedText, t)!,
      unselectedBg: Color.lerp(unselectedBg, other.unselectedBg, t)!,
      unselectedText: Color.lerp(unselectedText, other.unselectedText, t)!,
    );
  }
}