import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/driver_details_card_widget.dart';
import './widgets/order_status_progress_widget.dart';
import './widgets/order_summary_card_widget.dart';
import './widgets/order_timeline_widget.dart';
import './widgets/tracking_map_widget.dart';

class OrderTrackingStatus extends StatefulWidget {
  const OrderTrackingStatus({super.key});

  @override
  State<OrderTrackingStatus> createState() => _OrderTrackingStatusState();
}

class _OrderTrackingStatusState extends State<OrderTrackingStatus> {
  bool _isOrderSummaryExpanded = false;
  bool _isLoading = false;
  final String _currentStatus = 'Out for Delivery';
  final String _estimatedDeliveryTime = '25-30 mins';

  // Mock order data
  final Map<String, dynamic> orderData = {
    "orderId": "ORD123456",
    "restaurantName": "Bella Italia Restaurant",
    "restaurantImage":
        "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400&h=300&fit=crop",
    "totalAmount": "\$42.50",
    "orderStatus": "Out for Delivery",
    "estimatedTime": "25-30 mins",
    "items": [
      {"name": "Margherita Pizza", "quantity": 1, "price": "\$18.99"},
      {"name": "Caesar Salad", "quantity": 1, "price": "\$12.99"},
      {"name": "Garlic Bread", "quantity": 2, "price": "\$8.99"}
    ],
    "driver": {
      "name": "Michael Rodriguez",
      "photo":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face",
      "rating": 4.8,
      "vehicle": "Honda Civic - ABC 123",
      "phone": "+1 (555) 123-4567"
    },
    "deliveryAddress": "123 Main Street, Apt 4B, New York, NY 10001",
    "timeline": [
      {
        "status": "Order Confirmed",
        "time": "2:15 PM",
        "description": "Your order has been confirmed by the restaurant",
        "completed": true
      },
      {
        "status": "Preparing",
        "time": "2:25 PM",
        "description": "Restaurant is preparing your delicious meal",
        "completed": true
      },
      {
        "status": "Out for Delivery",
        "time": "2:45 PM",
        "description": "Your order is on the way with Michael",
        "completed": true
      },
      {
        "status": "Delivered",
        "time": "3:10 PM",
        "description": "Enjoy your meal!",
        "completed": false
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshTrackingData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Order Status Progress
              OrderStatusProgressWidget(
                currentStatus: _currentStatus,
                timeline: orderData["timeline"] as List,
              ),

              SizedBox(height: 2.h),

              // Estimated Delivery Time
              _buildEstimatedTimeCard(),

              SizedBox(height: 2.h),

              // Interactive Map
              TrackingMapWidget(
                restaurantName: orderData["restaurantName"] as String,
                deliveryAddress: orderData["deliveryAddress"] as String,
                driverLocation: const {"lat": 40.7589, "lng": -73.9851},
                isLoading: _isLoading,
              ),

              SizedBox(height: 2.h),

              // Driver Details Card
              if (orderData["driver"] != null)
                DriverDetailsCardWidget(
                  driverData: orderData["driver"] as Map<String, dynamic>,
                  onCallDriver: _callDriver,
                  onMessageDriver: _messageDriver,
                ),

              SizedBox(height: 2.h),

              // Order Timeline
              OrderTimelineWidget(
                timeline: orderData["timeline"] as List,
              ),

              SizedBox(height: 2.h),

              // Order Summary Card
              OrderSummaryCardWidget(
                orderData: orderData,
                isExpanded: _isOrderSummaryExpanded,
                onToggleExpansion: () {
                  setState(() {
                    _isOrderSummaryExpanded = !_isOrderSummaryExpanded;
                  });
                },
              ),

              SizedBox(height: 2.h),

              // Action Buttons
              _buildActionButtons(),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Track Order',
        style: AppTheme.lightTheme.textTheme.titleLarge,
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _refreshTrackingData,
          icon: CustomIconWidget(
            iconName: 'refresh',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildEstimatedTimeCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'access_time',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Delivery Time',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _estimatedDeliveryTime,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          if (_currentStatus != 'Delivered' && _canCancelOrder())
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _showCancelOrderDialog,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.error,
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                child: Text('Cancel Order'),
              ),
            ),
          if (_currentStatus == 'Delivered') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rateExperience,
                child: Text('Rate Experience'),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _downloadReceipt,
                child: Text('Download Receipt'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _canCancelOrder() {
    return _currentStatus == 'Order Confirmed' || _currentStatus == 'Preparing';
  }

  Future<void> _refreshTrackingData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tracking information updated'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _callDriver() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${orderData["driver"]["name"]}...'),
        action: SnackBarAction(
          label: 'Cancel',
          onPressed: () {},
        ),
      ),
    );
  }

  void _messageDriver() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${orderData["driver"]["name"]}...'),
      ),
    );
  }

  void _showCancelOrderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Order'),
          content: Text(
              'Are you sure you want to cancel this order? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Keep Order'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _cancelOrder();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text('Cancel Order'),
            ),
          ],
        );
      },
    );
  }

  void _cancelOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
            'Order cancelled successfully. Refund will be processed within 3-5 business days.'),
        duration: Duration(seconds: 4),
      ),
    );

    // Navigate back after cancellation
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  void _rateExperience() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening rating screen...'),
      ),
    );
  }

  void _downloadReceipt() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt downloaded to your device'),
      ),
    );
  }
}
