import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/cart_item_widget.dart';
import './widgets/delivery_address_widget.dart';
import './widgets/empty_cart_widget.dart';
import './widgets/order_summary_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/promo_code_widget.dart';

class ShoppingCartCheckout extends StatefulWidget {
  const ShoppingCartCheckout({super.key});

  @override
  State<ShoppingCartCheckout> createState() => _ShoppingCartCheckoutState();
}

class _ShoppingCartCheckoutState extends State<ShoppingCartCheckout> {
  bool _isLoading = false;
  String _selectedPaymentMethod = 'card';
  String _promoCode = '';
  double _promoDiscount = 0.0;

  // Mock cart data
  final List<Map<String, dynamic>> _cartItems = [
    {
      "id": 1,
      "name": "Margherita Pizza",
      "description": "Fresh tomatoes, mozzarella, basil",
      "price": 12.99,
      "quantity": 2,
      "customizations": ["Extra cheese", "Thin crust"],
      "image":
          "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop"
    },
    {
      "id": 2,
      "name": "Caesar Salad",
      "description": "Crisp romaine, parmesan, croutons",
      "price": 8.99,
      "quantity": 1,
      "customizations": ["No anchovies"],
      "image":
          "https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=300&fit=crop"
    },
    {
      "id": 3,
      "name": "Chicken Wings",
      "description": "Buffalo sauce, celery sticks",
      "price": 10.99,
      "quantity": 1,
      "customizations": ["Extra spicy"],
      "image":
          "https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=400&h=300&fit=crop"
    }
  ];

  // Mock restaurant data
  final Map<String, dynamic> _restaurantData = {
    "name": "Tony's Italian Kitchen",
    "estimatedDelivery": "25-35 min",
    "deliveryFee": 2.99,
    "taxRate": 0.08
  };

  // Mock delivery address
  final Map<String, dynamic> _deliveryAddress = {
    "title": "Home",
    "address": "123 Main Street, Apt 4B",
    "city": "New York, NY 10001",
    "isDefault": true
  };

  // Mock payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      "id": "card_1",
      "type": "card",
      "title": "Visa ending in 4242",
      "icon": "credit_card",
      "isDefault": true
    },
    {
      "id": "apple_pay",
      "type": "digital_wallet",
      "title": "Apple Pay",
      "icon": "account_balance_wallet",
      "isDefault": false
    },
    {
      "id": "google_pay",
      "type": "digital_wallet",
      "title": "Google Pay",
      "icon": "account_balance_wallet",
      "isDefault": false
    }
  ];

  double get _subtotal {
    return _cartItems.fold(
        0.0,
        (sum, item) =>
            sum + ((item['price'] as double) * (item['quantity'] as int)));
  }

  double get _deliveryFee => _restaurantData['deliveryFee'] as double;

  double get _tax {
    return (_subtotal + _deliveryFee) * (_restaurantData['taxRate'] as double);
  }

  double get _total {
    return _subtotal + _deliveryFee + _tax - _promoDiscount;
  }

  void _removeCartItem(int itemId) {
    HapticFeedback.mediumImpact();
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == itemId);
    });
  }

  void _updateQuantity(int itemId, int newQuantity) {
    if (newQuantity <= 0) {
      _removeCartItem(itemId);
      return;
    }

    setState(() {
      final itemIndex = _cartItems.indexWhere((item) => item['id'] == itemId);
      if (itemIndex != -1) {
        _cartItems[itemIndex]['quantity'] = newQuantity;
      }
    });
  }

  void _applyPromoCode(String code) {
    // Mock promo code validation
    if (code.toLowerCase() == 'save10') {
      setState(() {
        _promoCode = code;
        _promoDiscount = _subtotal * 0.1; // 10% discount
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Promo code applied! You saved \$${_promoDiscount.toStringAsFixed(2)}'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid promo code'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    }
  }

  void _selectPaymentMethod(String methodId) {
    setState(() {
      _selectedPaymentMethod = methodId;
    });
  }

  Future<void> _placeOrder() async {
    if (_cartItems.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Mock order processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed successfully! Order #12345'),
          backgroundColor: AppTheme.successLight,
        ),
      );

      // Navigate to order tracking
      Navigator.pushNamed(context, '/order-tracking-status');
    }
  }

  void _addMoreItems() {
    Navigator.pushNamed(context, '/restaurant-detail-menu');
  }

  void _changeAddress() {
    // Mock address selection
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Delivery Address',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'home',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              title: Text('Current Address'),
              subtitle: Text(
                  '${_deliveryAddress['address']}, ${_deliveryAddress['city']}'),
              trailing: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.primaryLight,
                size: 24,
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Add New Address'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _restaurantData['name'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            Text(
              'Delivery in ${_restaurantData['estimatedDelivery']}',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimaryLight,
            size: 24,
          ),
        ),
        elevation: 1,
        backgroundColor: AppTheme.surfaceLight,
      ),
      body: _cartItems.isEmpty
          ? EmptyCartWidget(
              onBrowseRestaurants: () =>
                  Navigator.pushNamed(context, '/restaurant-browse-discovery'))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cart Items Section
                        Text(
                          'Your Order',
                          style: AppTheme.lightTheme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _cartItems.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = _cartItems[index];
                            return CartItemWidget(
                              item: item,
                              onQuantityChanged: (quantity) =>
                                  _updateQuantity(item['id'] as int, quantity),
                              onRemove: () =>
                                  _removeCartItem(item['id'] as int),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Add More Items Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _addMoreItems,
                            icon: CustomIconWidget(
                              iconName: 'add',
                              color: AppTheme.primaryLight,
                              size: 20,
                            ),
                            label: Text('Add More Items'),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Delivery Address Section
                        DeliveryAddressWidget(
                          address: _deliveryAddress,
                          onChangeAddress: _changeAddress,
                        ),
                        const SizedBox(height: 24),

                        // Promo Code Section
                        PromoCodeWidget(
                          onApplyPromoCode: _applyPromoCode,
                          appliedCode: _promoCode,
                        ),
                        const SizedBox(height: 24),

                        // Order Summary Section
                        OrderSummaryWidget(
                          subtotal: _subtotal,
                          deliveryFee: _deliveryFee,
                          tax: _tax,
                          promoDiscount: _promoDiscount,
                          total: _total,
                        ),
                        const SizedBox(height: 24),

                        // Payment Method Section
                        PaymentMethodWidget(
                          paymentMethods: _paymentMethods,
                          selectedMethodId: _selectedPaymentMethod,
                          onMethodSelected: _selectPaymentMethod,
                        ),
                        const SizedBox(height: 100), // Space for bottom button
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _placeOrder,
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.onPrimaryLight),
                            ),
                          )
                        : Text('Place Order • \$${_total.toStringAsFixed(2)}'),
                  ),
                ),
              ),
            ),
    );
  }
}
