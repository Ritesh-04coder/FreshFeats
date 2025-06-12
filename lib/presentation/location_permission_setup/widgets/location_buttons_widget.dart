import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LocationButtonsWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onEnableLocation;
  final VoidCallback onManualEntry;

  const LocationButtonsWidget({
    super.key,
    required this.isLoading,
    required this.onEnableLocation,
    required this.onManualEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onEnableLocation,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.primaryColor,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                else
                  CustomIconWidget(
                    iconName: 'my_location',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                const SizedBox(width: 12),
                Text(
                  isLoading ? 'Getting Location...' : 'Enable Location',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isLoading ? null : onManualEntry,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: AppTheme.lightTheme.primaryColor,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'edit_location',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Enter Address Manually',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
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
