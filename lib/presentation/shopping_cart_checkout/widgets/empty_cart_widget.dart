import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback onBrowseRestaurants;

  const EmptyCartWidget({
    super.key,
    required this.onBrowseRestaurants,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty Cart Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'shopping_cart',
                color: AppTheme.primaryLight,
                size: 60,
              ),
            ),
            const SizedBox(height: 32),

            // Empty State Title
            Text(
              'Your cart is empty',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Empty State Description
            Text(
              'Looks like you haven\'t added any items to your cart yet. Browse our delicious menu and find something you love!',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Browse Restaurants Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onBrowseRestaurants,
                icon: CustomIconWidget(
                  iconName: 'restaurant',
                  color: AppTheme.onPrimaryLight,
                  size: 20,
                ),
                label: Text('Browse Restaurants'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Secondary Action
            TextButton.icon(
              onPressed: () {
                // Navigate to previous orders or favorites
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Feature coming soon!'),
                    backgroundColor: AppTheme.warningLight,
                  ),
                );
              },
              icon: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.primaryLight,
                size: 18,
              ),
              label: Text('View Order History'),
            ),
          ],
        ),
      ),
    );
  }
}
