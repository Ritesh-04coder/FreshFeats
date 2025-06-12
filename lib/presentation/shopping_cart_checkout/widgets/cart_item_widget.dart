import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CartItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final int quantity = item['quantity'] as int;
    final double price = item['price'] as double;
    final List<String> customizations =
        (item['customizations'] as List).cast<String>();

    return Dismissible(
      key: Key('cart_item_${item['id']}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Remove Item'),
            content: Text(
                'Are you sure you want to remove this item from your cart?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Remove'),
              ),
            ],
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppTheme.errorLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomIconWidget(
          iconName: 'delete',
          color: AppTheme.onErrorLight,
          size: 24,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
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
            const SizedBox(width: 12),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] as String,
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Customizations
                  if (customizations.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: customizations
                          .map((customization) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryLight
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  customization,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.primaryLight,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Price and Quantity Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${(price * quantity).toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // Quantity Controls
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.dividerLight),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => onQuantityChanged(quantity - 1),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: CustomIconWidget(
                                  iconName: 'remove',
                                  color: quantity > 1
                                      ? AppTheme.textPrimaryLight
                                      : AppTheme.textDisabledLight,
                                  size: 16,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                quantity.toString(),
                                style: AppTheme.lightTheme.textTheme.titleSmall,
                              ),
                            ),
                            InkWell(
                              onTap: () => onQuantityChanged(quantity + 1),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: CustomIconWidget(
                                  iconName: 'add',
                                  color: AppTheme.textPrimaryLight,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
