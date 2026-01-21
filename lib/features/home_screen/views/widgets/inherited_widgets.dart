import 'package:automatic_demonstration/features/home_screen/data/food_stall_model.dart';
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