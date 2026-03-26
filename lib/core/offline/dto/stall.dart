// ── stall_dto.dart ────────────────────────────────────────────────────────────
// Auto-generated DTO matching the stall API response shape.
// Supports: vi, zh, ja, ko, en

enum StallLanguage { vi, zh, ja, ko, en }

enum LocalizationStatus { complete, partial, none }

enum StallStatus { active, inactive }

// ── StallDto ──────────────────────────────────────────────────────────────────

class StallDto {
  final int id;
  final String name;
  final String address;
  final String description;
  final double latitude;
  final double longitude;
  final int triggerRadius;
  final String audioUrl;
  final String? imageUrl;
  final int minPrice;
  final int maxPrice;
  final int audioDuration;
  final List<String> featuredReviews;
  final double? rating;
  final StallLanguage usedLanguage;
  final LocalizationStatus localizationStatus;
  final int priority;
  final StallStatus status;

  const StallDto({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.triggerRadius,
    required this.audioUrl,
    this.imageUrl,
    required this.minPrice,
    required this.maxPrice,
    required this.audioDuration,
    required this.featuredReviews,
    this.rating,
    required this.usedLanguage,
    required this.localizationStatus,
    required this.priority,
    required this.status,
  });

  factory StallDto.fromJson(Map<String, dynamic> json) {
    return StallDto(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      triggerRadius: json['triggerRadius'] as int,
      audioUrl: json['audioUrl'] as String,
      imageUrl: json['imageUrl'] as String?,
      minPrice: json['minPrice'] as int,
      maxPrice: json['maxPrice'] as int,
      audioDuration: json['audioDuration'] as int,
      featuredReviews: (json['featuredReviews'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      usedLanguage: _parseLanguage(json['usedLanguage'] as String),
      localizationStatus:
      _parseLocalizationStatus(json['localizationStatus'] as String),
      priority: json['priority'] as int,
      status: _parseStatus(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
    'triggerRadius': triggerRadius,
    'audioUrl': audioUrl,
    'imageUrl': imageUrl,
    'minPrice': minPrice,
    'maxPrice': maxPrice,
    'audioDuration': audioDuration,
    'featuredReviews': featuredReviews,
    'rating': rating,
    'usedLanguage': usedLanguage.name,
    'localizationStatus': localizationStatus.name.toUpperCase(),
    'priority': priority,
    'status': status.name.toUpperCase(),
  };

  StallDto copyWith({
    int? id,
    String? name,
    String? address,
    String? description,
    double? latitude,
    double? longitude,
    int? triggerRadius,
    String? audioUrl,
    String? imageUrl,
    int? minPrice,
    int? maxPrice,
    int? audioDuration,
    List<String>? featuredReviews,
    double? rating,
    StallLanguage? usedLanguage,
    LocalizationStatus? localizationStatus,
    int? priority,
    StallStatus? status,
  }) {
    return StallDto(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      triggerRadius: triggerRadius ?? this.triggerRadius,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      audioDuration: audioDuration ?? this.audioDuration,
      featuredReviews: featuredReviews ?? this.featuredReviews,
      rating: rating ?? this.rating,
      usedLanguage: usedLanguage ?? this.usedLanguage,
      localizationStatus: localizationStatus ?? this.localizationStatus,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  // ── parsers ─────────────────────────────────────────────────────────────────

  static StallLanguage _parseLanguage(String raw) {
    return switch (raw.toLowerCase()) {
      'vi' => StallLanguage.vi,
      'zh' => StallLanguage.zh,
      'ja' => StallLanguage.ja,
      'ko' => StallLanguage.ko,
      'en' => StallLanguage.en,
      _ => StallLanguage.en,
    };
  }

  static LocalizationStatus _parseLocalizationStatus(String raw) {
    return switch (raw.toUpperCase()) {
      'COMPLETE' => LocalizationStatus.complete,
      'PARTIAL'  => LocalizationStatus.partial,
      _          => LocalizationStatus.none,
    };
  }

  static StallStatus _parseStatus(String raw) {
    return switch (raw.toUpperCase()) {
      'ACTIVE'   => StallStatus.active,
      'INACTIVE' => StallStatus.inactive,
      _          => StallStatus.inactive,
    };
  }

  @override
  String toString() =>
      'StallDto(id: $id, name: $name, lang: ${usedLanguage.name}, priority: $priority)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is StallDto && other.id == id && other.usedLanguage == usedLanguage);

  @override
  int get hashCode => Object.hash(id, usedLanguage);
}

// ── StallListResponse ─────────────────────────────────────────────────────────
// Wraps the top-level list response from the API.

class StallListResponse {
  final List<StallDto> stalls;
  final StallLanguage language;

  const StallListResponse({
    required this.stalls,
    required this.language,
  });

  /// Parse directly from a JSON array (the format your API returns).
  factory StallListResponse.fromJsonList(
      List<dynamic> jsonList,
      StallLanguage language,
      ) {
    return StallListResponse(
      language: language,
      stalls: jsonList
          .map((e) => StallDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convenience: sort by priority ascending (0 = highest priority).
  List<StallDto> get sortedByPriority =>
      [...stalls]..sort((a, b) => a.priority.compareTo(b.priority));

  /// Find a single stall by id.
  StallDto? findById(int id) =>
      stalls.cast<StallDto?>().firstWhere((s) => s?.id == id, orElse: () => null);
}

// ── MultiLanguageStallMap ─────────────────────────────────────────────────────
// Holds all language variants of the stall list together.
// Useful if you fetch all languages up-front and switch locally.

class MultiLanguageStallMap {
  final Map<StallLanguage, List<StallDto>> _data;

  const MultiLanguageStallMap(this._data);

  factory MultiLanguageStallMap.fromRaw(
      Map<StallLanguage, List<dynamic>> raw) {
    return MultiLanguageStallMap({
      for (final entry in raw.entries)
        entry.key: entry.value
            .map((e) => StallDto.fromJson(e as Map<String, dynamic>))
            .toList(),
    });
  }

  List<StallDto> forLanguage(StallLanguage lang) => _data[lang] ?? [];

  /// Get a specific stall by id in a specific language.
  StallDto? getStall(int id, StallLanguage lang) =>
      forLanguage(lang).cast<StallDto?>().firstWhere(
            (s) => s?.id == id,
        orElse: () => null,
      );

  /// Get all language variants for a single stall id.
  Map<StallLanguage, StallDto> getAllVariants(int id) {
    return {
      for (final entry in _data.entries)
        if (entry.value.any((s) => s.id == id))
          entry.key: entry.value.firstWhere((s) => s.id == id),
    };
  }

  Set<StallLanguage> get availableLanguages => _data.keys.toSet();
}