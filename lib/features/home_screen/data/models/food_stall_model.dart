import 'dart:ui';

import 'package:automatic_demonstration/core/config/env_config.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class FoodStallModel {
  final int id;
  final String name;
  final String address;
  final String description;
  final double latitude;
  final double longitude;
  final double? distance;
  final int triggerRadius;
  final String audioUrl;
  final int audioDuration;
  final String imageUrl;
  final int? minPrice;
  final int? maxPrice;
  final List<String> featuredReview;
  final double rating;
  final bool isTriggered;
  final Color? iconColor;
  final int? priority;

  FoodStallModel({
    this.id = 0,
    this.name = '',
    this.address = '',
    this.description = '',
    required this.latitude,
    required this.longitude,
    this.distance,
    this.triggerRadius = 0,
    this.audioUrl = '',
    this.audioDuration = 0,
    this.imageUrl = '',
    this.minPrice,
    this.maxPrice,
    this.featuredReview = const [],
    this.rating = 0.0,
    this.isTriggered = false,
    this.iconColor,
    this.priority,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  FoodStallModel copyWith({
    int? id,
    String? name,
    String? address,
    String? description,
    double? latitude,
    double? longitude,
    double? distance,
    int? triggerRadius,
    String? audioUrl,
    int? audioDuration,
    String? imageUrl,
    int? minPrice,
    int? maxPrice,
    List<String>? featuredReview,
    double? rating,
    bool? isTriggered,
    int? priority,
  }) {
    return FoodStallModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distance: distance ?? this.distance,
      triggerRadius: triggerRadius ?? this.triggerRadius,
      audioUrl: audioUrl ?? this.audioUrl,
      audioDuration: audioDuration ?? this.audioDuration,
      imageUrl: imageUrl ?? this.imageUrl,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      featuredReview: featuredReview ?? this.featuredReview,
      rating: rating ?? this.rating,
      isTriggered: isTriggered ?? this.isTriggered,
      priority: priority ?? this.priority,
    );
  }

  factory FoodStallModel.fromJson(Map<String, dynamic> json) {
    String resolveUrl(String url, {bool isAudio = false}) {
      if (url.isEmpty) return url;

      // Fix cases where absolute URL is provided but missing /audio/ path
      if (url.startsWith('http') || url.startsWith('https')) {
        if (isAudio && !url.contains('/audio/') && url.endsWith('.mp3')) {
          final uri = Uri.parse(url);
          return '${uri.origin}/audio${uri.path}';
        }
        return url;
      }

      final baseUrl = EnvConfig.baseFileUrl;
      if (baseUrl.isEmpty) return url;

      if (isAudio) {
        // Assume local audio assets from DB usually miss the /audio/ prefix
        final path = url.startsWith('/audio/')
            ? url
            : (url.startsWith('/') ? '/audio$url' : '/audio/$url');
        return '$baseUrl$path';
      } else {
        // Standard resolution for images etc.
        final path = url.startsWith('/') ? url : '/$url';
        return '$baseUrl$path';
      }
    }

    return FoodStallModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      description: json['description'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      triggerRadius: json['triggerRadius'] as int? ?? 0,
      audioUrl: resolveUrl(json['audioUrl'] as String? ?? '', isAudio: true),
      audioDuration: json['audioDuration'] as int? ?? 0,
      imageUrl: resolveUrl(json['imageUrl'] as String? ?? ''),
      minPrice: json['minPrice'] as int?,
      maxPrice: json['maxPrice'] as int?,
      featuredReview:
          (json['featuredReviews'] as List<dynamic>? ??
                  json['featuredReview'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      rating: (json['rating'] as num? ?? 0).toDouble(),
      isTriggered: json['isTriggered'] as bool? ?? false,
      priority: json['priority'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'triggerRadius': triggerRadius,
      'audioUrl': audioUrl,
      'audioDuration': audioDuration,
      'imageUrl': imageUrl,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'featuredReview': featuredReview,
      'rating': rating,
      'isTriggered': isTriggered,
      'priority': priority,
    };
  }
}
