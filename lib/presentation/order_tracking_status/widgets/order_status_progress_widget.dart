import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderStatusProgressWidget extends StatelessWidget {
  final String currentStatus;
  final List timeline;

  const OrderStatusProgressWidget({
    super.key,
    required this.currentStatus,
    required this.timeline,
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
            'Order Status',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(timeline.length, (index) {
        final item = timeline[index] as Map<String, dynamic>;
        final isCompleted = item["completed"] as bool;
        final isLast = index == timeline.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Status Circle
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? CustomIconWidget(
                              iconName: 'check',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 16,
                            )
                          : Container(),
                    ),
                    SizedBox(height: 1.h),
                    // Status Text
                    Text(
                      item["status"] as String,
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isCompleted
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        fontWeight:
                            isCompleted ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Progress Line
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: EdgeInsets.only(bottom: 4.h),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
