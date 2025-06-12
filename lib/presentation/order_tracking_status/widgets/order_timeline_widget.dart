import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderTimelineWidget extends StatelessWidget {
  final List timeline;

  const OrderTimelineWidget({
    super.key,
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
            'Order Timeline',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          ...List.generate(timeline.length, (index) {
            final item = timeline[index] as Map<String, dynamic>;
            final isLast = index == timeline.length - 1;
            return _buildTimelineItem(item, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> item, bool isLast) {
    final isCompleted = item["completed"] as bool;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Indicator
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
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
                      size: 12,
                    )
                  : Container(),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 6.h,
                color: isCompleted
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
              ),
          ],
        ),
        SizedBox(width: 4.w),

        // Timeline Content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 3.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item["status"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? AppTheme.lightTheme.colorScheme.onSurface
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    Text(
                      item["time"] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  item["description"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
