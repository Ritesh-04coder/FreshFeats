import './driver_model.dart';
import './menu_item_model.dart';
import './restaurant_model.dart';

// lib/models/order_model.dart
class Order {
  final String id;
  final String userId;
  final String restaurantId;
  final String orderNumber;
  final OrderStatus status;
  final double subtotal;
  final double deliveryFee;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final String? paymentMethod;
  final PaymentStatus paymentStatus;
  final String? paymentIntentId;
  final Map<String, dynamic> deliveryAddress;
  final String? deliveryInstructions;
  final DateTime? estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final String? promoCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem>? items;
  final Restaurant? restaurant;
  final Driver? driver;
  final List<OrderTracking>? tracking;

  Order({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.orderNumber,
    required this.status,
    required this.subtotal,
    required this.deliveryFee,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    this.paymentMethod,
    required this.paymentStatus,
    this.paymentIntentId,
    required this.deliveryAddress,
    this.deliveryInstructions,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.promoCode,
    required this.createdAt,
    required this.updatedAt,
    this.items,
    this.restaurant,
    this.driver,
    this.tracking,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      restaurantId: json['restaurant_id'] as String,
      orderNumber: json['order_number'] as String,
      status: OrderStatus.fromString(json['status'] as String),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      taxAmount: (json['tax_amount'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String?,
      paymentStatus: PaymentStatus.fromString(json['payment_status'] as String),
      paymentIntentId: json['payment_intent_id'] as String?,
      deliveryAddress: json['delivery_address'] as Map<String, dynamic>,
      deliveryInstructions: json['delivery_instructions'] as String?,
      estimatedDeliveryTime: json['estimated_delivery_time'] != null
          ? DateTime.parse(json['estimated_delivery_time'] as String)
          : null,
      actualDeliveryTime: json['actual_delivery_time'] != null
          ? DateTime.parse(json['actual_delivery_time'] as String)
          : null,
      promoCode: json['promo_code'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      items: json['order_items'] != null
          ? (json['order_items'] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList()
          : null,
      restaurant: json['restaurants'] != null
          ? Restaurant.fromJson(json['restaurants'])
          : null,
    );
  }

  String get statusDisplayName => status.displayName;
  String get paymentStatusDisplayName => paymentStatus.displayName;
  String get totalAmountFormatted => '\$${totalAmount.toStringAsFixed(2)}';
  String get deliveryAddressFormatted {
    return '${deliveryAddress['street'] ?? ''}, ${deliveryAddress['city'] ?? ''} ${deliveryAddress['state'] ?? ''} ${deliveryAddress['zipcode'] ?? ''}';
  }

  bool get canBeCancelled {
    return status == OrderStatus.pending ||
        status == OrderStatus.confirmed ||
        status == OrderStatus.preparing;
  }

  bool get isCompleted => status == OrderStatus.delivered;
  bool get isActive => !isCompleted && status != OrderStatus.cancelled;
}

class OrderItem {
  final String id;
  final String orderId;
  final String menuItemId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final List<Map<String, dynamic>> customizations;
  final String? specialInstructions;
  final DateTime createdAt;
  final MenuItem? menuItem;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.customizations,
    this.specialInstructions,
    required this.createdAt,
    this.menuItem,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      menuItemId: json['menu_item_id'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      customizations:
          List<Map<String, dynamic>>.from(json['customizations'] ?? []),
      specialInstructions: json['special_instructions'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      menuItem: json['menu_items'] != null
          ? MenuItem.fromJson(json['menu_items'])
          : null,
    );
  }

  String get totalPriceFormatted => '\$${totalPrice.toStringAsFixed(2)}';
  String get unitPriceFormatted => '\$${unitPrice.toStringAsFixed(2)}';
}

class OrderTracking {
  final String id;
  final String orderId;
  final String? driverId;
  final OrderStatus status;
  final Map<String, double>? location;
  final String? notes;
  final DateTime timestamp;
  final Driver? driver;

  OrderTracking({
    required this.id,
    required this.orderId,
    this.driverId,
    required this.status,
    this.location,
    this.notes,
    required this.timestamp,
    this.driver,
  });

  factory OrderTracking.fromJson(Map<String, dynamic> json) {
    return OrderTracking(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      driverId: json['driver_id'] as String?,
      status: OrderStatus.fromString(json['status'] as String),
      location: json['location'] != null
          ? Map<String, double>.from(json['location'])
          : null,
      notes: json['notes'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      driver: json['drivers'] != null ? Driver.fromJson(json['drivers']) : null,
    );
  }
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  outForDelivery,
  delivered,
  cancelled;

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'out_for_delivery':
      case 'out for delivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  String get value {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.ready:
        return 'ready';
      case OrderStatus.outForDelivery:
        return 'out_for_delivery';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready for Pickup';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

enum PaymentStatus {
  pending,
  processing,
  succeeded,
  failed,
  cancelled;

  static PaymentStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'processing':
        return PaymentStatus.processing;
      case 'succeeded':
        return PaymentStatus.succeeded;
      case 'failed':
        return PaymentStatus.failed;
      case 'cancelled':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.pending;
    }
  }

  String get value {
    switch (this) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.processing:
        return 'processing';
      case PaymentStatus.succeeded:
        return 'succeeded';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Payment Pending';
      case PaymentStatus.processing:
        return 'Processing Payment';
      case PaymentStatus.succeeded:
        return 'Payment Successful';
      case PaymentStatus.failed:
        return 'Payment Failed';
      case PaymentStatus.cancelled:
        return 'Payment Cancelled';
    }
  }
}

// Import other models
