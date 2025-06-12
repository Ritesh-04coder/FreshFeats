import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class OrderSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double promoDiscount;
  final double total;

  const OrderSummaryWidget({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.promoDiscount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),

          // Subtotal
          _buildSummaryRow(
            'Subtotal',
            '\$${subtotal.toStringAsFixed(2)}',
            isRegular: true,
          ),
          const SizedBox(height: 8),

          // Delivery Fee
          _buildSummaryRow(
            'Delivery Fee',
            '\$${deliveryFee.toStringAsFixed(2)}',
            isRegular: true,
          ),
          const SizedBox(height: 8),

          // Tax
          _buildSummaryRow(
            'Tax',
            '\$${tax.toStringAsFixed(2)}',
            isRegular: true,
          ),

          // Promo Discount (if applied)
          if (promoDiscount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Promo Discount',
              '-\$${promoDiscount.toStringAsFixed(2)}',
              isRegular: true,
              isDiscount: true,
            ),
          ],

          const SizedBox(height: 12),
          Divider(color: AppTheme.dividerLight),
          const SizedBox(height: 12),

          // Total
          _buildSummaryRow(
            'Total',
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String amount, {
    bool isRegular = false,
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTheme.lightTheme.textTheme.titleMedium
              : AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryLight,
                ),
        ),
        Text(
          amount,
          style: isTotal
              ? AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w600,
                )
              : AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isDiscount
                      ? AppTheme.successLight
                      : AppTheme.textPrimaryLight,
                  fontWeight: FontWeight.w500,
                ),
        ),
      ],
    );
  }
}
