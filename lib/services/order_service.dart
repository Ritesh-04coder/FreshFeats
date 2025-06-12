import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/menu_item_model.dart';
import '../models/order_model.dart';
import './supabase_service.dart';
import 'supabase_service.dart';

// lib/services/order_service.dart

class OrderService {
  final SupabaseService _supabaseService = SupabaseService();
  final Dio _dio = Dio();

  OrderService() {
    _setupDio();
  }

  void _setupDio() {
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $anonKey',
    };
  }

  // Create a new order
  Future<Order> createOrder({
    required String restaurantId,
    required List<CartItem> items,
    required Map<String, dynamic> deliveryAddress,
    String? deliveryInstructions,
    String? promoCode,
    required String paymentMethod,
  }) async {
    try {
      final client = await _supabaseService.client;
      final userId = _supabaseService.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Calculate totals
      final subtotal =
          items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
      final deliveryFee = await _calculateDeliveryFee(restaurantId);
      final taxAmount = (subtotal + deliveryFee) * 0.08; // 8% tax

      double discountAmount = 0.0;
      if (promoCode != null && promoCode.isNotEmpty) {
        final promoData = await _validatePromoCode(promoCode, subtotal);
        if (promoData != null) {
          discountAmount = promoData['discount_amount'];
        }
      }

      final totalAmount = subtotal + deliveryFee + taxAmount - discountAmount;
      final orderNumber = _generateOrderNumber();

      // Create order
      final orderData = {
        'user_id': userId,
        'restaurant_id': restaurantId,
        'order_number': orderNumber,
        'status': OrderStatus.pending.value,
        'subtotal': subtotal,
        'delivery_fee': deliveryFee,
        'tax_amount': taxAmount,
        'discount_amount': discountAmount,
        'total_amount': totalAmount,
        'payment_method': paymentMethod,
        'payment_status': PaymentStatus.pending.value,
        'delivery_address': deliveryAddress,
        'delivery_instructions': deliveryInstructions,
        'promo_code': promoCode,
        'estimated_delivery_time':
            DateTime.now().add(const Duration(minutes: 35)).toIso8601String(),
      };

      final orderResponse =
          await client.from('orders').insert(orderData).select().single();
      final orderId = orderResponse['id'] as String;

      // Create order items
      final orderItems = items
          .map((item) => {
                'order_id': orderId,
                'menu_item_id': item.menuItemId,
                'quantity': item.quantity,
                'unit_price': item.unitPrice,
                'total_price': item.totalPrice,
                'customizations': item.customizations,
                'special_instructions': item.specialInstructions,
              })
          .toList();

      await client.from('order_items').insert(orderItems);

      // Create initial tracking entry
      await client.from('order_tracking').insert({
        'order_id': orderId,
        'status': OrderStatus.pending.value,
        'notes': 'Order placed successfully',
      });

      return Order.fromJson(orderResponse);
    } catch (error) {
      throw Exception('Failed to create order: $error');
    }
  }

  // Process payment
  Future<Map<String, dynamic>> processPayment({
    required String orderId,
    required double amount,
    required String paymentMethodId,
    String currency = 'usd',
  }) async {
    try {
      final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
      final functionUrl = '$supabaseUrl/functions/v1/stripe-payment';

      final response = await _dio.post(functionUrl, data: {
        'orderId': orderId,
        'amount': amount,
        'currency': currency,
        'paymentMethodId': paymentMethodId,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['error'] ?? 'Payment failed');
        }
      } else {
        throw Exception('Payment request failed');
      }
    } catch (error) {
      throw Exception('Payment processing failed: $error');
    }
  }

  // Get user's orders
  Future<List<Order>> getUserOrders({int? limit, int? offset}) async {
    try {
      final client = await _supabaseService.client;
      final userId = _supabaseService.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      var query = client.from('orders').select('''
            *,
            restaurants(id, name, cuisine_type, image_url),
            order_items(
              *,
              menu_items(id, name, image_url, price)
            )
          ''').eq('user_id', userId).order('created_at', ascending: false);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (offset != null) {
        query = query.range(offset, offset + (limit ?? 10) - 1);
      }

      final response = await query;
      return response.map<Order>((json) => Order.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch orders: $error');
    }
  }

  // Get order by ID with full details
  Future<Order?> getOrderById(String orderId) async {
    try {
      final client = await _supabaseService.client;
      final userId = _supabaseService.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final response = await client.from('orders').select('''
            *,
            restaurants(id, name, cuisine_type, image_url, address),
            order_items(
              *,
              menu_items(id, name, image_url, price, description)
            )
          ''').eq('id', orderId).eq('user_id', userId).single();

      return Order.fromJson(response);
    } catch (error) {
      throw Exception('Failed to fetch order: $error');
    }
  }

  // Get order tracking
  Future<List<OrderTracking>> getOrderTracking(String orderId) async {
    try {
      final client = await _supabaseService.client;
      final response = await client.from('order_tracking').select('''
            *,
            drivers(id, full_name, phone_number, vehicle_type, vehicle_number, rating)
          ''').eq('order_id', orderId).order('timestamp', ascending: true);

      return response
          .map<OrderTracking>((json) => OrderTracking.fromJson(json))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch order tracking: $error');
    }
  }

  // Cancel order
  Future<void> cancelOrder(String orderId) async {
    try {
      final client = await _supabaseService.client;
      final userId = _supabaseService.currentUser?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Update order status
      await client
          .from('orders')
          .update({
            'status': OrderStatus.cancelled.value,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId)
          .eq('user_id', userId);

      // Add tracking entry
      await client.from('order_tracking').insert({
        'order_id': orderId,
        'status': OrderStatus.cancelled.value,
        'notes': 'Order cancelled by customer',
      });
    } catch (error) {
      throw Exception('Failed to cancel order: $error');
    }
  }

  // Subscribe to order updates
  void subscribeToOrderUpdates(String orderId, Function(dynamic) callback) {
    final client = _supabaseService.syncClient;
    client
        .channel('order_updates_$orderId')
        .onPostgresChanges(
          event: 'all',
          schema: 'public',
          table: 'order_tracking',
          filter: 'order_id=eq.$orderId',
          callback: callback,
        )
        .subscribe();
  }

  // Helper methods
  Future<double> _calculateDeliveryFee(String restaurantId) async {
    try {
      final client = await _supabaseService.client;
      final response = await client
          .from('restaurants')
          .select('delivery_fee')
          .eq('id', restaurantId)
          .single();

      return (response['delivery_fee'] as num).toDouble();
    } catch (error) {
      return 2.99; // Default delivery fee
    }
  }

  Future<Map<String, dynamic>?> _validatePromoCode(
      String code, double amount) async {
    try {
      final client = await _supabaseService.client;
      final response = await client
          .from('promo_codes')
          .select('*')
          .eq('code', code.toUpperCase())
          .eq('is_active', true)
          .lte('min_order_amount', amount)
          .maybeSingle();

      if (response != null) {
        final discountType = response['discount_type'] as String;
        final discountValue = (response['discount_value'] as num).toDouble();

        double discountAmount = 0.0;
        if (discountType == 'percentage') {
          discountAmount = amount * (discountValue / 100);
        } else {
          discountAmount = discountValue;
        }

        return {
          'discount_amount': discountAmount,
          'discount_type': discountType,
        };
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  String _generateOrderNumber() {
    final random = Random();
    final timestamp =
        DateTime.now().millisecondsSinceEpoch.toString().substring(6);
    final randomSuffix = (1000 + random.nextInt(9000)).toString();
    return 'ORD$timestamp$randomSuffix';
  }
}

// Cart item model for order creation
class CartItem {
  final String menuItemId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final List<Map<String, dynamic>> customizations;
  final String? specialInstructions;

  CartItem({
    required this.menuItemId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.customizations,
    this.specialInstructions,
  });
}