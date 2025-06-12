import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class MenuItemCardWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const MenuItemCardWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: item['image'] as String,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['name'] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item['customizable'] as bool)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.tertiary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Customizable',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      item['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${(item['price'] as num).toStringAsFixed(2)}',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            if (item['spiceLevel'] != 'none' &&
                                item['spiceLevel'] != null)
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'local_fire_department',
                                      color: item['spiceLevel'] == 'hot'
                                          ? AppTheme
                                              .lightTheme.colorScheme.error
                                          : AppTheme
                                              .lightTheme.colorScheme.tertiary,
                                      size: 16,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      item['spiceLevel'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'ADD',
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
