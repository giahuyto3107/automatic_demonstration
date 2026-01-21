class FoodStallModel {
  final String foodStallName;
  final String foodStallDescription;
  final double distanceMeter;
  final int distanceSecond;
  final String foodStallImage;

  FoodStallModel({
    required this.foodStallName,
    required this.foodStallDescription,
    required this.distanceMeter,
    required this.distanceSecond,
    required this.foodStallImage,
  });

  FoodStallModel copyWith({
    String? foodStallName,
    String? foodStallDescription,
    double? distanceMeter,
    int? distanceSecond,
    String? foodStallImage,
  }) {
    return FoodStallModel(
      foodStallName: foodStallName ?? this.foodStallName,
      foodStallDescription: foodStallDescription ?? this.foodStallDescription,
      distanceMeter: distanceMeter ?? this.distanceMeter,
      distanceSecond: distanceSecond ?? this.distanceSecond,
      foodStallImage: foodStallImage ?? this.foodStallImage,
    );
  }
}