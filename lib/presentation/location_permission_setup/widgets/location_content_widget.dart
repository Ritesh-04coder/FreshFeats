import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LocationContentWidget extends StatelessWidget {
  final bool isLoading;
  final String errorMessage;

  const LocationContentWidget({
    super.key,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isLoading ? 'Finding your location...' : 'Enable Location Access',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          isLoading
              ? 'Please wait while we locate you for the best restaurant recommendations.'
              : 'Find nearby restaurants and track deliveries with precision. We\'ll show you the best food options in your area.',
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        if (errorMessage.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error_outline',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
