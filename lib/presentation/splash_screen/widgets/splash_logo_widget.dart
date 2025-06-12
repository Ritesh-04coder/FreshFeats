import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SplashLogoWidget extends StatelessWidget {
  const SplashLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),

          // Main food delivery icon
          CustomIconWidget(
            iconName: 'delivery_dining',
            color: AppTheme.lightTheme.primaryColor,
            size: 48,
          ),

          // Small accent icon
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppTheme.successLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'restaurant',
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
