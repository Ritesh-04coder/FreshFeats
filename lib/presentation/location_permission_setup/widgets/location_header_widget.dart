import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LocationHeaderWidget extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback? onBack;

  const LocationHeaderWidget({
    super.key,
    required this.onSkip,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onBack != null)
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 20,
              ),
            ),
          )
        else
          const SizedBox(width: 36),
        Text(
          'Location Setup',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: onSkip,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(
            'Skip',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
