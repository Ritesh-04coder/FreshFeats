import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class RestaurantCardWidget extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onFavoriteToggle;

  const RestaurantCardWidget({
    super.key,
    required this.restaurant,
    required this.onTap,
    required this.onLongPress,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: CustomImageWidget(
            imageUrl: restaurant['image'] as String,
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        if (restaurant['hasPromo'] as bool)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                restaurant['promoText'] as String,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: restaurant['isFavorite'] as bool
                    ? 'favorite'
                    : 'favorite_border',
                color: restaurant['isFavorite'] as bool
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  restaurant['name'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              _buildRatingWidget(),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            restaurant['cuisine'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'access_time',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                restaurant['deliveryTime'] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              CustomIconWidget(
                iconName: 'delivery_dining',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                restaurant['deliveryFee'] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                restaurant['distance'] as String,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingWidget() {
    final rating = restaurant['rating'] as double;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'star',
            color: AppTheme.lightTheme.colorScheme.tertiary,
            size: 12,
          ),
          const SizedBox(width: 2),
          Text(
            rating.toString(),
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
