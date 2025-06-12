import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class RestaurantHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantHeaderWidget({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        CustomImageWidget(
          imageUrl: restaurant['image'] as String,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
            ),
          ),
        ),
        // Restaurant Information
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restaurant['name'] as String,
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${restaurant['rating']}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '(${restaurant['reviewCount']})',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(width: 16),
                  CustomIconWidget(
                    iconName: 'access_time',
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    restaurant['deliveryTime'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Min. order ${restaurant['minimumOrder']}',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
