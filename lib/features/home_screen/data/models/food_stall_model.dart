class FoodStallModel {
  final String name;
  final String address;
  final String description;
  final double? latitude;
  final double? longitude;
  final double? distance;
  final int triggerRadius;
  final String audioUrl;
  final String imageUrl;
  final int? minPrice;
  final int? maxPrice;
  final int audioDuration;
  final List<String> featuredReview;
  final double rating;
  final bool isTriggered;

  FoodStallModel({
    this.name = '',
    this.address = '',
    this.description = '',
    this.latitude,
    this.longitude,
    this.distance,
    this.triggerRadius = 0,
    this.audioUrl = '',
    this.imageUrl = '',
    this.minPrice,
    this.maxPrice,
    this.featuredReview = const [],
    this.audioDuration = 0,
    this.rating = 0.0,
    this.isTriggered = false,
  });

  FoodStallModel copyWith({
    String? name,
    String? address,
    String? description,
    double? latitude,
    double? longitude,
    double? distance,
    int? triggerRadius,
    String? audioUrl,
    String? imageUrl,
    int? minPrice,
    int? maxPrice,
    List<String>? featuredReview,
    int? audioDuration,
    double? rating,
  }) {
    return FoodStallModel(
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      triggerRadius: triggerRadius ?? this.triggerRadius,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      featuredReview: featuredReview ?? this.featuredReview,
      audioDuration: audioDuration ?? this.audioDuration,
      rating: rating ?? this.rating
    );
  }

  factory FoodStallModel.fromJson(Map<String, dynamic> json) {
    return FoodStallModel(
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      description: json['description'] as String? ?? '',
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      distance: json['distance'] as double?,
      triggerRadius: json['triggerRadius'] as int? ?? 0,
      audioUrl: json['audioUrl'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      minPrice: json['minPrice'] as int?,
      maxPrice: json['maxPrice'] as int?,
      featuredReview: json['featuredReview'] as List<String>? ?? [],
      audioDuration: json['audioDuration'] as int? ?? 0,
      rating: json['rating'] as double? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'triggerRadius': triggerRadius,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'featuredReview': featuredReview,
      'audioDuration': audioDuration,
      'rating': rating,
    };
  }
}