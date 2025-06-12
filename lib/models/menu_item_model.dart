// lib/models/menu_item_model.dart
class MenuItem {
  final String id;
  final String restaurantId;
  final String? categoryId;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final bool isAvailable;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final List<String> allergens;
  final List<CustomizationOption> customizationOptions;
  final Map<String, dynamic>? nutritionInfo;
  final int preparationTime;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuItem({
    required this.id,
    required this.restaurantId,
    this.categoryId,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.isAvailable,
    required this.isVegetarian,
    required this.isVegan,
    required this.isGlutenFree,
    required this.allergens,
    required this.customizationOptions,
    this.nutritionInfo,
    required this.preparationTime,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      restaurantId: json['restaurant_id'] as String,
      categoryId: json['category_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
      isVegetarian: json['is_vegetarian'] as bool? ?? false,
      isVegan: json['is_vegan'] as bool? ?? false,
      isGlutenFree: json['is_gluten_free'] as bool? ?? false,
      allergens: List<String>.from(json['allergens'] ?? []),
      customizationOptions: (json['customization_options'] as List<dynamic>?)
              ?.map((option) => CustomizationOption.fromJson(option))
              .toList() ??
          [],
      nutritionInfo: json['nutrition_info'] as Map<String, dynamic>?,
      preparationTime: json['preparation_time'] as int? ?? 15,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'is_available': isAvailable,
      'is_vegetarian': isVegetarian,
      'is_vegan': isVegan,
      'is_gluten_free': isGlutenFree,
      'allergens': allergens,
      'customization_options':
          customizationOptions.map((option) => option.toJson()).toList(),
      'nutrition_info': nutritionInfo,
      'preparation_time': preparationTime,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get priceFormatted => '\$${price.toStringAsFixed(2)}';

  List<String> get dietaryInfo {
    List<String> info = [];
    if (isVegetarian) info.add('Vegetarian');
    if (isVegan) info.add('Vegan');
    if (isGlutenFree) info.add('Gluten-Free');
    return info;
  }

  String get preparationTimeFormatted => '$preparationTime min';
}

class CustomizationOption {
  final String name;
  final List<String> options;
  final bool required;
  final bool multiSelect;
  final double? additionalPrice;

  CustomizationOption({
    required this.name,
    required this.options,
    required this.required,
    this.multiSelect = false,
    this.additionalPrice,
  });

  factory CustomizationOption.fromJson(Map<String, dynamic> json) {
    return CustomizationOption(
      name: json['name'] as String,
      options: List<String>.from(json['options']),
      required: json['required'] as bool? ?? false,
      multiSelect: json['multi_select'] as bool? ?? false,
      additionalPrice: (json['additional_price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'options': options,
      'required': required,
      'multi_select': multiSelect,
      'additional_price': additionalPrice,
    };
  }
}
