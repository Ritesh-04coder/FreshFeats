import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderSummaryCardWidget extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;

  const OrderSummaryCardWidget({
    super.key,
    required this.orderData,
    required this.isExpanded,
    required this.onToggleExpansion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
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
        children: [
          // Header
          InkWell(
            onTap: onToggleExpansion,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Restaurant Image
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: orderData["restaurantImage"] as String,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),

                  // Order Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderData["restaurantName"] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Order #${orderData["orderId"]}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Total Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        orderData["totalAmount"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      CustomIconWidget(
                        iconName: isExpanded
                            ? 'keyboard_arrow_up'
                            : 'keyboard_arrow_down',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expandable Content
          if (isExpanded) ...[
            Divider(
              height: 1,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Items',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Order Items
                  ...(orderData["items"] as List).map((item) {
                    final itemData = item as Map<String, dynamic>;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                '${itemData["quantity"]}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              itemData["name"] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            itemData["price"] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  SizedBox(height: 2.h),
                  Divider(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                  SizedBox(height: 1.h),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        orderData["totalAmount"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
