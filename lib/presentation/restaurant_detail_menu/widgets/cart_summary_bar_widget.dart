import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CartSummaryBarWidget extends StatelessWidget {
  final int itemCount;
  final double total;
  final VoidCallback onViewCart;

  const CartSummaryBarWidget({
    super.key,
    required this.itemCount,
    required this.total,
    required this.onViewCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onViewCart,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$itemCount',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Cart',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${itemCount == 1 ? '1 item' : '$itemCount items'} added',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        SizedBox(width: 4),
                        CustomIconWidget(
                          iconName: 'arrow_forward',
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
