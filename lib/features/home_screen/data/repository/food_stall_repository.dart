import 'package:automatic_demonstration/core/network/endpoints.dart';
import 'package:automatic_demonstration/core/services/database_service.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';

class FoodStallRepository {
  final DatabaseService _db;

  FoodStallRepository(this._db);

  Future<List<FoodStallModel>> getFoodStalls() async {
    try {
      final response = await _db.get(
        Endpoints.getAllStalls,

      );

      print('[FoodStallRepository] response type: ${response.data.runtimeType}');

      if (response.data == null) {
        throw Exception("No food stall found");
      }

      if (response.data is! List) {
        throw Exception("Expected a List but got ${response.data.runtimeType}");
      }
      final List<dynamic> foodStallsData = response.data;

      print('[FoodStallRepository] raw stalls count: ${foodStallsData.length}');

      final stalls = foodStallsData
          .map((json) => FoodStallModel.fromJson(json as Map<String, dynamic>))
          .toList();

      print('[FoodStallRepository] parsed stalls count: ${stalls.length}');
      return stalls;
    } catch (e) {
      throw Exception("Failed to fetch food stalls: ${e.toString()}");
    }
  }
}