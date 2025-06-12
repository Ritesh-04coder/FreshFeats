// lib/models/driver_model.dart
class Driver {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? licenseNumber;
  final double rating;
  final int totalDeliveries;
  final bool isAvailable;
  final Map<String, double>? currentLocation;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? photoUrl;

  Driver({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.vehicleType,
    this.vehicleNumber,
    this.licenseNumber,
    required this.rating,
    required this.totalDeliveries,
    required this.isAvailable,
    this.currentLocation,
    required this.createdAt,
    required this.updatedAt,
    this.photoUrl,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phoneNumber: json['phone_number'] as String,
      vehicleType: json['vehicle_type'] as String?,
      vehicleNumber: json['vehicle_number'] as String?,
      licenseNumber: json['license_number'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      totalDeliveries: json['total_deliveries'] as int? ?? 0,
      isAvailable: json['is_available'] as bool? ?? false,
      currentLocation: json['current_location'] != null
          ? Map<String, double>.from(json['current_location'])
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      photoUrl: json['photo_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'license_number': licenseNumber,
      'rating': rating,
      'total_deliveries': totalDeliveries,
      'is_available': isAvailable,
      'current_location': currentLocation,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'photo_url': photoUrl,
    };
  }

  String get ratingFormatted => rating.toStringAsFixed(1);

  String get vehicleInfo {
    if (vehicleType != null && vehicleNumber != null) {
      return '$vehicleType - $vehicleNumber';
    }
    return 'Vehicle info not available';
  }

  String get deliveriesText {
    if (totalDeliveries == 1) {
      return '1 delivery';
    }
    return '$totalDeliveries deliveries';
  }

  Driver copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? vehicleType,
    String? vehicleNumber,
    String? licenseNumber,
    double? rating,
    int? totalDeliveries,
    bool? isAvailable,
    Map<String, double>? currentLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? photoUrl,
  }) {
    return Driver(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      rating: rating ?? this.rating,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
      isAvailable: isAvailable ?? this.isAvailable,
      currentLocation: currentLocation ?? this.currentLocation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
