import 'package:automatic_demonstration/core/offline/dto/stall.dart';
import 'package:automatic_demonstration/features/home_screen/data/models/food_stall_model.dart';

extension StallDtoMapper on StallDto {
  FoodStallModel toModel() {
    return FoodStallModel(
      id: id,
      name: name,
      address: address,
      description: description,
      latitude: latitude,
      longitude: longitude,
      triggerRadius: triggerRadius,
      audioUrl: audioUrl,
      audioDuration: audioDuration,
      imageUrl: imageUrl ?? '',
      minPrice: minPrice,
      maxPrice: maxPrice,
      featuredReviews: featuredReviews,
      rating: rating ?? 0.0,
      priority: priority,
    );
  }
}
