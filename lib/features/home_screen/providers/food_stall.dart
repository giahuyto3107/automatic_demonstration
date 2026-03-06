import 'dart:core';

import 'package:automatic_demonstration/core/services/database_service.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';
import 'package:automatic_demonstration/features/home_screen/data/repository/food_stall_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'food_stall.g.dart';

@riverpod
class FoodStall extends _$FoodStall {
  @override
  Future<List<FoodStallModel>> build() async {
    return await _fetchFoodStalls(ref);
  }

  Future<List<FoodStallModel>> _fetchFoodStalls(Ref ref) async {
    final repository = FoodStallRepository(DatabaseService.instance);
    return await repository.getFoodStalls();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchFoodStalls(ref));
  }
}