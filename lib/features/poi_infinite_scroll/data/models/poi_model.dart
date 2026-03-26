import 'package:automatic_demonstration/features/poi_infinite_scroll/data/models/lat_lng.dart';

/// Point of Interest model for the infinite scroll list.
class POI {
  /// Unique identifier.
  final String id;

  /// Display name.
  final String name;

  /// Address or location description.
  final String address;

  /// Category (e.g., restaurant, cafe, shop).
  final String category;

  /// Geographic coordinates.
  final LatLng location;

  /// Image URL for thumbnail.
  final String? imageUrl;

  /// Rating (0.0 - 5.0).
  final double rating;

  /// Number of reviews.
  final int reviewCount;

  /// Whether the POI is currently open.
  final bool? isOpen;

  /// Additional metadata.
  final Map<String, dynamic>? metadata;

  const POI({
    required this.id,
    required this.name,
    required this.address,
    required this.category,
    required this.location,
    this.imageUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isOpen,
    this.metadata,
  });

  factory POI.fromJson(Map<String, dynamic> json) {
    return POI(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      category: json['category'] as String? ?? 'other',
      location: LatLng(
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      ),
      imageUrl: json['imageUrl'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      isOpen: json['isOpen'] as bool?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'category': category,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'imageUrl': imageUrl,
        'rating': rating,
        'reviewCount': reviewCount,
        'isOpen': isOpen,
        'metadata': metadata,
      };

  POI copyWith({
    String? id,
    String? name,
    String? address,
    String? category,
    LatLng? location,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    bool? isOpen,
    Map<String, dynamic>? metadata,
  }) {
    return POI(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      category: category ?? this.category,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isOpen: isOpen ?? this.isOpen,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is POI && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'POI($id: $name)';
}
