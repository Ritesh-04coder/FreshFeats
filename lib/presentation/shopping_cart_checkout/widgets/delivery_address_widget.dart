import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class DeliveryAddressWidget extends StatelessWidget {
  final Map<String, dynamic> address;
  final VoidCallback onChangeAddress;

  const DeliveryAddressWidget({
    super.key,
    required this.address,
    required this.onChangeAddress,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Address',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              TextButton(
                onPressed: onChangeAddress,
                child: Text('Change'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName:
                      address['isDefault'] == true ? 'home' : 'location_on',
                  color: AppTheme.primaryLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address['title'] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${address['address']}, ${address['city']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
