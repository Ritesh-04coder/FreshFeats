// lib/models/restaurant_model.dart
class Restaurant {
  final String id;
  final String name;
  final String? description;
  final String cuisineType;
  final String? imageUrl;
  final double rating;
  final int totalReviews;
  final double deliveryFee;
  final double minOrderAmount;
  final int estimatedDeliveryTimeMin;
  final int estimatedDeliveryTimeMax;
  final bool isActive;
  final Map<String, dynamic>? address;
  final List<String> features;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final double? distance;

  Restaurant({
    required this.id,
    required this.name,
    this.description,
    required this.cuisineType,
    this.imageUrl,
    required this.rating,
    required this.totalReviews,
    required this.deliveryFee,
    required this.minOrderAmount,
    required this.estimatedDeliveryTimeMin,
    required this.estimatedDeliveryTimeMax,
    required this.isActive,
    this.address,
    required this.features,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.distance,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      cuisineType: json['cuisine_type'] as String,
      imageUrl: json['image_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0.0,
      minOrderAmount: (json['min_order_amount'] as num?)?.toDouble() ?? 0.0,
      estimatedDeliveryTimeMin:
          json['estimated_delivery_time_min'] as int? ?? 30,
      estimatedDeliveryTimeMax:
          json['estimated_delivery_time_max'] as int? ?? 45,
      isActive: json['is_active'] as bool? ?? true,
      address: json['address'] as Map<String, dynamic>?,
      features: List<String>.from(json['features'] ?? []),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isFavorite: json['is_favorite'] as bool? ?? false,
      distance: (json['distance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cuisine_type': cuisineType,
      'image_url': imageUrl,
      'rating': rating,
      'total_reviews': totalReviews,
      'delivery_fee': deliveryFee,
      'min_order_amount': minOrderAmount,
      'estimated_delivery_time_min': estimatedDeliveryTimeMin,
      'estimated_delivery_time_max': estimatedDeliveryTimeMax,
      'is_active': isActive,
      'address': address,
      'features': features,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper methods for UI display
  String get deliveryTimeRange =>
      '$estimatedDeliveryTimeMin-$estimatedDeliveryTimeMax min';

  String get deliveryFeeFormatted => deliveryFee == 0
      ? 'Free delivery'
      : '\$${deliveryFee.toStringAsFixed(2)}';

  String get minOrderFormatted => '\$${minOrderAmount.toStringAsFixed(2)}';

  String get ratingFormatted => rating.toStringAsFixed(1);

  String get addressFormatted {
    if (address == null) return 'Address not available';
    return '${address!['street'] ?? ''}, ${address!['city'] ?? ''} ${address!['state'] ?? ''}';
  }

  bool get hasPromo =>
      features.contains('free_delivery') || features.contains('popular');

  String get promoText {
    if (features.contains('free_delivery')) return 'Free Delivery';
    if (features.contains('popular')) return '20% OFF';
    return '';
  }

  Restaurant copyWith({
    String? id,
    String? name,
    String? description,
    String? cuisineType,
    String? imageUrl,
    double? rating,
    int? totalReviews,
    double? deliveryFee,
    double? minOrderAmount,
    int? estimatedDeliveryTimeMin,
    int? estimatedDeliveryTimeMax,
    bool? isActive,
    Map<String, dynamic>? address,
    List<String>? features,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    double? distance,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cuisineType: cuisineType ?? this.cuisineType,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      estimatedDeliveryTimeMin:
          estimatedDeliveryTimeMin ?? this.estimatedDeliveryTimeMin,
      estimatedDeliveryTimeMax:
          estimatedDeliveryTimeMax ?? this.estimatedDeliveryTimeMax,
      isActive: isActive ?? this.isActive,
      address: address ?? this.address,
      features: features ?? this.features,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      distance: distance ?? this.distance,
    );
  }
}
