import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DriverDetailsCardWidget extends StatelessWidget {
  final Map<String, dynamic> driverData;
  final VoidCallback onCallDriver;
  final VoidCallback onMessageDriver;

  const DriverDetailsCardWidget({
    super.key,
    required this.driverData,
    required this.onCallDriver,
    required this.onMessageDriver,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
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
          Text(
            'Your Delivery Driver',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              // Driver Photo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: driverData["photo"] as String,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 4.w),

              // Driver Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverData["name"] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${driverData["rating"]}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '•',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            driverData["vehicle"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCallDriver,
                  icon: CustomIconWidget(
                    iconName: 'phone',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 18,
                  ),
                  label: Text('Call Driver'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onMessageDriver,
                  icon: CustomIconWidget(
                    iconName: 'message',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 18,
                  ),
                  label: Text('Message'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
