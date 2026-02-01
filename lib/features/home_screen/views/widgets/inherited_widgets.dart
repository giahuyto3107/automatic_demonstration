import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:flutter/material.dart';

class FoodStallDataProvider extends InheritedWidget {
  final List<FoodStallModel> foodStallModels;

  const FoodStallDataProvider({
    super.key,
    required this.foodStallModels,
    required super.child,
  });

  // Helper method to allow widgets to access the data easily
  static FoodStallDataProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FoodStallDataProvider>();
  }

  // Determines if widgets depending on this data should rebuild when data changes
  @override
  bool updateShouldNotify(FoodStallDataProvider oldWidget) {
    return foodStallModels != oldWidget.foodStallModels;
  }
}

class FoodStallItemProvider extends InheritedWidget {
  final int index;
  final bool isSkipped;
  final VoidCallback onPlayTap;
  final VoidCallback onSkipOrRestoreTap;

  const FoodStallItemProvider({
    super.key,
    required this.index,
    required this.isSkipped,
    required this.onPlayTap,
    required this.onSkipOrRestoreTap,
    required super.child,
  });

  static FoodStallItemProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FoodStallItemProvider>();
  }

  @override
  bool updateShouldNotify(FoodStallItemProvider oldWidget) {
    // Rebuild if the index changes (unlikely in a stable list) or callbacks change
    return index != oldWidget.index ||
      isSkipped != oldWidget.isSkipped ||
      onPlayTap != oldWidget.onPlayTap ||
      onSkipOrRestoreTap != oldWidget.onSkipOrRestoreTap;
  }
}