import '../models/menu_item_model.dart';
import '../models/restaurant_model.dart';
import './supabase_service.dart';

// lib/services/restaurant_service.dart

class RestaurantService {
  final SupabaseService _supabaseService = SupabaseService();

  // Get all restaurants with optional filtering
  Future<List<Restaurant>> getRestaurants({
    String? cuisineType,
    double? minRating,
    double? maxDeliveryFee,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    try {
      final client = await _supabaseService.client;
      var query = client.from('restaurants').select('*').eq('is_active', true);

      if (cuisineType != null && cuisineType != 'All') {
        query = query.ilike('cuisine_type', '%$cuisineType%');
      }

      if (minRating != null) {
        query = query.gte('rating', minRating);
      }

      if (maxDeliveryFee != null) {
        query = query.lte('delivery_fee', maxDeliveryFee);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query
            .or('name.ilike.%$searchQuery%,cuisine_type.ilike.%$searchQuery%');
      }

      // Fix: Use a temporary variable for order operation
      var orderedQuery = query.order('rating', ascending: false);

      if (limit != null) {
        orderedQuery = orderedQuery.limit(limit);
      }

      if (offset != null) {
        orderedQuery = orderedQuery.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await orderedQuery;
      return response
          .map<Restaurant>((json) => Restaurant.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch restaurants: $error');
    }
  }

  // Get restaurant by ID with menu items
  Future<Restaurant?> getRestaurantById(String restaurantId) async {
    try {
      final client = await _supabaseService.client;
      final response = await client
          .from('restaurants')
          .select('*')
          .eq('id', restaurantId)
          .eq('is_active', true)
          .single();

      return Restaurant.fromJson(response);
    } catch (error) {
      throw Exception('Failed to fetch restaurant: $error');
    }
  }

  // Get menu items for a restaurant
  Future<List<MenuItem>> getMenuItems(String restaurantId,
      {String? categoryId}) async {
    try {
      final client = await _supabaseService.client;
      var query = client
          .from('menu_items')
          .select('*')
          .eq('restaurant_id', restaurantId)
          .eq('is_available', true);

      if (categoryId != null) {
        query = query.eq('category_id', categoryId);
      }

      // Fix: Use a temporary variable for order operation
      var orderedQuery = query.order('display_order');

      final response = await orderedQuery;
      return response.map<MenuItem>((json) => MenuItem.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch menu items: $error');
    }
  }

  // Get menu categories for a restaurant
  Future<List<Map<String, dynamic>>> getMenuCategories(
      String restaurantId) async {
    try {
      final client = await _supabaseService.client;
      final response = await client
          .from('menu_categories')
          .select('*')
          .eq('restaurant_id', restaurantId)
          .eq('is_active', true)
          .order('display_order');

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch menu categories: $error');
    }
  }

  // Add restaurant to favorites
  Future<void> addToFavorites(String restaurantId) async {
    try {
      final client = await _supabaseService.client;
      final userId = _supabaseService.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await client.from('user_favorites').insert({
        'user_id': userId,
        'restaurant_id': restaurantId,
      });
    } catch (error) {
      throw Exception('Failed to add to favorites: $error');
    }
  }

  // Remove restaurant from favorites
  Future<void> removeFromFavorites(String restaurantId) async {
    try {
      final client = await _supabaseService.client;
      final userId = _supabaseService.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await client
          .from('user_favorites')
          .delete()
          .eq('user_id', userId)
          .eq('restaurant_id', restaurantId);
    } catch (error) {
      throw Exception('Failed to remove from favorites: $error');
    }
  }

  // Get user's favorite restaurants
  Future<List<Restaurant>> getFavoriteRestaurants() async {
    try {
      final client = await _supabaseService.client;
      final userId = _supabaseService.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await client
          .from('user_favorites')
          .select('restaurants(*)')
          .eq('user_id', userId);

      return response
          .map<Restaurant>((item) => Restaurant.fromJson(item['restaurants']))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch favorite restaurants: $error');
    }
  }

  // Check if restaurant is in favorites
  Future<bool> isFavorite(String restaurantId) async {
    try {
      final client = await _supabaseService.client;
      final userId = _supabaseService.currentUser?.id;

      if (userId == null) {
        return false;
      }

      final response = await client
          .from('user_favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('restaurant_id', restaurantId)
          .maybeSingle();

      return response != null;
    } catch (error) {
      return false;
    }
  }

  // Get restaurants with favorite status
  Future<List<Restaurant>> getRestaurantsWithFavorites({
    String? cuisineType,
    double? minRating,
    double? maxDeliveryFee,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    try {
      final restaurants = await getRestaurants(
        cuisineType: cuisineType,
        minRating: minRating,
        maxDeliveryFee: maxDeliveryFee,
        searchQuery: searchQuery,
        limit: limit,
        offset: offset,
      );

      // Check favorite status for each restaurant
      final restaurantsWithFavorites = <Restaurant>[];
      for (final restaurant in restaurants) {
        final isFav = await isFavorite(restaurant.id);
        restaurantsWithFavorites.add(restaurant.copyWith(isFavorite: isFav));
      }

      return restaurantsWithFavorites;
    } catch (error) {
      throw Exception('Failed to fetch restaurants with favorites: $error');
    }
  }

  // Validate promo code
  Future<Map<String, dynamic>?> validatePromoCode(
      String promoCode, double orderAmount) async {
    try {
      final client = await _supabaseService.client;
      final response = await client
          .from('promo_codes')
          .select('*')
          .eq('code', promoCode.toUpperCase())
          .eq('is_active', true)
          .gte('min_order_amount', orderAmount)
          .lte('valid_from', DateTime.now().toIso8601String())
          .or('valid_until.is.null,valid_until.gte.${DateTime.now().toIso8601String()}')
          .maybeSingle();

      if (response != null) {
        final discountType = response['discount_type'] as String;
        final discountValue = (response['discount_value'] as num).toDouble();
        final maxDiscount =
            (response['max_discount_amount'] as num?)?.toDouble();

        double discountAmount = 0.0;
        if (discountType == 'percentage') {
          discountAmount = orderAmount * (discountValue / 100);
          if (maxDiscount != null && discountAmount > maxDiscount) {
            discountAmount = maxDiscount;
          }
        } else {
          discountAmount = discountValue;
        }

        return {
          'id': response['id'],
          'code': response['code'],
          'description': response['description'],
          'discount_amount': discountAmount,
          'discount_type': discountType,
          'discount_value': discountValue,
        };
      }

      return null;
    } catch (error) {
      throw Exception('Failed to validate promo code: $error');
    }
  }
}