import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:flutter/material.dart';

@immutable
class FoodStallState {
  final List<FoodStallModel> items;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final String? errorMessage;

  const FoodStallState({
    this.items = const [],
    this.currentPage = 0,
    this.hasMore = false,
    this.isLoading = false,
    this.errorMessage,
  });

  FoodStallState copyWith({
    List<FoodStallModel>? items,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FoodStallState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}