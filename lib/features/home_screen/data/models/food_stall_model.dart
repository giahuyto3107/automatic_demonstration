class FoodStallModel {
  final String foodStallName;
  final String foodStallDescription;
  final double distance;
  final int audioLength;
  final String foodStallImage;

  FoodStallModel({
    required this.foodStallName,
    required this.foodStallDescription,
    required this.distance,
    required this.audioLength,
    required this.foodStallImage,
  });

  FoodStallModel copyWith({
    String? foodStallName,
    String? foodStallDescription,
    double? distance,
    int? audioLength,
    String? foodStallImage,
  }) {
    return FoodStallModel(
      foodStallName: foodStallName ?? this.foodStallName,
      foodStallDescription: foodStallDescription ?? this.foodStallDescription,
      distance: distance ?? this.distance,
      audioLength: audioLength ?? this.audioLength,
      foodStallImage: foodStallImage ?? this.foodStallImage,
    );
  }
}